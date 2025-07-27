<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

// Data file path - make sure this directory is writable
$dataFile = __DIR__ . '/data/restaurants.json';
$dataDir = dirname($dataFile);

// Create data directory if it doesn't exist
if (!is_dir($dataDir)) {
    mkdir($dataDir, 0755, true);
}

// Initialize data file if it doesn't exist
if (!file_exists($dataFile)) {
    $initialData = [
        'restaurants' => [],
        'lastUpdated' => date('c'),
        'version' => '1.0'
    ];
    file_put_contents($dataFile, json_encode($initialData, JSON_PRETTY_PRINT));
}

// Get the HTTP method and action
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';

try {
    switch ($method) {
        case 'GET':
            // Get all restaurants
            if (file_exists($dataFile)) {
                $data = json_decode(file_get_contents($dataFile), true);
                echo json_encode($data);
            } else {
                echo json_encode(['restaurants' => [], 'lastUpdated' => date('c')]);
            }
            break;

        case 'POST':
            // Save/update restaurants data
            $input = file_get_contents('php://input');
            $data = json_decode($input, true);
            
            if ($data && isset($data['restaurants'])) {
                $data['lastUpdated'] = date('c');
                $data['version'] = '1.0';
                
                if (file_put_contents($dataFile, json_encode($data, JSON_PRETTY_PRINT))) {
                    echo json_encode([
                        'status' => 'success', 
                        'message' => 'Data saved successfully',
                        'count' => count($data['restaurants']),
                        'lastUpdated' => $data['lastUpdated']
                    ]);
                } else {
                    http_response_code(500);
                    echo json_encode(['status' => 'error', 'message' => 'Failed to save data']);
                }
            } else {
                http_response_code(400);
                echo json_encode(['status' => 'error', 'message' => 'Invalid data format']);
            }
            break;

        case 'PUT':
            // Update a specific restaurant
            $input = file_get_contents('php://input');
            $updateData = json_decode($input, true);
            
            if (!$updateData || !isset($updateData['id'])) {
                http_response_code(400);
                echo json_encode(['status' => 'error', 'message' => 'Restaurant ID required']);
                break;
            }
            
            $data = json_decode(file_get_contents($dataFile), true);
            $restaurantId = $updateData['id'];
            $found = false;
            
            for ($i = 0; $i < count($data['restaurants']); $i++) {
                if ($data['restaurants'][$i]['id'] == $restaurantId) {
                    $data['restaurants'][$i] = array_merge($data['restaurants'][$i], $updateData);
                    $data['restaurants'][$i]['lastModified'] = date('c');
                    $found = true;
                    break;
                }
            }
            
            if ($found) {
                $data['lastUpdated'] = date('c');
                file_put_contents($dataFile, json_encode($data, JSON_PRETTY_PRINT));
                echo json_encode(['status' => 'success', 'message' => 'Restaurant updated']);
            } else {
                http_response_code(404);
                echo json_encode(['status' => 'error', 'message' => 'Restaurant not found']);
            }
            break;

        case 'DELETE':
            // Delete a specific restaurant
            $restaurantId = $_GET['id'] ?? null;
            
            if (!$restaurantId) {
                http_response_code(400);
                echo json_encode(['status' => 'error', 'message' => 'Restaurant ID required']);
                break;
            }
            
            $data = json_decode(file_get_contents($dataFile), true);
            $originalCount = count($data['restaurants']);
            
            $data['restaurants'] = array_filter($data['restaurants'], function($restaurant) use ($restaurantId) {
                return $restaurant['id'] != $restaurantId;
            });
            
            // Re-index array
            $data['restaurants'] = array_values($data['restaurants']);
            
            if (count($data['restaurants']) < $originalCount) {
                $data['lastUpdated'] = date('c');
                file_put_contents($dataFile, json_encode($data, JSON_PRETTY_PRINT));
                echo json_encode(['status' => 'success', 'message' => 'Restaurant deleted']);
            } else {
                http_response_code(404);
                echo json_encode(['status' => 'error', 'message' => 'Restaurant not found']);
            }
            break;

        default:
            http_response_code(405);
            echo json_encode(['status' => 'error', 'message' => 'Method not allowed']);
            break;
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'status' => 'error', 
        'message' => 'Server error: ' . $e->getMessage()
    ]);
}
?>

#!/bin/bash

# AL Eats Setup Script for GitHub Codespace
# This script creates all necessary files and folders for AL Eats deployment on TrueNAS SCALE

set -e

echo "🍽️  Setting up AL Eats - Restaurant Tracker"
echo "=========================================="

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p app
mkdir -p data
mkdir -p scripts

echo "✅ Directories created successfully"

# Create index.html (Main Application)
echo "📝 Creating index.html..."
cat > app/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AL Eats</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(45deg, #ff6b6b, #ffa500);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }

        .header p {
            opacity: 0.9;
            font-size: 1.1rem;
        }

        .sync-info {
            background: #e8f5e8;
            border: 1px solid #4caf50;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            color: #2e7d32;
            text-align: center;
        }

        .sync-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .sync-status.online {
            background: #e8f5e8;
            color: #2e7d32;
        }

        .sync-status.offline {
            background: #ffebee;
            color: #c62828;
        }

        .sync-status.syncing {
            background: #fff3e0;
            color: #ef6c00;
        }

        .form-section {
            padding: 30px;
            background: white;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            padding: 12px;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }

        .priority-selector {
            display: flex;
            gap: 10px;
        }

        .priority-option {
            flex: 1;
            padding: 10px;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
        }

        .priority-option.selected {
            border-color: #667eea;
            background: #667eea;
            color: white;
        }

        .priority-high.selected {
            border-color: #ff6b6b;
            background: #ff6b6b;
        }

        .priority-medium.selected {
            border-color: #ffa500;
            background: #ffa500;
        }

        .priority-low.selected {
            border-color: #4ecdc4;
            background: #4ecdc4;
        }

        .add-btn {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 15px 30px;
            font-size: 18px;
            font-weight: 600;
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
            margin-right: 10px;
        }

        .add-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }

        .cancel-btn {
            background: #6c757d;
            color: white;
            border: none;
            padding: 15px 30px;
            font-size: 18px;
            font-weight: 600;
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .cancel-btn:hover {
            background: #5a6268;
        }

        .restaurants-section {
            padding: 30px;
            background: #f8f9fa;
        }

        .controls-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .filter-controls {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 10px 20px;
            border: 2px solid #e1e5e9;
            background: white;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-btn.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .export-import-controls {
            display: flex;
            gap: 10px;
        }

        .utility-btn {
            padding: 8px 16px;
            border: 1px solid #667eea;
            background: white;
            color: #667eea;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .utility-btn:hover {
            background: #667eea;
            color: white;
        }

        .restaurants-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
        }

        .restaurant-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border-left: 5px solid transparent;
            cursor: grab;
            position: relative;
        }

        .restaurant-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.12);
        }

        .restaurant-card.dragging {
            opacity: 0.5;
            transform: rotate(5deg);
            cursor: grabbing;
        }

        .restaurant-card.priority-high {
            border-left-color: #ff6b6b;
        }

        .restaurant-card.priority-medium {
            border-left-color: #ffa500;
        }

        .restaurant-card.priority-low {
            border-left-color: #4ecdc4;
        }

        .drag-handle {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 1.2rem;
            color: #ccc;
            cursor: grab;
        }

        .drag-handle:hover {
            color: #667eea;
        }

        .restaurant-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 10px;
            margin-right: 30px;
        }

        .restaurant-name {
            font-size: 1.3rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
        }

        .restaurant-cuisine {
            color: #666;
            font-style: italic;
        }

        .priority-badge {
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .priority-badge.high {
            background: #ffe6e6;
            color: #ff6b6b;
        }

        .priority-badge.medium {
            background: #fff4e6;
            color: #ffa500;
        }

        .priority-badge.low {
            background: #e6fffe;
            color: #4ecdc4;
        }

        .suggested-by-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-left: 10px;
        }

        .suggested-by-badge.ashley {
            background: #f3e5f5;
            color: #7b1fa2;
        }

        .suggested-by-badge.luke {
            background: #e3f2fd;
            color: #1976d2;
        }

        .restaurant-details {
            margin: 15px 0;
        }

        .restaurant-location {
            color: #666;
            margin-bottom: 5px;
        }

        .restaurant-notes {
            color: #555;
            line-height: 1.4;
            margin-top: 10px;
        }

        .restaurant-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            flex-wrap: wrap;
        }

        .action-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .visit-btn {
            background: #4ecdc4;
            color: white;
        }

        .visit-btn:hover {
            background: #45b7b8;
        }

        .map-btn {
            background: #667eea;
            color: white;
        }

        .map-btn:hover {
            background: #5a6fd8;
        }

        .edit-btn {
            background: #ffa500;
            color: white;
        }

        .edit-btn:hover {
            background: #e6940a;
        }

        .delete-btn {
            background: #ff6b6b;
            color: white;
        }

        .delete-btn:hover {
            background: #ff5252;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
        }

        .hidden {
            display: none;
        }

        #fileInput {
            display: none;
        }

        .status-message {
            padding: 10px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .status-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .filter-controls {
                justify-content: center;
            }
            
            .restaurants-grid {
                grid-template-columns: 1fr;
            }
            
            .controls-bar {
                flex-direction: column;
                align-items: stretch;
            }
            
            .export-import-controls {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🍽️ AL Eats</h1>
            <p>Discover and track amazing places to dine together</p>
        </div>

        <div class="form-section">
            <div class="sync-info">
                <div class="sync-status online" id="syncStatus">
                    🟢 <span>Connected - Data syncs across all devices</span>
                </div>
            </div>
            
            <div id="statusMessage"></div>
            <form id="restaurantForm">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="name">Restaurant Name</label>
                        <input type="text" id="name" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="cuisine">Cuisine Type</label>
                        <input type="text" id="cuisine" placeholder="Italian, Mexican, Thai...">
                    </div>
                    
                    <div class="form-group">
                        <label for="location">Location</label>
                        <input type="text" id="location" placeholder="Address or neighborhood">
                    </div>
                    
                    <div class="form-group">
                        <label for="url">Website/Menu URL</label>
                        <input type="url" id="url" placeholder="https://restaurant-website.com">
                    </div>
                    
                    <div class="form-group">
                        <label for="suggestedBy">Suggested By</label>
                        <select id="suggestedBy" required>
                            <option value="">Select person...</option>
                            <option value="Ashley">Ashley</option>
                            <option value="Luke">Luke</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Priority Level</label>
                        <div class="priority-selector">
                            <div class="priority-option priority-high" data-priority="high">High</div>
                            <div class="priority-option priority-medium selected" data-priority="medium">Medium</div>
                            <div class="priority-option priority-low" data-priority="low">Low</div>
                        </div>
                        <input type="hidden" id="priority" value="medium">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="notes">Notes</label>
                    <textarea id="notes" placeholder="Special dishes, recommendations, or why you want to try this place..."></textarea>
                </div>
                
                <div>
                    <button type="submit" class="add-btn" id="submitBtn">Add Restaurant</button>
                    <button type="button" class="cancel-btn hidden" id="cancelBtn">Cancel Edit</button>
                </div>
            </form>
        </div>

        <div class="restaurants-section">
            <div class="controls-bar">
                <div class="filter-controls">
                    <div class="filter-btn active" data-filter="all">All Restaurants</div>
                    <div class="filter-btn" data-filter="high">High Priority</div>
                    <div class="filter-btn" data-filter="medium">Medium Priority</div>
                    <div class="filter-btn" data-filter="low">Low Priority</div>
                    <div class="filter-btn" data-filter="ashley">Ashley's Picks</div>
                    <div class="filter-btn" data-filter="luke">Luke's Picks</div>
                </div>
                
                <div class="export-import-controls">
                    <button class="utility-btn" onclick="tracker.exportData()">Export Data</button>
                    <button class="utility-btn" onclick="document.getElementById('fileInput').click()">Import Data</button>
                    <input type="file" id="fileInput" accept=".json" onchange="tracker.importData(event)">
                </div>
            </div>

            <div class="restaurants-grid" id="restaurantsGrid">
                <div class="empty-state">
                    <h3>No restaurants yet!</h3>
                    <p>Add your first restaurant above to get started.</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        class RestaurantTracker {
            constructor() {
                this.restaurants = [];
                this.currentFilter = 'all';
                this.editingId = null;
                this.draggedElement = null;
                this.apiUrl = './api.php';
                this.isOnline = true;
                this.initializeEventListeners();
                this.loadData();
                this.startSyncCheck();
            }

            initializeEventListeners() {
                // Form submission
                document.getElementById('restaurantForm').addEventListener('submit', (e) => {
                    e.preventDefault();
                    if (this.editingId) {
                        this.updateRestaurant();
                    } else {
                        this.addRestaurant();
                    }
                });

                // Cancel edit button
                document.getElementById('cancelBtn').addEventListener('click', () => {
                    this.cancelEdit();
                });

                // Priority selector
                document.querySelectorAll('.priority-option').forEach(option => {
                    option.addEventListener('click', () => {
                        document.querySelectorAll('.priority-option').forEach(o => o.classList.remove('selected'));
                        option.classList.add('selected');
                        document.getElementById('priority').value = option.dataset.priority;
                    });
                    
                    card.addEventListener('dragend', () => {
                        card.classList.remove('dragging');
                        this.draggedElement = null;
                    });
                    
                    card.addEventListener('dragover', (e) => {
                        e.preventDefault();
                        e.dataTransfer.dropEffect = 'move';
                    });
                    
                    card.addEventListener('drop', (e) => {
                        e.preventDefault();
                        if (this.draggedElement && this.draggedElement !== card) {
                            const draggedId = parseInt(this.draggedElement.dataset.id);
                            const targetId = parseInt(card.dataset.id);
                            const rect = card.getBoundingClientRect();
                            const midpoint = rect.top + rect.height / 2;
                            const position = e.clientY < midpoint ? 'before' : 'after';
                            
                            this.moveRestaurant(draggedId, targetId, position);
                        }
                    });
                });
            }

            exportData() {
                const data = {
                    restaurants: this.restaurants,
                    exportDate: new Date().toISOString(),
                    version: '2.0',
                    deviceInfo: {
                        userAgent: navigator.userAgent,
                        timestamp: Date.now()
                    }
                };
                
                const dataStr = JSON.stringify(data, null, 2);
                const dataBlob = new Blob([dataStr], {type: 'application/json'});
                
                const link = document.createElement('a');
                link.href = URL.createObjectURL(dataBlob);
                link.download = `al-eats-backup-${new Date().toISOString().split('T')[0]}.json`;
                link.click();
                
                this.showStatus(`Exported ${this.restaurants.length} restaurants`);
            }

            importData(event) {
                const file = event.target.files[0];
                if (!file) return;

                const reader = new FileReader();
                reader.onload = (e) => {
                    try {
                        const data = JSON.parse(e.target.result);
                        if (data.restaurants && Array.isArray(data.restaurants)) {
                            const importCount = data.restaurants.length;
                            if (confirm(`Import ${importCount} restaurants? This will replace all current data.`)) {
                                this.restaurants = data.restaurants;
                                // Update order values
                                this.restaurants.forEach((restaurant, index) => {
                                    restaurant.order = index;
                                });
                                this.saveData();
                                this.renderRestaurants();
                                this.showStatus(`Successfully imported ${importCount} restaurants`);
                            }
                        } else {
                            this.showStatus('Invalid file format - no restaurants found', 'error');
                        }
                    } catch (error) {
                        this.showStatus('Error reading file - please check format', 'error');
                        console.error('Import error:', error);
                    }
                };
                reader.readAsText(file);
                event.target.value = '';
            }

            getFilteredRestaurants() {
                if (this.currentFilter === 'all') {
                    return this.restaurants;
                }
                if (this.currentFilter === 'ashley') {
                    return this.restaurants.filter(r => r.suggestedBy === 'Ashley');
                }
                if (this.currentFilter === 'luke') {
                    return this.restaurants.filter(r => r.suggestedBy === 'Luke');
                }
                return this.restaurants.filter(r => r.priority === this.currentFilter);
            }

            renderRestaurants() {
                const grid = document.getElementById('restaurantsGrid');
                const filteredRestaurants = this.getFilteredRestaurants();

                if (filteredRestaurants.length === 0) {
                    let emptyMessage = 'No restaurants yet!';
                    let emptySubtext = 'Add your first restaurant above to get started.';
                    
                    if (this.currentFilter === 'ashley') {
                        emptyMessage = "No restaurants from Ashley yet!";
                        emptySubtext = "Ashley hasn't suggested any restaurants yet.";
                    } else if (this.currentFilter === 'luke') {
                        emptyMessage = "No restaurants from Luke yet!";
                        emptySubtext = "Luke hasn't suggested any restaurants yet.";
                    } else if (this.currentFilter !== 'all') {
                        emptyMessage = `No ${this.currentFilter} priority restaurants`;
                        emptySubtext = 'Try a different filter or add more restaurants.';
                    }
                    
                    grid.innerHTML = `
                        <div class="empty-state">
                            <h3>${emptyMessage}</h3>
                            <p>${emptySubtext}</p>
                        </div>
                    `;
                    return;
                }

                grid.innerHTML = filteredRestaurants.map(restaurant => `
                    <div class="restaurant-card priority-${restaurant.priority}" data-id="${restaurant.id}">
                        <div class="drag-handle">⋮⋮</div>
                        <div class="restaurant-header">
                            <div>
                                <div class="restaurant-name">${restaurant.name}</div>
                                <div class="restaurant-cuisine">${restaurant.cuisine || 'Cuisine not specified'}</div>
                            </div>
                            <div>
                                <div class="priority-badge ${restaurant.priority}">${restaurant.priority}</div>
                                <div class="suggested-by-badge ${restaurant.suggestedBy.toLowerCase()}">
                                    ${restaurant.suggestedBy === 'Ashley' ? '👩' : '👨'} ${restaurant.suggestedBy}
                                </div>
                            </div>
                        </div>
                        
                        <div class="restaurant-details">
                            ${restaurant.location ? `<div class="restaurant-location">📍 ${restaurant.location}</div>` : ''}
                            ${restaurant.url ? `<div class="restaurant-location">🔗 <a href="${restaurant.url}" target="_blank" style="color: #667eea; text-decoration: none;">Visit Website</a></div>` : ''}
                            <div style="color: #888; font-size: 0.9rem;">Added ${restaurant.dateAdded}</div>
                            ${restaurant.visited ? `<div style="color: #4ecdc4; font-weight: 600;">✅ Visited on ${restaurant.visitedDate}</div>` : ''}
                            ${restaurant.notes ? `<div class="restaurant-notes">${restaurant.notes}</div>` : ''}
                        </div>
                        
                        <div class="restaurant-actions">
                            ${!restaurant.visited ? `<button class="action-btn visit-btn" onclick="tracker.markAsVisited(${restaurant.id})">Mark as Visited</button>` : ''}
                            ${restaurant.location ? `<button class="action-btn map-btn" onclick="tracker.openMap(${restaurant.id})">View on Map</button>` : ''}
                            <button class="action-btn edit-btn" onclick="tracker.editRestaurant(${restaurant.id})">Edit</button>
                            <button class="action-btn delete-btn" onclick="tracker.deleteRestaurant(${restaurant.id})">Delete</button>
                        </div>
                    </div>
                `).join('');

                // Setup drag and drop after rendering
                setTimeout(() => this.setupDragAndDrop(), 100);
            }
        }

        // Initialize the app
        const tracker = new RestaurantTracker();
    </script>
</body>
</html>
EOF

# Create api.php (Backend API)
echo "📝 Creating api.php..."
cat > app/api.php << 'EOF'
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
EOF

# Create docker-compose.yml
echo "📝 Creating docker-compose.yml..."
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  al-eats:
    image: php:8.1-apache
    container_name: al-eats
    ports:
      - "8080:80"
    volumes:
      - ./app:/var/www/html
      - ./data:/var/www/html/data
    environment:
      - APACHE_DOCUMENT_ROOT=/var/www/html
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/api.php"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.al-eats.rule=Host(\`al-eats.local\`)"
      - "traefik.http.services.al-eats.loadbalancer.server.port=80"
EOF

# Create README.md
echo "📝 Creating README.md..."
cat > README.md << 'EOF'
# AL Eats - Restaurant Tracker 🍽️

A collaborative restaurant wishlist app that syncs data across all devices on your network.

## 🌟 Features

- **🍽️ Add & Track Restaurants** - Name, cuisine, location, website, notes
- **👥 Person Attribution** - Track whether Ashley or Luke suggested each restaurant
- **🎯 Priority System** - High, Medium, Low priority with color coding
- **📱 Real-time Sync** - Data syncs instantly across all devices (server-only storage)
- **🗺️ Map Integration** - Smart Apple/Google Maps integration
- **✅ Visit Tracking** - Mark restaurants as visited with dates
- **🎨 Drag & Drop** - Reorder restaurants by importance
- **📤 Export/Import** - Backup and restore your data
- **🌐 Multi-Device** - Works on phones, tablets, computers

## 🚀 TrueNAS SCALE Deployment

### Quick Setup

1. **Clone or download this repository**
2. **Copy to your TrueNAS SCALE system**
3. **Run the deployment**

### Method 1: Docker Compose (Recommended)

```bash
# Clone the repository
git clone https://github.com/oshata/AL-Eats.git
cd AL-Eats

# Copy to your TrueNAS storage
cp -r . /mnt/[your-pool]/al-eats/
cd /mnt/[your-pool]/al-eats/

# Set permissions
chmod -R 755 .
chown -R 33:33 data/  # www-data user for PHP

# Deploy with Docker Compose
docker-compose up -d
```

### Method 2: TrueNAS Apps UI

1. **Apps** → **Custom App**
2. **Application Name:** `al-eats`
3. **Image Repository:** `php:8.1-apache`
4. **Container Port:** `80`
5. **Node Port:** `8080`
6. **Storage Volume Mounts:**
   - Host Path: `/mnt/[pool]/al-eats/app` → Container Path: `/var/www/html`
   - Host Path: `/mnt/[pool]/al-eats/data` → Container Path: `/var/www/html/data`

## 📁 File Structure

```
AL-Eats/
├── README.md
├── docker-compose.yml
├── app/
│   ├── index.html          # Main application
│   └── api.php            # Backend API
├── data/
│   └── restaurants.json   # Data storage (auto-created)
└── scripts/
    └── setup.sh           # Setup script
```

## 🌐 Access Your App

- **Local Network:** `http://your-truenas-ip:8080`
- **Add to Home Screen** on mobile devices for app-like experience
- **Bookmark** on all devices for quick access

## 💾 Data Storage

- **Server-Only Storage** - No data stored on user devices
- **Real-time Sync** - Changes appear instantly on all devices
- **JSON Format** - Easy to backup and restore
- **Automatic API** - RESTful backend handles all data operations

## 🔧 Management

### Check Container Status
```bash
docker ps
docker logs al-eats
```

### Verify Data
```bash
# Check if data directory exists and is writable
ls -la /mnt/[pool]/al-eats/data/

# Test API directly
curl http://your-truenas-ip:8080/api.php
```

### Backup Data
```bash
# Manual backup
cp /mnt/[pool]/al-eats/data/restaurants.json ~/al-eats-backup-$(date +%Y%m%d).json

# Or use the built-in export feature in the web interface
```

### Update AL Eats
```bash
# Pull latest changes
git pull origin main

# Restart container
docker-compose restart
```

## 🛠️ Troubleshooting

### Common Issues

1. **Cannot access app**
   - Check if container is running: `docker ps`
   - Verify port 8080 is available
   - Check TrueNAS firewall settings

2. **Data not saving**
   - Verify data directory permissions: `ls -la data/`
   - Check container logs: `docker logs al-eats`
   - Ensure data directory is writable by www-data (UID 33)

3. **API errors**
   - Test API endpoint: `curl http://your-ip:8080/api.php`
   - Check PHP error logs in container
   - Verify JSON file format in data directory

### Reset Data
```bash
# Stop container
docker-compose down

# Remove data file
rm data/restaurants.json

# Restart container (will recreate empty data file)
docker-compose up -d
```

## 🔒 Security Notes

- **Local Network Only** - App is accessible only on your local network
- **No External Dependencies** - All data stays on your TrueNAS
- **File-based Storage** - Simple JSON file storage, easy to backup
- **No User Authentication** - Designed for trusted home network use

## 📱 Mobile Usage

- **Add to Home Screen** for app-like experience
- **Responsive Design** works on all screen sizes
- **Touch-friendly** interface for mobile devices
- **Maps Integration** opens native map apps on mobile

## 🆘 Support

For issues:
1. Check the troubleshooting section above
2. Review container logs: `docker logs al-eats`
3. Verify file permissions and network connectivity
4. Test API endpoint directly with curl

## 📄 License

MIT License - Feel free to modify and distribute!

---

Enjoy discovering new restaurants together! 🍕🍜🍰
EOF

# Create .gitignore
echo "📝 Creating .gitignore..."
cat > .gitignore << 'EOF'
# Data files
data/restaurants.json
data/*.json

# Logs
*.log
logs/

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp
*.swo

# Docker
.env

# Backup files
*.backup
*.bak
EOF

# Create setup script for TrueNAS
echo "📝 Creating TrueNAS setup script..."
mkdir -p scripts
cat > scripts/truenas-setup.sh << 'EOF'
#!/bin/bash

# AL Eats TrueNAS SCALE Setup Script
# Run this script on your TrueNAS SCALE system

set -e

echo "🍽️  AL Eats TrueNAS SCALE Setup"
echo "==============================="

# Get pool name from user
read -p "Enter your TrueNAS pool name (e.g., tank): " POOL_NAME

if [ -z "$POOL_NAME" ]; then
    echo "❌ Pool name is required"
    exit 1
fi

APP_DIR="/mnt/${POOL_NAME}/al-eats"

echo "📁 Creating application directory: $APP_DIR"
mkdir -p "$APP_DIR"
cd "$APP_DIR"

echo "📥 Downloading AL Eats from GitHub..."
if command -v git &> /dev/null; then
    git clone https://github.com/oshata/AL-Eats.git .
else
    echo "Git not found. Please download manually from GitHub."
    exit 1
fi

echo "🔧 Setting up permissions..."
chmod -R 755 .
mkdir -p data
chown -R 33:33 data/  # www-data user

echo "🐳 Starting AL Eats with Docker Compose..."
if command -v docker-compose &> /dev/null; then
    docker-compose up -d
else
    echo "Docker Compose not found. Please install Docker Compose or use TrueNAS Apps UI."
    exit 1
fi

echo ""
echo "✅ AL Eats setup complete!"
echo ""
echo "🌐 Access your app at: http://$(hostname -I | awk '{print $1}'):8080"
echo "📱 Add this URL to your devices' bookmarks"
echo ""
echo "🔧 To manage the container:"
echo "   docker ps                    # Check status"
echo "   docker logs al-eats         # View logs"
echo "   docker-compose restart      # Restart app"
echo "   docker-compose down         # Stop app"
echo ""
echo "🍽️ Happy restaurant hunting!"
EOF

chmod +x scripts/truenas-setup.sh

# Create empty data directory with placeholder
echo "📁 Creating data directory..."
touch data/.gitkeep

# Create basic health check script
echo "📝 Creating health check script..."
cat > scripts/health-check.sh << 'EOF'
#!/bin/bash

# AL Eats Health Check Script

APP_URL="http://localhost:8080"
API_URL="$APP_URL/api.php"

echo "🏥 AL Eats Health Check"
echo "======================"

# Check if container is running
if docker ps | grep -q "al-eats"; then
    echo "✅ Container is running"
else
    echo "❌ Container is not running"
    exit 1
fi

# Check if web app is responding
if curl -s -f "$APP_URL" > /dev/null; then
    echo "✅ Web application is responding"
else
    echo "❌ Web application is not responding"
    exit 1
fi

# Check if API is responding
if curl -s -f "$API_URL" > /dev/null; then
    echo "✅ API is responding"
else
    echo "❌ API is not responding"
    exit 1
fi

# Check data directory permissions
if [ -w "data/" ]; then
    echo "✅ Data directory is writable"
else
    echo "❌ Data directory is not writable"
    exit 1
fi

echo ""
echo "🎉 All checks passed! AL Eats is healthy."
EOF

chmod +x scripts/health-check.sh

# Create version file
echo "📝 Creating version file..."
cat > VERSION << 'EOF'
AL Eats v2.0.0
Build Date: $(date)
Features:
- Server-side data sync
- Ashley/Luke person selection
- Priority system with colors
- Drag & drop reordering
- Map integration
- Export/Import functionality
- Mobile responsive design
- Real-time sync status
EOF

echo ""
echo "🎉 AL Eats repository setup complete!"
echo ""
echo "📁 Files created:"
echo "   ├── README.md              # Documentation"
echo "   ├── docker-compose.yml     # Docker configuration"
echo "   ├── .gitignore            # Git ignore rules"
echo "   ├── VERSION               # Version information"
echo "   ├── app/"
echo "   │   ├── index.html        # Main application"
echo "   │   └── api.php           # Backend API"
echo "   ├── data/"
echo "   │   └── .gitkeep          # Keep directory in git"
echo "   └── scripts/"
echo "       ├── truenas-setup.sh  # TrueNAS deployment script"
echo "       └── health-check.sh   # Health monitoring script"
echo ""
echo "🚀 Next steps:"
echo "   1. Push to GitHub: git add . && git commit -m 'Initial AL Eats setup' && git push"
echo "   2. On TrueNAS: Run scripts/truenas-setup.sh"
echo "   3. Access at: http://your-truenas-ip:8080"
echo ""
echo "🍽️ Happy restaurant tracking!"
EOF

echo "✅ Setup script created successfully!"
echo ""
echo "🚀 To run this script:"
echo "   chmod +x setup-aleats.sh"
echo "   ./setup-aleats.sh"
echo ""
echo "📤 This will create all files needed for your GitHub repository!"
                });

                // Filter buttons
                document.querySelectorAll('.filter-btn').forEach(btn => {
                    btn.addEventListener('click', () => {
                        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                        btn.classList.add('active');
                        this.currentFilter = btn.dataset.filter;
                        this.renderRestaurants();
                    });
                });
            }

            showStatus(message, type = 'success') {
                const statusDiv = document.getElementById('statusMessage');
                statusDiv.className = `status-message status-${type}`;
                statusDiv.textContent = message;
                setTimeout(() => {
                    statusDiv.className = '';
                    statusDiv.textContent = '';
                }, 3000);
            }

            updateSyncStatus(status, message) {
                const statusEl = document.getElementById('syncStatus');
                statusEl.className = `sync-status ${status}`;
                
                const icons = {
                    online: '🟢',
                    offline: '🔴',
                    syncing: '🟡'
                };
                
                statusEl.innerHTML = `${icons[status]} <span>${message}</span>`;
            }

            startSyncCheck() {
                // Check server connection every 30 seconds
                setInterval(() => {
                    this.checkServerConnection();
                }, 30000);
            }

            async checkServerConnection() {
                try {
                    const response = await fetch(this.apiUrl, {
                        method: 'GET',
                        headers: { 'Cache-Control': 'no-cache' }
                    });
                    
                    if (response.ok) {
                        if (!this.isOnline) {
                            this.isOnline = true;
                            this.updateSyncStatus('online', 'Connected - Data syncs across all devices');
                            this.loadData(); // Refresh data when coming back online
                        }
                    } else {
                        throw new Error('Server not responding');
                    }
                } catch (error) {
                    if (this.isOnline) {
                        this.isOnline = false;
                        this.updateSyncStatus('offline', 'Server offline - Cannot access data');
                    }
                }
            }

            async loadData() {
                this.updateSyncStatus('syncing', 'Loading data...');
                
                try {
                    const response = await fetch(this.apiUrl, {
                        method: 'GET',
                        headers: { 'Cache-Control': 'no-cache' }
                    });
                    
                    if (response.ok) {
                        const data = await response.json();
                        this.restaurants = data.restaurants || [];
                        this.isOnline = true;
                        this.updateSyncStatus('online', `Loaded ${this.restaurants.length} restaurants from server`);
                    } else {
                        throw new Error('Server error');
                    }
                } catch (error) {
                    this.isOnline = false;
                    this.restaurants = [];
                    this.updateSyncStatus('offline', 'Cannot connect to server - No data available');
                    this.showStatus('Server connection required to access data', 'error');
                }
                
                this.renderRestaurants();
            }

            async saveData() {
                if (!this.isOnline) {
                    this.showStatus('Cannot save - Server connection required', 'error');
                    return false;
                }

                this.updateSyncStatus('syncing', 'Saving to server...');
                
                try {
                    const response = await fetch(this.apiUrl, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            restaurants: this.restaurants,
                            lastUpdated: new Date().toISOString()
                        })
                    });

                    if (response.ok) {
                        const result = await response.json();
                        this.updateSyncStatus('online', `${result.count} restaurants saved on server`);
                        this.showStatus('Data saved to server - Available on all devices');
                        return true;
                    } else {
                        throw new Error('Server save failed');
                    }
                } catch (error) {
                    this.isOnline = false;
                    this.updateSyncStatus('offline', 'Save failed - Server connection lost');
                    this.showStatus('Cannot save - Server connection required', 'error');
                    return false;
                }
            }

            addRestaurant() {
                const restaurant = {
                    id: Date.now(),
                    name: document.getElementById('name').value,
                    cuisine: document.getElementById('cuisine').value,
                    location: document.getElementById('location').value,
                    url: document.getElementById('url').value,
                    suggestedBy: document.getElementById('suggestedBy').value,
                    priority: document.getElementById('priority').value,
                    notes: document.getElementById('notes').value,
                    dateAdded: new Date().toLocaleDateString(),
                    visited: false,
                    order: this.restaurants.length
                };

                this.restaurants.push(restaurant);
                this.saveData();
                this.renderRestaurants();
                this.resetForm();
                this.showStatus('Restaurant added and synced to all devices');
            }

            editRestaurant(id) {
                const restaurant = this.restaurants.find(r => r.id === id);
                if (!restaurant) return;

                this.editingId = id;
                
                // Populate form
                document.getElementById('name').value = restaurant.name;
                document.getElementById('cuisine').value = restaurant.cuisine;
                document.getElementById('location').value = restaurant.location;
                document.getElementById('url').value = restaurant.url;
                document.getElementById('suggestedBy').value = restaurant.suggestedBy;
                document.getElementById('notes').value = restaurant.notes;
                
                // Set priority
                document.querySelectorAll('.priority-option').forEach(o => o.classList.remove('selected'));
                document.querySelector(`[data-priority="${restaurant.priority}"]`).classList.add('selected');
                document.getElementById('priority').value = restaurant.priority;
                
                // Update UI
                document.getElementById('submitBtn').textContent = 'Update Restaurant';
                document.getElementById('cancelBtn').classList.remove('hidden');
                
                // Scroll to form
                document.querySelector('.form-section').scrollIntoView({ behavior: 'smooth' });
            }

            updateRestaurant() {
                const restaurant = this.restaurants.find(r => r.id === this.editingId);
                if (!restaurant) return;

                restaurant.name = document.getElementById('name').value;
                restaurant.cuisine = document.getElementById('cuisine').value;
                restaurant.location = document.getElementById('location').value;
                restaurant.url = document.getElementById('url').value;
                restaurant.suggestedBy = document.getElementById('suggestedBy').value;
                restaurant.priority = document.getElementById('priority').value;
                restaurant.notes = document.getElementById('notes').value;
                restaurant.lastModified = new Date().toLocaleDateString();

                this.saveData();
                this.renderRestaurants();
                this.cancelEdit();
                this.showStatus('Restaurant updated and synced to all devices');
            }

            cancelEdit() {
                this.editingId = null;
                this.resetForm();
                document.getElementById('submitBtn').textContent = 'Add Restaurant';
                document.getElementById('cancelBtn').classList.add('hidden');
            }

            resetForm() {
                document.getElementById('restaurantForm').reset();
                document.querySelectorAll('.priority-option').forEach(o => o.classList.remove('selected'));
                document.querySelector('.priority-option[data-priority="medium"]').classList.add('selected');
                document.getElementById('priority').value = 'medium';
            }

            markAsVisited(id) {
                const restaurant = this.restaurants.find(r => r.id === id);
                if (restaurant) {
                    restaurant.visited = true;
                    restaurant.visitedDate = new Date().toLocaleDateString();
                    this.saveData();
                    this.renderRestaurants();
                    this.showStatus('Restaurant marked as visited');
                }
            }

            deleteRestaurant(id) {
                if (confirm('Are you sure you want to delete this restaurant?')) {
                    this.restaurants = this.restaurants.filter(r => r.id !== id);
                    this.saveData();
                    this.renderRestaurants();
                    this.showStatus('Restaurant deleted');
                }
            }

            openMap(id) {
                const restaurant = this.restaurants.find(r => r.id === id);
                if (!restaurant || !restaurant.location) {
                    alert('No location available for this restaurant');
                    return;
                }

                const query = encodeURIComponent(`${restaurant.name} ${restaurant.location}`);
                const isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent);
                const isMac = navigator.platform.toUpperCase().indexOf('MAC') >= 0;
                
                let mapUrl;
                
                if (isIOS) {
                    mapUrl = `maps://maps.apple.com/?q=${query}`;
                    setTimeout(() => {
                        window.open(`https://maps.google.com/maps?q=${query}`, '_blank');
                    }, 500);
                } else if (isMac) {
                    mapUrl = `maps://maps.apple.com/?q=${query}`;
                    setTimeout(() => {
                        window.open(`https://maps.google.com/maps?q=${query}`, '_blank');
                    }, 500);
                } else {
                    mapUrl = `https://maps.google.com/maps?q=${query}`;
                }

                try {
                    if (isIOS || isMac) {
                        window.location.href = mapUrl;
                    } else {
                        window.open(mapUrl, '_blank');
                    }
                } catch (e) {
                    window.open(`https://maps.google.com/maps?q=${query}`, '_blank');
                }
            }

            moveRestaurant(draggedId, targetId, position) {
                const draggedIndex = this.restaurants.findIndex(r => r.id === draggedId);
                const targetIndex = this.restaurants.findIndex(r => r.id === targetId);
                
                if (draggedIndex === -1 || targetIndex === -1) return;
                
                const draggedRestaurant = this.restaurants.splice(draggedIndex, 1)[0];
                const insertIndex = position === 'before' ? targetIndex : targetIndex + 1;
                
                this.restaurants.splice(insertIndex, 0, draggedRestaurant);
                
                // Update order values
                this.restaurants.forEach((restaurant, index) => {
                    restaurant.order = index;
                });
                
                this.saveData();
                this.renderRestaurants();
                this.showStatus('Restaurant order updated');
            }

            setupDragAndDrop() {
                const cards = document.querySelectorAll('.restaurant-card');
                
                cards.forEach(card => {
                    card.draggable = true;
                    
                    card.addEventListener('dragstart', (e) => {
                        this.draggedElement = card;
                        card.classList.add('dragging');
                        e.dataTransfer.effectAllowed = 'move';
                        e.dataTransfer.setData('text/html', card.outerHTML);
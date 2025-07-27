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

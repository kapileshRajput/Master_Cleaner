#!/bin/bash

# Function to clean system cache
clean_system_cache() {
  echo -e "\n[INFO] Cleaning system cache..."
  sudo rm -rf /var/cache/*
  echo "[INFO] System cache cleanup completed."
}

# Function to clean user cache
clean_user_cache() {
  echo -e "\n[INFO] Cleaning user cache..."
  local cache_path="$HOME/.cache"

  if [ -d "$cache_path" ]; then
    delete_with_progress "$cache_path"
    echo "[INFO] User cache cleanup completed."
  else
    echo "[INFO] User cache directory not found."
  fi
}

# Function to clean temporary files
clean_temp_files() {
  echo -e "\n[INFO] Cleaning temporary files..."
  sudo rm -rf /tmp/*
  echo "[INFO] Temporary files cleanup completed."
}

# Function to clean log files
clean_logs() {
  echo -e "\n[INFO] Cleaning log files..."
  sudo find /var/log -type f -exec rm -f {} \;
  echo "[INFO] Log files cleanup completed."
}

# Function to delete a directory with progress indication
delete_with_progress() {
  local target_dir=$1

  if [ -d "$target_dir" ]; then
    local total_size=$(du -sh "$target_dir" 2>/dev/null | awk '{print $1}')
    echo "[INFO] Deleting $target_dir (Size: $total_size)"

    # Deleting files with progress
    find "$target_dir" -type f | while read -r file; do
      echo "[INFO] Deleting file: $file"
      rm -f "$file"
    done

    # Remove remaining empty directories
    find "$target_dir" -type d -empty -delete
    echo "[INFO] Deleted: $target_dir"
  fi
}

# Main script starts here
clear

cat << "EOF"
============================================
         Linux Cleanup Script
============================================
EOF

echo -e "\nSelect an option:"
echo "1. Clean system cache"
echo "2. Clean user cache"
echo "3. Clean temporary files"
echo "4. Clean log files"
echo "5. Clean everything"
read -p "Enter your choice (1, 2, 3, 4, or 5): " choice

case $choice in
  1)
    clean_system_cache
    ;;
  2)
    clean_user_cache
    ;;
  3)
    clean_temp_files
    ;;
  4)
    clean_logs
    ;;
  5)
    clean_system_cache
    clean_user_cache
    clean_temp_files
    clean_logs
    ;;
  *)
    echo "[ERROR] Invalid choice. Please select 1, 2, 3, 4, or 5."
    ;;
esac

cat << "EOF"
============================================
        Cleanup process completed
============================================
EOF


#!/bin/bash

# Function to clean macOS caches
clean_macos_caches() {
  echo -e "\n[INFO] Cleaning macOS caches..."
  local cache_paths=(
    "$HOME/Library/Caches"
    "$HOME/Library/Application Support/Caches"
  )

  for path in "${cache_paths[@]}"; do
    if [ -d "$path" ]; then
      echo "[INFO] Deleting: $path"
      delete_with_progress "$path"
    else
      echo "[INFO] Cache directory not found: $path"
    fi
  done

  echo "[INFO] macOS caches cleanup completed."
}

# Function to clean macOS logs
clean_macos_logs() {
  echo -e "\n[INFO] Cleaning macOS logs..."
  local log_paths=(
    "$HOME/Library/Logs"
    "/var/log"
  )

  for path in "${log_paths[@]}"; do
    if [ -d "$path" ]; then
      echo "[INFO] Deleting: $path"
      delete_with_progress "$path"
    else
      echo "[INFO] Log directory not found: $path"
    fi
  done

  echo "[INFO] macOS logs cleanup completed."
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
        macOS Cleanup Script
============================================
EOF

echo -e "\nSelect an option:"
echo "1. Clean macOS caches"
echo "2. Clean macOS logs"
echo "3. Clean both caches and logs"
read -p "Enter your choice (1, 2, or 3): " choice

case $choice in
  1)
    clean_macos_caches
    ;;
  2)
    clean_macos_logs
    ;;
  3)
    clean_macos_caches
    clean_macos_logs
    ;;
  *)
    echo "[ERROR] Invalid choice. Please select 1, 2, or 3."
    ;;
esac

cat << "EOF"
============================================
        Cleanup process completed
============================================
EOF


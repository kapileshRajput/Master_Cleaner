#!/bin/bash

# Function to clean DerivedData
clean_derived_data() {
  echo -e "\n[INFO] Cleaning DerivedData..."
  local derived_data_dir="$HOME/Library/Developer/Xcode/DerivedData"

  if [ -d "$derived_data_dir" ]; then
    echo "[INFO] Deleting: $derived_data_dir"
    delete_with_progress "$derived_data_dir"
    echo "[INFO] DerivedData cleanup completed."
  else
    echo "[INFO] DerivedData is already clean."
  fi
}

# Function to clean iOS project-specific caches
clean_ios_project() {
  local project_path=$1

  echo -e "\n[INFO] Cleaning iOS project: $project_path"

  if [ -f "$project_path/Podfile" ]; then
    echo "[INFO] Found Podfile. Cleaning CocoaPods-related files..."
    (cd "$project_path" && pod deintegrate && pod cache clean --all)
  fi

  local project_dirs=(
    "$project_path/build"
    "$project_path/DerivedData"
    "$project_path/.xcworkspace"
    "$project_path/Pods"
  )

  for dir in "${project_dirs[@]}"; do
    if [ -d "$dir" ]; then
      echo "[INFO] Deleting: $dir"
      delete_with_progress "$dir"
    fi
  done

  echo "[INFO] Cleanup completed for iOS project: $project_path"
}

# Function to clean multiple iOS projects
clean_multiple_ios_projects() {
  local base_dir=$1

  echo -e "\n[INFO] Scanning for iOS projects in: $base_dir"
  local projects=$(find "$base_dir" -name "*.xcodeproj" -exec dirname {} \; | sort | uniq)

  if [ -z "$projects" ]; then
    echo "[INFO] No iOS projects found in: $base_dir"
    return
  fi

  for project in $projects; do
    echo -e "\n[INFO] Cleaning iOS project: $project"
    clean_ios_project "$project"
  done
}

# Function to clean Xcode-related caches
clean_xcode_related_data() {
  echo -e "\n[INFO] Cleaning Xcode-related data..."
  local xcode_related_paths=(
    "$HOME/Library/Caches/com.apple.dt.Xcode"
    "$HOME/Library/Developer/Xcode/Archives"
    "$HOME/Library/Developer/Xcode/iOS DeviceSupport"
    "$HOME/Library/Developer/Xcode/Products"
    "$HOME/Library/Developer/Xcode/DocumentationCache"
    "$HOME/Library/Developer/Xcode/UserData"
  )

  local found_any=false

  for path in "${xcode_related_paths[@]}"; do
    if [ -d "$path" ]; then
      echo "[INFO] Deleting: $path"
      delete_with_progress "$path"
      found_any=true
    fi
  done

  if [ "$found_any" = false ]; then
    echo "[INFO] Xcode-related data is already clean."
  else
    echo "[INFO] Xcode-related data cleanup complete."
  fi
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
      Safe iOS Project Cleanup Script
============================================
EOF

# Ask user whether to clean a single project, multiple projects, or Xcode-related data
echo -e "\nSelect an option:"
echo "1. Clean Xcode-related data"
echo "2. Clean a single iOS project"
echo "3. Clean multiple iOS projects"
read -p "Enter your choice (1, 2, or 3): " choice

case $choice in
  1)
    echo -e "\n[INFO] Starting cleanup process for Xcode-related data..."
    clean_derived_data
    clean_xcode_related_data
    ;;

  2)
    read -p "Enter the path to the iOS project (leave blank for current directory): " project_path
    project_path=${project_path:-$(pwd)}

    if [ -d "$project_path" ]; then
      echo -e "\n[INFO] Starting cleanup process for a single iOS project..."
      clean_ios_project "$project_path"
    else
      echo "[ERROR] Invalid project path: $project_path"
    fi
    ;;

  3)
    read -p "Enter the base directory to scan for iOS projects (leave blank for current directory): " base_dir
    base_dir=${base_dir:-$(pwd)}

    if [ -d "$base_dir" ]; then
      echo -e "\n[INFO] Starting cleanup process for multiple iOS projects..."
      clean_multiple_ios_projects "$base_dir"
    else
      echo "[ERROR] Invalid base directory: $base_dir"
    fi
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


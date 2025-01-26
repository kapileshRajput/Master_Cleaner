#!/bin/bash

# Function to clean Android Studio-related directories
clean_android_studio_data() {
  echo -e "\n[INFO] Cleaning Android Studio-related data..."
  local android_studio_paths=(
    "$HOME/.android"
    "$HOME/.gradle"
    "$HOME/.cache"
    "$HOME/.idea"
    "$HOME/Android/Sdk/.temp"
    "$HOME/Library/Application Support/Google/AndroidStudio*"
    "$HOME/Library/Caches/Google/AndroidStudio*"
    "$HOME/Library/Preferences/Google/AndroidStudio*"
    "$HOME/Library/Logs/Google/AndroidStudio*"
  )

  local found_any=false

  for path in "${android_studio_paths[@]}"; do
    if [ -d "$path" ]; then
      echo "[INFO] Deleting: $path"
      delete_with_progress "$path"
      found_any=true
    fi
  done

  if [ "$found_any" = false ]; then
    echo "[INFO] Android Studio data is already clean."
  else
    echo "[INFO] Android Studio cleanup complete."
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

# Function to clean a single Android project
clean_android_project() {
  local project_path=$1

  echo -e "\n[INFO] Cleaning project: $project_path"

  local project_dirs=(
    "$project_path/.gradle"
    "$project_path/build"
    "$project_path/.idea"
    "$project_path/local.properties"
    "$project_path/.cxx"
    "$project_path/app/build"
  )

  local found_any=false

  for dir in "${project_dirs[@]}"; do
    if [ -d "$dir" ]; then
      echo "[INFO] Deleting: $dir"
      delete_with_progress "$dir"
      found_any=true
    fi
  done

  if [ "$found_any" = false ]; then
    echo "[INFO] Project is already clean: $project_path"
  else
    echo "[INFO] Cleanup complete for project: $project_path"
  fi
}

# Function to find and clean multiple Android projects
clean_multiple_projects() {
  local base_dir=$1

  echo -e "\n[INFO] Scanning for Android projects in: $base_dir"
  local projects=$(find "$base_dir" -name "build.gradle" -exec dirname {} \; | sort | uniq)

  if [ -z "$projects" ]; then
    echo "[INFO] No Android projects found in: $base_dir"
    return
  fi

  for project in $projects; do
    echo -e "\n[INFO] Cleaning project: $project"
    clean_android_project "$project"
  done
}

# Main script starts here
clear

cat << "EOF"
============================================
   Android Studio & Project Cleanup Script
============================================
EOF

# Ask user whether to clean a single project or multiple projects
echo -e "\nSelect an option:"
echo "1. Clean Android Studio-related data"
echo "2. Clean a single project"
echo "3. Clean multiple projects"
read -p "Enter your choice (1, 2, or 3): " choice

case $choice in
  1)
    echo -e "\n[INFO] Starting cleanup process for Android Studio-related data..."
    clean_android_studio_data
    ;;

  2)
    read -p "Enter the path to the project (leave blank for current directory): " project_path
    project_path=${project_path:-$(pwd)}

    if [ -d "$project_path" ]; then
      echo -e "\n[INFO] Starting cleanup process..."
      clean_android_studio_data
      clean_android_project "$project_path"
    else
      echo "[ERROR] Invalid project path: $project_path"
    fi
    ;;

  3)
    read -p "Enter the base directory to scan (leave blank for current directory): " base_dir
    base_dir=${base_dir:-$(pwd)}

    if [ -d "$base_dir" ]; then
      echo -e "\n[INFO] Starting cleanup process..."
      clean_android_studio_data
      clean_multiple_projects "$base_dir"
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


#!/bin/bash

# Function to clean Flutter cache
clean_flutter_cache() {
  echo -e "\n[INFO] Cleaning Flutter cache..."
  if command -v flutter &> /dev/null; then
    flutter clean cache
    echo "[INFO] Flutter cache cleanup completed."
  else
    echo "[ERROR] Flutter is not installed or not found in PATH. Skipping cache cleanup."
  fi
}

# Function to clean a single Flutter project
clean_flutter_project() {
  local project_path=$1

  echo -e "\n[INFO] Cleaning Flutter project: $project_path"

  if [ -f "$project_path/pubspec.yaml" ]; then
    echo "[INFO] Running 'flutter clean' in $project_path..."
    (cd "$project_path" && flutter clean)

    # Remove additional directories manually if needed
    local project_dirs=(
      "$project_path/.dart_tool"
      "$project_path/.packages"
      "$project_path/build"
      "$project_path/.flutter-plugins-dependencies"
    )

    for dir in "${project_dirs[@]}"; do
      if [ -d "$dir" ]; then
        echo "[INFO] Deleting: $dir"
        delete_with_progress "$dir"
      fi
    done

    echo "[INFO] Cleanup completed for Flutter project: $project_path"
  else
    echo "[ERROR] Not a valid Flutter project: $project_path (pubspec.yaml not found)."
  fi
}

# Function to find and clean multiple Flutter projects
clean_multiple_flutter_projects() {
  local base_dir=$1

  echo -e "\n[INFO] Scanning for Flutter projects in: $base_dir"
  local projects=$(find "$base_dir" -name "pubspec.yaml" -exec dirname {} \; | sort | uniq)

  if [ -z "$projects" ]; then
    echo "[INFO] No Flutter projects found in: $base_dir"
    return
  fi

  for project in $projects; do
    echo -e "\n[INFO] Cleaning Flutter project: $project"
    clean_flutter_project "$project"
  done
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

# Function to clean Flutter-related directories
clean_flutter_related_data() {
  echo -e "\n[INFO] Cleaning Flutter-related data..."
  local flutter_related_paths=(
    "$HOME/.dartServer"
    "$HOME/.dart_tool"
    "$HOME/.pub-cache"
    "$HOME/.flutter"
    "$HOME/.config/flutter"
  )

  local found_any=false

  for path in "${flutter_related_paths[@]}"; do
    if [ -d "$path" ]; then
      echo "[INFO] Deleting: $path"
      delete_with_progress "$path"
      found_any=true
    fi
  done

  if [ "$found_any" = false ]; then
    echo "[INFO] Flutter-related data is already clean."
  else
    echo "[INFO] Flutter-related data cleanup complete."
  fi
}

# Main script starts here
clear

cat << "EOF"
============================================
      Flutter Project Cleanup Script
============================================
EOF

# Ask user whether to clean a single project, multiple projects, or Flutter-related data
echo -e "\nSelect an option:"
echo "1. Clean Flutter-related data"
echo "2. Clean a single Flutter project"
echo "3. Clean multiple Flutter projects"
read -p "Enter your choice (1, 2, or 3): " choice

case $choice in
  1)
    echo -e "\n[INFO] Starting cleanup process for Flutter-related data..."
    clean_flutter_cache
    clean_flutter_related_data
    ;;

  2)
    read -p "Enter the path to the Flutter project (leave blank for current directory): " project_path
    project_path=${project_path:-$(pwd)}

    if [ -d "$project_path" ]; then
      echo -e "\n[INFO] Starting cleanup process for a single Flutter project..."
      clean_flutter_project "$project_path"
    else
      echo "[ERROR] Invalid project path: $project_path"
    fi
    ;;

  3)
    read -p "Enter the base directory to scan for Flutter projects (leave blank for current directory): " base_dir
    base_dir=${base_dir:-$(pwd)}

    if [ -d "$base_dir" ]; then
      echo -e "\n[INFO] Starting cleanup process for multiple Flutter projects..."
      clean_multiple_flutter_projects "$base_dir"
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


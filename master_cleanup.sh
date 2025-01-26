#!/bin/bash

# ==========================
# Master Cleanup Script
# ==========================

# Helper function to display headers
display_header() {
  echo "============================================"
  echo "           Master Cleanup Script"
  echo "============================================"
}

# Helper function to check if a script exists
check_and_run_script() {
  script_name=$1
  if [[ -f "$script_name" ]]; then
    echo "[INFO] Running $script_name..."
    bash "$script_name"
    echo "[INFO] $script_name completed."
  else
    echo "[ERROR] $script_name not found in the current directory."
  fi
}

# --------------------------
# Main Functionality
# --------------------------

display_header

echo -e "\nSelect your platform for cleanup:"
echo "1. macOS"
echo "2. Linux"
echo "3. iOS"
echo "4. Android"
echo "5. Flutter"
echo "6. Exit"

read -p "Enter your choice (1-6): " platform_choice

case $platform_choice in
  1)
    check_and_run_script "clean_mac_os.sh"
    ;;
  2)
    check_and_run_script "clean_linux_os.sh"
    ;;
  3)
    check_and_run_script "clean_ios_project.sh"
    ;;
  4)
    check_and_run_script "clean_andorid_project.sh"
    ;;
  5)
    check_and_run_script "clean_flutter_project.sh"
    ;;
  6)
    echo "[INFO] Exiting script. Goodbye!"
    exit 0
    ;;
  *)
    echo "[ERROR] Invalid choice. Please select a valid option (1-6)."
    ;;
esac

cat << "EOF"

============================================
      Cleanup Process Completed!
============================================

EOF


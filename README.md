# Master Cleanup Scripts

## Overview
This repository contains a collection of shell scripts designed to streamline the cleanup process for various development environments and operating systems. These scripts help free up disk space, reduce clutter, and improve performance by safely removing unnecessary files and directories. Each script is tailored for a specific platform or framework, and a **Master Cleanup Script** is provided to unify all cleanup tasks into a single command.

---

## Master Script: `master_cleanup.sh`

The **Master Cleanup Script** serves as the central entry point for all cleanup operations. It allows you to:
1. Clean Android Studio projects and related directories.
2. Clean Flutter projects using both directory removal and Flutter commands.
3. Clean iOS projects, including Xcode-related directories.
4. Clean macOS by removing caches and temporary files.
5. Clean Linux by clearing system logs, caches, and temporary files.

### Features
- **Interactive Menu**: Select the environment or platform to clean.
- **Logging**: Provides detailed logs for every step of the cleanup process.
- **Individual Script Integration**: Runs platform-specific cleanup scripts located in the same directory.
- **Safe Deletion**: Removes only unnecessary files or directories to prevent data loss.

### How to Use
1. Clone this repository:
   ```bash
   git clone https://github.com/kapileshRajput/Master_Cleaner.git
   cd Master_Cleaner

-   Make the scripts executable:
    
    ```bash
    chmod +x *.sh
    ```
-   Run the master script:
    
	 ```bash
	 ./master_cleanup.sh
	```
## Individual Scripts

### 1. **Android Project Cleanup Script** (`clean_android_project.sh`)

#### Description

This script cleans Android Studio-related files and directories across single or multiple projects. It also removes unnecessary Android build artifacts.

#### Use Case

Free up space by removing build files, caches, and other temporary data created during development.

#### Data Deleted

-   **Directories**:
    -   `/build`: Contains build artifacts. Safe to delete as they can be recreated.
    -   `/app/build`: App-specific build data.
    -   `.gradle`: Caches Gradle dependencies and build information.
    -   `.idea`: Stores Android Studio project settings.

#### Usage

Run the script:

```bash
./clean_android_project.sh 
```
----------

### 2. **Flutter Project Cleanup Script** (`clean_flutter_project.sh`)

#### Description

This script cleans Flutter projects using both directory removal and built-in Flutter commands like `flutter clean`.

#### Use Case

Optimize storage usage and reset project state for Flutter development.

#### Data Deleted

-   **Directories**:
    -   `/build`: Build artifacts for Flutter projects.
    -   `.dart_tool`: Dart package management files.
    -   `.flutter-plugins`: Plugin cache files.
    -   `.idea`: IntelliJ or Android Studio project settings.

#### Commands Used

-   `flutter clean`: Resets the build artifacts.
-   `flutter pub cache clean`: Clears the pub cache.

#### Usage

Run the script:

```bash
./clean_flutter_project.sh 
```
----------

### 3. **iOS Project Cleanup Script** (`clean_ios_project.sh`)

#### Description

This script cleans iOS projects, including Xcode-related directories and derived data.

#### Use Case

Reclaim disk space and resolve issues caused by stale derived data.

#### Data Deleted

-   **Directories**:
    -   `/build`: Build artifacts for the app.
    -   `/DerivedData`: Temporary files generated during development.
    -   `/xcuserdata`: User-specific workspace settings.
    -   `/Pods`: CocoaPods dependencies (reinstallable).

#### Usage

Run the script:

```bash
./clean_ios_project.sh
```
----------

### 4. **macOS System Cleanup Script** (`clean_mac_os.sh`)

#### Description

This script removes unnecessary macOS system files, caches, and temporary data.

#### Use Case

Speed up your macOS system by clearing redundant files.

#### Data Deleted

-   **Directories**:
    -   `/Library/Caches`: System-wide caches.
    -   `/Library/Logs`: System logs.
    -   `~/Library/Caches`: User-specific caches.
    -   `~/Library/Logs`: User-specific logs.

#### Usage

Run the script:

```bash
./clean_mac_os.sh
```
----------

### 5. **Linux System Cleanup Script** (`clean_linux_os.sh`)

#### Description

This script cleans unnecessary Linux system files, such as logs, caches, and temporary files.

#### Use Case

Optimize your Linux system for better performance and storage management.

#### Data Deleted

-   **Directories**:
    -   `/var/log`: System logs.
    -   `/tmp`: Temporary files.
    -   `~/.cache`: User-specific caches.
    -   `/var/cache`: System-wide cache.

#### Usage

Run the script:

```bash
./clean_linux_os.sh 
```
----------

## Why These Directories Are Safe to Delete

-   **Build Directories** (`/build`, `/DerivedData`, etc.): These contain temporary build artifacts that can be recreated during the next build.
-   **Caches and Logs**: These files are non-essential for system or project operation and are automatically regenerated when needed.
-   **Temporary Files**: `/tmp` and similar directories store ephemeral data that is no longer required.

----------

## Contributions

Contributions are welcome! Feel free to submit issues or pull requests to improve the functionality of these scripts.

----------

## Disclaimer

Use these scripts at your own risk. While they are designed to delete only unnecessary files, always review the code and ensure you have backups before running them.


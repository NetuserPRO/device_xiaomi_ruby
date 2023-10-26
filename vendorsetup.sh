#!/bin/bash

# Export ccache settings
export USE_CCACHE=1
export CCACHE_EXEC="/usr/bin/ccache"
export CCACHE_SIZE="100G"

# Set the device name.
device_name="ruby"

# Function to remove a directory if it exists and echo a message.
remove_directory() {
    local directory="$1"
    if [ -d "$directory" ]; then
        echo "Removing the previous $directory directory..."
        rm -rf "$directory"
        echo "$directory directory has been successfully removed."
    fi
}

# Function to clone a Git repository with error handling.
clone_repository() {
    local url="$1"
    local branch="$2"
    local directory="$3"

    if [ ! -d "$directory" ]; then
        echo "Cloning $url..."
        if git clone --depth 1 "$url" -b "$branch" "$directory" &> /dev/null; then
            echo "$url has been successfully cloned for $device_name."
        else
            echo "Oops! Cloning $url for $device_name failed."
        fi
    else
        echo "Skipping cloning, as $directory already exists."
    fi
}

# Remove the existing directories.
remove_directory "./kernel/xiaomi/mt6877"
remove_directory "./vendor/xiaomi/ruby"
remove_directory "./device/mediatek/sepolicy_vndr"
remove_directory "./hardware/mediatek"

# Parallel cloning of repositories.
clone_repository "https://github.com/PQEnablers-Devices/android_kernel_xiaomi_mt6877" "lineage-20" "./kernel/xiaomi/mt6877"
clone_repository "https://github.com/PQEnablers-Devices/android_vendor_xiaomi_ruby" "lineage-20" "./vendor/xiaomi/ruby"
clone_repository "https://github.com/PQEnablers-Devices/android_device_mediatek_sepolicy_vndr" "lineage-20" "./device/mediatek/sepolicy_vndr"
clone_repository "https://github.com/PQEnablers-Devices/android_hardware_mediatek" "lineage-20-foss" "./hardware/mediatek"
clone_repository "https://github.com/LineageOS/android_hardware_xiaomi" "lineage-20" "./hardware/xiaomi"

# Display a completion message.
echo "All necessary repositories have been successfully cloned for $device_name's development environment. Your setup is complete."

# Reminder to remove vendorsetup.sh.
echo "Don't forget to remove vendorsetup.sh from the ./device/xiaomi/ruby folder."


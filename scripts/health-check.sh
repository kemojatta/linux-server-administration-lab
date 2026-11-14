#!/bin/bash
# Reconstructed from the script shown in the completed lab screenshot.
echo "===== SERVER HEALTH CHECK ====="
uptime
free -h
df -h /
systemctl is-active nginx

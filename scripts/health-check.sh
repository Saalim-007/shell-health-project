#!/bin/bash

# Default configuration
CONFIG_FILE="config/health.conf"

# Optional configuration argument
if [ -n "$1" ]; then
    CONFIG_FILE="$1"
fi

# Configuration file check
if [ ! -f "$CONFIG_FILE" ]; then
    echo "ERROR: Configuration file not found"
    exit 2
fi

# Health status
HEALTH_FAILED=0

ENVIRONMENT="${ENVIRONMENT:-local}"

echo "===== SERVER HEALTH ====="
echo

echo "Hostname:"
hostname
echo

echo "Uptime:"
uptime
echo

echo "Load Average:"
uptime | awk -F'load average:' '{print $2}'
echo

echo "CPU:"
top -bn1 | grep "Cpu(s)"
echo

echo "Memory:"
free -h
echo

echo "Disk:"
df -h /
echo

echo "Top CPU Process:"
ps aux --sort=-%cpu | head -n 2
echo

echo "Top Memory Process:"
ps aux --sort=-%mem | head -n 2
echo

echo "Listening Ports:"
ss -tuln
echo

# Example health check
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$DISK_USAGE" -ge 90 ]; then
    echo "WARNING: Disk usage is above 90%"
    HEALTH_FAILED=1
fi

# Final exit code
if [ "$HEALTH_FAILED" -eq 1 ]; then
    echo
    echo "Health check FAILED"
    exit 1
fi

echo
echo "Health check PASSED"
exit 0

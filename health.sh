#!/bin/bash

echo "===== SERVER HEALTH ====="
echo ""

echo "Hostname:"
hostname

echo "Uptime:"
uptime -p

echo "Load Average:"
cat /proc/loadavg | awk '{print $1, $2, $3}'

echo "CPU:"
top -bn1 | grep "Cpu(s)" | awk '{print "Usage: " 100 - $8 "%"}'

echo "Memory:"
free -h | awk '/Mem:/ {print "Used:", $3, "/", $2}'

echo "Disk:"
df -h / | awk 'NR==2 {print "Used:", $3, "/", $2, "(" $5 ")"}'

echo "Top CPU Process:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 2

echo "Top Memory Process:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 2

echo "Listening Ports:"
ss -tuln | grep LISTEN

echo "Failed Services:"
systemctl --failed --no-legend

echo "========================="

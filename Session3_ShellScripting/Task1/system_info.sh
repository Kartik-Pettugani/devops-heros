#!/bin/bash

mkdir -p result
cd result

touch result.log

today_date=$(date +"%Y-%m-%d")
host_name=$(hostname)
username=$(whoami)
process=$(ps)
diskspace=$(df -h)

read -p "Enter your name: " name
read -p "Enter your roll no: " roll_no
read -p "Enter the comment: " cmt

echo "===== SYSTEM INFORMATION ====="

echo "Today's date is: $today_date"
echo "Hostname: $host_name"
echo "Username: $username"

echo ""
echo "===== DISK USAGE ====="
echo "$diskspace"

echo ""
echo "===== RUNNING PROCESSES ====="
echo "$process"

echo ""
echo "===== USER INFORMATION ====="
echo "My name is: $name"
echo "My roll number is: $roll_no"
echo "My comment is: $cmt"

echo "Today's date is: $today_date" >> result.log
echo "Hostname: $host_name" >> result.log
echo "Username: $username" >> result.log

echo "" >> result.log
echo "===== DISK USAGE =====" >> result.log
echo "$diskspace" >> result.log

echo "" >> result.log
echo "===== USER INFORMATION =====" >> result.log
echo "My name is: $name" >> result.log
echo "My roll number is: $roll_no" >> result.log
echo "My comment is: $cmt" >> result.log

echo "$process" > process.log

echo ""
echo "Process information has been stored in process.log"
echo "System information has been stored in result.log"
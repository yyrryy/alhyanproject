@echo off
git config --global user.name "Your Name"
git config --global user.email "youremail@example.com"

REM Pull the latest code from GitHub
git pull origin main

REM Run Django migrations
py manage.py makemigrations
py manage.py migrate
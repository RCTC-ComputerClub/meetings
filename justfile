# Load environment variables from .env file if it exists
set dotenv-load := true

# Set shell to PowerShell on Windows
set shell := ["powershell", "-ExecutionPolicy", "Bypass", "-Command"]

# Default recipe shows available commands
default:
    just --list

# Show available recipes
help:
    just --list

# Create a new agenda file for a specific date
# Usage: just create-agenda 2025-12-25
create-agenda date:
    $date = '{{date}}'; if ($date -notmatch '^\d{4}-\d{2}-\d{2}$') { Write-Output 'Error: Date must be in YYYY-MM-DD format'; exit 1 }; $year = $date.Substring(0, 4); if (!(Test-Path "main/$year")) { New-Item -ItemType Directory -Path "main/$year" | Out-Null }; $agendaFile = "main/$year/agenda-$date.md"; Copy-Item "main/agenda-template.md" -Destination $agendaFile; $monthNum = [int]$date.Substring(5, 2); $monthName = switch ($monthNum) { 1 { "January" }; 2 { "February" }; 3 { "March" }; 4 { "April" }; 5 { "May" }; 6 { "June" }; 7 { "July" }; 8 { "August" }; 9 { "September" }; 10 { "October" }; 11 { "November" }; 12 { "December" } }; $day = [int]$date.Substring(8, 2); $content = Get-Content $agendaFile -Raw; $content = $content -replace '{month}', $monthName; $content = $content -replace '{day}', $day; $content = $content -replace '{date}', $date; $content = $content -replace '{time}', '10:00 AM'; Set-Content $agendaFile -Value $content; Write-Output "Created agenda file: $agendaFile"

# Create agenda for today
create-today-agenda:
    $today = Get-Date -Format "yyyy-MM-dd"; just create-agenda $today

# List all agendas
list-agendas:
    Get-ChildItem -Path "main" -Recurse -Filter "agenda-*.md" -ErrorAction SilentlyContinue | ForEach-Object { Write-Output $_.FullName }

# Show the agenda template
show-template:
    Get-Content "main/agenda-template.md"

# Initialize the project structure
init:
    Write-Output "Initializing project structure..."; if (!(Test-Path "main/2025")) { New-Item -ItemType Directory -Path "main/2025" | Out-Null }; Write-Output "Project structure initialized!"

# Clean up empty agenda files (for testing)
clean:
    $templateLength = (Get-Item "main/agenda-template.md").Length; Get-ChildItem -Path "main" -Recurse -Filter "agenda-*.md" -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne "agenda-template.md" } | ForEach-Object { if ($_.Length -eq $templateLength) { Remove-Item $_.FullName -Force; Write-Output "Deleted empty agenda file: $($_.FullName)" } }; Write-Output "Clean up completed"

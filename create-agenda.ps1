param(
    [Parameter(Mandatory=$true)]
    [string]$Date
)

# Validate date format (YYYY-MM-DD)
if ($Date -notmatch '^\d{4}-\d{2}-\d{2}$') {
    Write-Output "Error: Date must be in YYYY-MM-DD format"
    exit 1
}

try {
    $dateObj = [DateTime]::ParseExact($Date, "yyyy-MM-dd", [System.Globalization.CultureInfo]::InvariantCulture)
} catch {
    Write-Output "Error: Invalid date"
    exit 1
}

$year = $dateObj.Year
$monthName = $dateObj.ToString("MMMM")
$day = $dateObj.Day

# Create year directory if it doesn't exist
$yearPath = "main/$year"
if (!(Test-Path $yearPath)) {
    New-Item -ItemType Directory -Path $yearPath | Out-Null
}

# Create the agenda file name
$agendaFile = "main/$year/agenda-$Date.md"

# Copy template to new agenda file
Copy-Item "main/agenda-template.md" -Destination $agendaFile

# Read content, replace placeholders, and write back
$content = Get-Content $agendaFile -Raw
$content = $content -replace '{month}', $monthName
$content = $content -replace '{day}', $day
$content = $content -replace '{date}', $Date
$content = $content -replace '{time}', '10:00 AM'
Set-Content $agendaFile -Value $content

Write-Output "Created agenda file: $agendaFile"

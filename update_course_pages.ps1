# PowerShell script to update courses menu in course detail pages

Write-Host "Updating course detail pages..."

$courseFiles = @(
    "course-teacher-training-l5.html",
    "course-intro-management-l3.html",
    "course-hrm-l45.html",
    "course-business-management-l45.html",
    "course-business-management-l3.html",
    "course-business-admin-l6.html"
)

# Read the new courses menu structure from index.html
$indexContent = Get-Content "index.html" -Raw

# Extract just the courses dropdown structure
$pattern = '(?s)(<li class="alp-courses-menu">.*?</div>\s*</li>)'

if ($indexContent -match $pattern) {
    $newCoursesMenu = $matches[1]
    Write-Host "Extracted new courses menu"
    
    foreach ($file in $courseFiles) {
        if (Test-Path $file) {
            Write-Host "Processing $file..."
            $content = Get-Content $file -Raw
            
            # Pattern to match old mega-menu with current class
            $oldPattern = '(?s)<li class="mega-menu current">.*?</div>\s*</div>\s*</div>\s*</li>'
            
            if ($content -match $oldPattern) {
                # Replace with new menu but keep the "current" class
                $newMenuWithCurrent = $newCoursesMenu -replace 'class="alp-courses-menu"', 'class="alp-courses-menu current"'
                $updated = $content -replace $oldPattern, $newMenuWithCurrent
                $updated | Set-Content $file -NoNewline
                Write-Host "  Updated successfully"
            } else {
                Write-Host "  Pattern not found"
            }
        }
    }
    
    Write-Host "`nCourse pages updated!"
} else {
    Write-Host "Error: Could not extract menu from index.html"
}

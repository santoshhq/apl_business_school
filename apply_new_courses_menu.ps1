# PowerShell script to update courses submenu in all HTML files

Write-Host "Starting courses menu update..."

$files = @(
    "faq.html",
    "course-teacher-training-l5.html",
    "course-intro-management-l3.html",
    "course-hrm-l45.html",
    "course-business-management-l45.html",
    "course-business-management-l3.html",
    "course-business-admin-l6.html",
    "about-introduction.html",
    "about-equality-diversity.html",
    "about-accreditations.html",
    "about-mission-vision.html",
    "about-location.html",
    "apply-now.html"
)

# Read the new courses menu from index.html
$indexContent = Get-Content "index.html" -Raw

# Extract the new courses menu
$pattern = '(?s)(<li class="alp-courses-menu">.*?</li>\s*<li><a href="faq\.html">FAQ</a></li>)'

if ($indexContent -match $pattern) {
    $newCoursesMenu = $matches[1]
    Write-Host "Extracted new courses menu structure"
    
    # Update each file
    foreach ($file in $files) {
        if (Test-Path $file) {
            Write-Host "Updating $file..."
            $content = Get-Content $file -Raw
            
            # Pattern to match old mega-menu structure
            $oldPattern = '(?s)(<li class="(mega-menu|alp-courses-menu)">.*?</li>\s*<li><a href="faq\.html">FAQ</a></li>)'
            
            if ($content -match $oldPattern) {
                $updated = $content -replace $oldPattern, $newCoursesMenu
                $updated | Set-Content $file -NoNewline
                Write-Host "  Completed"
            } else {
                Write-Host "  Pattern not found - skipping"
            }
        } else {
            Write-Host "  File not found: $file"
        }
    }
    
    Write-Host "`nAll files updated successfully!"
} else {
    Write-Host "Error: Could not extract courses menu from index.html"
}

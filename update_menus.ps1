# Script to update courses mega menu in all HTML files

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

# Read the updated mega menu from index.html
$indexContent = Get-Content "index.html" -Raw

# Extract the mega menu section (from <div class="mega-menu-dropdown"> to its closing </div>)
$pattern = '(?s)(<div class="mega-menu-dropdown">.*?<!-- Creative & Media -->.*?</div>\s*</div>\s*</div>\s*</div>)'
if ($indexContent -match $pattern) {
    $newMegaMenu = $matches[1]
    Write-Host "Extracted new mega menu structure" -ForegroundColor Green
    
    foreach ($file in $files) {
        Write-Host "Updating $file..." -ForegroundColor Cyan
        $content = Get-Content $file -Raw
        
        # Replace old mega menu with new one
        $updated = $content -replace $pattern, $newMegaMenu
        
        # Save the file
        $updated | Set-Content $file -NoNewline
        Write-Host "  Completed" -ForegroundColor Green
    }
    
    Write-Host "`nAll files updated successfully!" -ForegroundColor Green
} else {
    Write-Host "Could not find mega menu section in index.html" -ForegroundColor Red
}

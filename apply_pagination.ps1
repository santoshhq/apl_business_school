# PowerShell script to update ALL pages with new paginated courses menu

Write-Host "Updating all pages with paginated courses menu..."

$allFiles = @(
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

# Read from index.html
$indexContent = Get-Content "index.html" -Raw

# Extract the new courses menu structure
$menuPattern = '(?s)(<li class="alp-courses-menu">.*?</div>\s*</div>\s*</li>)'

if ($indexContent -match $menuPattern) {
    $newMenu = $matches[1]
    Write-Host "Extracted new paginated menu"
    
    foreach ($file in $allFiles) {
        if (Test-Path $file) {
            Write-Host "Updating $file..."
            $content = Get-Content $file -Raw
            
            # For course pages with "current" class
            if ($file -like "course-*.html") {
                $oldPattern = '(?s)<li class="(alp-courses-menu|mega-menu) current">.*?</div>\s*</div>\s*</li>'
                $menuWithCurrent = $newMenu -replace 'class="alp-courses-menu"', 'class="alp-courses-menu current"'
                
                if ($content -match $oldPattern) {
                    $updated = $content -replace $oldPattern, $menuWithCurrent
                    $updated | Set-Content $file -NoNewline
                    Write-Host "  Completed (with current class)"
                }
            } else {
                # For other pages
                $oldPattern = '(?s)<li class="(alp-courses-menu|mega-menu)">.*?</div>\s*</div>\s*</li>'
                
                if ($content -match $oldPattern) {
                    $updated = $content -replace $oldPattern, $newMenu
                    $updated | Set-Content $file -NoNewline
                    Write-Host "  Completed"
                }
            }
        }
    }
    
    Write-Host "`n=== Updating JavaScript ==="
    
    # Extract new JavaScript from index.html
    $jsPattern = '(?s)(<!-- Courses Menu Pagination Script -->.*?</script>)'
    
    if ($indexContent -match $jsPattern) {
        $newJS = $matches[1]
        Write-Host "Extracted new pagination JavaScript"
        
        foreach ($file in $allFiles) {
            if (Test-Path $file) {
                Write-Host "Adding JS to $file..."
                $content = Get-Content $file -Raw
                
                # Find and replace old script or add before </body>
                $oldJSPattern = '(?s)<!-- Courses Menu (Accordion Script|Pagination Script).*?</script>'
                
                if ($content -match $oldJSPattern) {
                    $updated = $content -replace $oldJSPattern, $newJS
                } else {
                    # Add before </body>
                    $updated = $content -replace '(</body>)', "`n    $newJS`n`$1"
                }
                
                $updated | Set-Content $file -NoNewline
                Write-Host "  JS updated"
            }
        }
    }
    
    Write-Host "`nAll pages updated with pagination!"
} else {
    Write-Host "Error: Could not extract menu from index.html"
}

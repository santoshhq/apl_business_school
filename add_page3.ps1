# PowerShell script to add Page 3 (Higher Education) to all HTML files

Write-Host "Adding Higher Education Degrees page to all files..."

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

# 1. Update navigation indicators (2 to 3 dots)
Write-Host "`n=== Step 1: Updating navigation indicators ==="
foreach ($file in $allFiles) {
    if (Test-Path $file) {
        Write-Host "Updating $file indicators..."
        $content = Get-Content $file -Raw
        
        $oldNav = '<div class="alp-course-indicators">
                                            <span class="alp-indicator active"></span>
                                            <span class="alp-indicator"></span>
                                        </div>'
        
        $newNav = '<div class="alp-course-indicators">
                                            <span class="alp-indicator active"></span>
                                            <span class="alp-indicator"></span>
                                            <span class="alp-indicator"></span>
                                        </div>'
        
        $updated = $content -replace [regex]::Escape($oldNav), $newNav
        $updated | Set-Content $file -NoNewline
        Write-Host "  Indicators updated"
    }
}

# 2. Add Page 3 content before closing </div></div></li>
Write-Host "`n=== Step 2: Adding Page 3 content ==="

$page3Content = @'

                                    <!-- Page 3: Higher Education Degrees -->
                                    <div class="alp-courses-page" data-page="3">
                                        <div class="alp-courses-container alp-single-category">
                                            
                                            <!-- Higher Education Degrees -->
                                            <div class="alp-course-category">
                                                <h4 class="alp-category-title">Higher Education Degrees</h4>
                                                <div class="alp-courses-list">
                                                    <p class="alp-level">Level 7 Computer Science</p>
                                                    <a href="#">• Level 7 Computing & Computer Science</a>
                                                    
                                                    <p class="alp-level">Master's Degrees</p>
                                                    <a href="#">• MBA (Master of Business Administration)</a>
                                                    <a href="#">• MSc (Master of Science)</a>
                                                    
                                                    <p class="alp-level">Bachelor's Degrees</p>
                                                    <a href="#">• BBA (Bachelor of Business Administration)</a>
                                                    <a href="#">• BSc (Bachelor of Science)</a>
                                                    <a href="#">• BA Honours (Bachelor of Arts with Honours)</a>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
'@

foreach ($file in $allFiles) {
    if (Test-Path $file) {
        Write-Host "Adding Page 3 to $file..."
        $content = Get-Content $file -Raw
        
        # Find the pattern just before closing </div></div></li> for courses menu
        $pattern = '(\s*</div>\s*</div>\s*</li>\s*<li><a href="faq\.html">FAQ</a></li>)'
        
        if ($content -match $pattern) {
            $replacement = $page3Content + "`n" + $matches[1]
            $updated = $content -replace $pattern, $replacement
            $updated | Set-Content $file -NoNewline
            Write-Host "  Page 3 added"
        }
    }
}

# 3. Update JavaScript totalPages from 2 to 3
Write-Host "`n=== Step 3: Updating JavaScript ==="
foreach ($file in $allFiles) {
    if (Test-Path $file) {
        Write-Host "Updating JS in $file..."
        $content = Get-Content $file -Raw
        
        $updated = $content -replace 'const totalPages = 2;', 'const totalPages = 3;'
        $updated | Set-Content $file -NoNewline
        Write-Host "  JavaScript updated"
    }
}

Write-Host "`n=== All files updated with Page 3! ==="

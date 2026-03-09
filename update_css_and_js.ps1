# Update all HTML files with CSS override and JavaScript for mega menu

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

$cssOverride = @"

        /* -------- Mega Menu Content Override -------- */
        @media (min-width: 992px) {
            .mega-menu:hover .mega-menu-column__content {
                display: block !important;
            }
        }
"@

$jsAccordion = @"

    <!-- Mega Menu Accordion Script for Mobile/Tablet -->
    <script>
        (function() {
            // Handle mega menu column accordion on smaller screens
            const menuColumns = document.querySelectorAll('.mega-menu-column__title');
            
            menuColumns.forEach(function(title) {
                title.addEventListener('click', function() {
                    const column = this.closest('.mega-menu-column');
                    
                    // Toggle active class
                    column.classList.toggle('active');
                });
            });

            // On desktop (>991px), ensure all content is visible when mega menu is shown
            function handleMegaMenuDisplay() {
                const megaMenus = document.querySelectorAll('.mega-menu');
                
                megaMenus.forEach(function(menu) {
                    menu.addEventListener('mouseenter', function() {
                        if (window.innerWidth > 991) {
                            // On desktop, show all content
                            const columns = this.querySelectorAll('.mega-menu-column');
                            columns.forEach(function(col) {
                                col.classList.add('active');
                            });
                        }
                    });
                    
                    menu.addEventListener('mouseleave', function() {
                        if (window.innerWidth > 991) {
                            // On desktop, keep all content visible while hovering
                            const columns = this.querySelectorAll('.mega-menu-column');
                            columns.forEach(function(col) {
                                col.classList.remove('active');
                            });
                        }
                    });
                });
            }
            
            handleMegaMenuDisplay();
        })();
    </script>
"@

foreach ($file in $files) {
    Write-Host "Updating $file..."
    
    $content = Get-Content $file -Raw
    
    # Check if CSS override already exists
    if ($content -notmatch "Mega Menu Content Override") {
        # Add CSS before closing </style> tag in head
        $content = $content -replace '(\s*</style>)', "$cssOverride`$1"
        Write-Host "  Added CSS override"
    }
    
    # Check if JS accordion already exists
    if ($content -notmatch "Mega Menu Accordion Script") {
        # Add JavaScript before closing </body> tag
        $content = $content -replace '(\s*</body>)', "$jsAccordion`$1"
        Write-Host "  Added JavaScript accordion"
    }
    
    $content | Set-Content $file -NoNewline
    Write-Host "  Completed"
}

Write-Host ""
Write-Host "All files updated with CSS and JavaScript!"

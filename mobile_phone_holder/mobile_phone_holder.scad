show_phone_holder = true; // Toggle the phone holder bracket visibility
show_wedge        = true; // Toggle the angled mounting wedge visibility
show_bolt_holes   = true; // Toggle the bolt holes and counterbores

// --- PHONE PARAMETERS ---
p_width      = 85;   // Internal width for the phone
p_height     = 115;  // Internal height for the phone
p_depth      = 13;   // Internal thickness/depth for the phone
p_wall       = 3;    // Thickness of the holder walls
p_lip_side   = 12.5; // Width of the retaining lips on the left and right
p_lip_bottom = 5;    // Height of the retaining lip at the bottom
p_tolerance  = 0.0;  // Extra spacing for fitment clearance

// --- WEDGE PARAMETERS ---
wedge_thick    = 50; // Thickness of the wedge at its thickest point
wedge_thin     = 0;  // Thickness of the wedge at its thinnest point
wedge_h        = 70; // Total height of the mounting wedge
wedge_z_offset = 0;  // Vertical offset for the wedge position 
wedge_skew_x   = 20; 
wedge_custom_width = 70; 
wedge_pos_offset_x = -10;

// --- BOLT HOLE PARAMETERS ---
bolt_diameter  = 8.4;  // Diameter of the main bolt shaft
counterbore_d  = 20.5; // Diameter of the counterbore (bolt head hole)
counterbore_h  = 45;   // Depth of the counterbore
bolt_spread    = 0.5;  // Vertical spacing ratio between the two bolts

// Render

holder_outer_width = p_width + (2 * p_wall) + p_tolerance;

if (show_phone_holder) {
    phone_holder(p_width, p_height, p_depth, p_wall, p_lip_side, p_lip_bottom, p_tolerance);
}

if (show_wedge) {
    real_wedge_w = (wedge_custom_width > 0) ? wedge_custom_width : holder_outer_width;
    

    center_offset_x = (holder_outer_width - real_wedge_w) / 2;


    translate([center_offset_x + wedge_pos_offset_x, 0.01, wedge_z_offset]) {
        if (show_bolt_holes) {
            difference() {
                wedge_back(real_wedge_w, wedge_h, wedge_thick, wedge_thin, wedge_skew_x);
                
                translate([wedge_skew_x / 2, 0, 0]) 
                    bolt_holes_sideways(real_wedge_w, wedge_h, wedge_thick, bolt_spread);
            }
        } else {
            wedge_back(real_wedge_w, wedge_h, wedge_thick, wedge_thin, wedge_skew_x);
        }
    }
}

// --- MODULES ---

module phone_holder(inner_width, inner_height, inner_depth, wall, lip_s, lip_b, tolerance) {
    total_width  = inner_width + (2 * wall) + tolerance;
    total_depth  = wall + (inner_depth + tolerance) + wall;
    total_height = inner_height + wall;

    difference() {
        cube([total_width, total_depth, total_height]);
        
        translate([wall, wall, wall]) {
            cube([inner_width + tolerance, inner_depth + tolerance, inner_height + 1]);
        }
        
        translate([wall + lip_s, wall + inner_depth + tolerance - 0.05, wall + lip_b]) {
            cube([(inner_width + tolerance) - (2 * lip_s), wall + 1, inner_height + 1]);
        }
    }
}

module wedge_back(w_width, w_height, t_thick, t_thin, skew) {
    points = [
        [0, 0, 0], 
        [w_width, 0, 0], 
        [w_width + skew, -t_thin, 0], 
        [0 + skew, -t_thick, 0],
        
        [0, 0, w_height], 
        [w_width, 0, w_height], 
        [w_width + skew, -t_thin, w_height], 
        [0 + skew, -t_thick, w_height]
    ];
    faces = [
        [0, 3, 2, 1], [0, 1, 5, 4], [4, 5, 6, 7], 
        [1, 2, 6, 5], [0, 4, 7, 3], [3, 7, 6, 2]
    ];
    polyhedron(points = points, faces = faces);
}

module bolt_holes_sideways(w_width, w_height, t_thick, spread) {
    y_pos  = -t_thick / 2; 
    z_low  = w_height * (0.5 - spread/2);
    z_high = w_height * (0.5 + spread/2);

    for(z_pos = [z_low, z_high]) {
        translate([-50, y_pos , z_pos]) {
            rotate([0, 90, 0]) {
                cylinder(d = bolt_diameter, h = w_width + 100, $fn = 50);
                
                translate([0, 0, w_width + 50 + 10 - counterbore_h]) {
                    cylinder(d = counterbore_d, h = counterbore_h + 1, $fn = 60);
                }
            }
        }
    }
}

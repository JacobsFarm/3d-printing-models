// --- Render Options ---
show_box = true;        // Set to true to render the bottom enclosure
show_lid = true;        // Set to true to render the top lid

// --- Dimensions ---
L = 100;                // Outer length of the box
W = 85;                 // Outer width of the box
H_box = 45;             // Height of the bottom box part
H_lid = 5;              // Total thickness of the lid
wall = 4;               // Outer wall thickness
bottom_thickness = 2;   // Thickness of the bottom floor
R = 6;                  // Outer corner radius

// --- Glands X-axis (Sides) ---
show_gland_1 = true;    // Toggle gland 1 (Left)
gland_1_D    = 20.4;    // Diameter of gland 1

show_gland_2 = true;    // Toggle gland 2 (Right)
gland_2_D    = 28.5;    // Diameter of gland 2

// --- Glands Y-axis (Front & Back) ---
show_gland_y_front_left  = false;
gland_y_front_left_D     = 12.5;

show_gland_y_front_right = false;
gland_y_front_right_D    = 16.2;

show_gland_y_back_left   = false;
gland_y_back_left_D      = 20.4;

show_gland_y_back_right  = false;
gland_y_back_right_D     = 16.2;

gland_y_spacing = 40;   // Center-to-center distance between Y-axis holes

// --- Lip & Seal ---
lip_h = 3;              // Height of the interlocking lip
lip_offset = 2;         // Thickness/offset of the inner lip
fit_tolerance = 0.2;    // Extra clearance between lid and box

// --- Mounting Posts & Screws ---
show_mid_pillars = false; // Extra pillars in the middle (Y-axis walls)
show_end_pillars = false; // Extra pillars in the middle (X-axis walls)

post_R = 6;             // Radius of the solid screw posts
hole_R = 1.8;           // Radius of the screw hole
head_R = 3.8;           // Radius of the screw head top
head_depth = 2.5;       // Depth of the screw head chamfer
fillet_R = 3;           // Radius of the fillet between posts and walls

// --- Mounting Feet ---
enable_front_foot = false; // Changed from left to front
enable_back_foot = false;  // Changed from right to back
foot_width = 30;
foot_length = 20;
screw_hole_diameter = 4.5;
gusset_height = 15;

// --- Resolution ---
$fn = 60;

// --- Modules ---

module outer_profile() {
    offset(r=R) square([L - 2*R, W - 2*R], center=true);
}

module raw_cavity() {
    difference() {
        offset(r=R - wall) square([L - 2*R, W - 2*R], center=true);
        // Corner pillars
        for(i = [-1, 1], j = [-1, 1]) {
            translate([i*(L/2 - R), j*(W/2 - R)])
                circle(r=post_R);
        }
        
        // Mid pillars on long sides
        if (show_mid_pillars) {
            for(j = [-1, 1]) {
                translate([0, j*(W/2 - R)])
                    circle(r=post_R);
            }
        }

        // Mid pillars on short sides
        if (show_end_pillars) {
            for(i = [-1, 1]) {
                translate([i*(L/2 - R), 0])
                    circle(r=post_R);
            }
        }
    }
}

module cavity_profile() {
    offset(r=fillet_R) 
        offset(r=-fillet_R) 
            raw_cavity();
}

module lip_profile() {
    difference() {
        offset(r=lip_offset) cavity_profile();
        cavity_profile();
    }
}

module mounting_foot() {
    difference() {
        union() {
            // Flat Base Plate
            translate([0, -foot_width/2, 0])
                cube([foot_length, foot_width, bottom_thickness]);
            
            // Front Gusset (Aangepast zodat hij niet onder de bodemplaat zakt op het einde)
            translate([0, -foot_width/2 + wall/2, 0])
                rotate([90, 0, 0])
                linear_extrude(wall, center=true)
                polygon(points=[
                    [-0.1, 0], 
                    [foot_length, 0], 
                    [foot_length, bottom_thickness], 
                    [-0.1, gusset_height + bottom_thickness]
                ]);
                
            // Back Gusset (Aangepast zodat hij niet onder de bodemplaat zakt op het einde)
            translate([0, foot_width/2 - wall/2, 0])
                rotate([90, 0, 0])
                linear_extrude(wall, center=true)
                polygon(points=[
                    [-0.1, 0], 
                    [foot_length, 0], 
                    [foot_length, bottom_thickness], 
                    [-0.1, gusset_height + bottom_thickness]
                ]);
        }
        
        // Centered Screw Hole
        translate([foot_length/2, 0, -1])
            cylinder(d=screw_hole_diameter, h=bottom_thickness + 2);
    }
}

module enclosure_box() {
    gland_z = bottom_thickness + (H_box - bottom_thickness) / 2;
    difference() {
        union() {
            // Bottom Floor
            linear_extrude(bottom_thickness)
                outer_profile();
            
            // Walls
            translate([0, 0, bottom_thickness])
                linear_extrude(H_box - lip_h - bottom_thickness)
                    difference() {
                        outer_profile();
                        cavity_profile();
                    }

            // Lip for the lid
            translate([0, 0, H_box - lip_h])
                linear_extrude(lip_h)
                    lip_profile();
                    
            // --- External Mounting Feet Integration ---
            if (enable_front_foot) {
                translate([0, -W/2, 0])
                    rotate([0, 0, -90])
                    mounting_foot();
            }
            if (enable_back_foot) {
                translate([0, W/2, 0])
                    rotate([0, 0, 90])
                    mounting_foot();
            }
        }

        // Corner screw holes
        for(i = [-1, 1], j = [-1, 1]) {
            translate([i*(L/2 - R), j*(W/2 - R), bottom_thickness])
                cylinder(r=hole_R, h=H_box + 1);
        }
        
        // Long side pillar screw holes
        if (show_mid_pillars) {
            for(j = [-1, 1]) {
                translate([0, j*(W/2 - R), bottom_thickness])
                    cylinder(r=hole_R, h=H_box + 1);
            }
        }

        // Short side pillar screw holes
        if (show_end_pillars) {
            for(i = [-1, 1]) {
                translate([i*(L/2 - R), 0, bottom_thickness])
                    cylinder(r=hole_R, h=H_box + 1);
            }
        }
        
        // Gland holes
        if (show_gland_1) {
            translate([-L/2, 0, gland_z])
                rotate([0, 90, 0])
                cylinder(d=gland_1_D, h=wall * 4, center=true);
        }
            
        if (show_gland_2) {
            translate([L/2, 0, gland_z])
                rotate([0, 90, 0])
                cylinder(d=gland_2_D, h=wall * 4, center=true);
        }
            
        if (show_gland_y_front_left) {
            translate([-gland_y_spacing/2, -W/2, gland_z])
                rotate([90, 0, 0])
                cylinder(d=gland_y_front_left_D, h=wall * 4, center=true);
        }
            
        if (show_gland_y_front_right) {
            translate([gland_y_spacing/2, -W/2, gland_z])
                rotate([90, 0, 0])
                cylinder(d=gland_y_front_right_D, h=wall * 4, center=true);
        }
            
        if (show_gland_y_back_left) {
            translate([-gland_y_spacing/2, W/2, gland_z])
                rotate([90, 0, 0])
                cylinder(d=gland_y_back_left_D, h=wall * 4, center=true);
        }
            
        if (show_gland_y_back_right) {
            translate([gland_y_spacing/2, W/2, gland_z])
                rotate([90, 0, 0])
                cylinder(d=gland_y_back_right_D, h=wall * 4, center=true);
        }
    }
}

module enclosure_lid() {
    difference() {
        linear_extrude(H_lid)
            outer_profile();
            
        // Lip cutout
        translate([0, 0, -0.1])
            linear_extrude(lip_h + 0.2)
                offset(r=lip_offset + fit_tolerance) cavity_profile();
                
        // Corner screw holes and chamfers
        for(i = [-1, 1], j = [-1, 1]) {
            translate([i*(L/2 - R), j*(W/2 - R), 0]) {
                translate([0, 0, -1])
                    cylinder(r=hole_R * 1.1, h=H_lid + 2);
                translate([0, 0, H_lid - head_depth])
                    cylinder(r1=hole_R * 1.1, r2=head_R, h=head_depth + 0.01);
            }
        }
        
        // Mid-pillar screw holes (Long sides)
        if (show_mid_pillars) {
            for(j = [-1, 1]) {
                translate([0, j*(W/2 - R), 0]) {
                    translate([0, 0, -1])
                        cylinder(r=hole_R * 1.1, h=H_lid + 2);
                    translate([0, 0, H_lid - head_depth])
                        cylinder(r1=hole_R * 1.1, r2=head_R, h=head_depth + 0.01);
                }
            }
        }

        // Mid-pillar screw holes (Short sides)
        if (show_end_pillars) {
            for(i = [-1, 1]) {
                translate([i*(L/2 - R), 0, 0]) {
                    translate([0, 0, -1])
                        cylinder(r=hole_R * 1.1, h=H_lid + 2);
                    translate([0, 0, H_lid - head_depth])
                        cylinder(r1=hole_R * 1.1, r2=head_R, h=head_depth + 0.01);
                }
            }
        }
    }
}

// --- Execution ---
if (show_box) {
    color("green") enclosure_box();
}

if (show_lid) {
    translate([0, 0, H_box + 25]) 
        color("Orange") enclosure_lid();
}

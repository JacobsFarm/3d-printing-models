// --- Render Options ---
show_box = true;    // Set to true to render the bottom enclosure
show_lid = true;    // Set to true to render the top lid

// --- Dimensions ---
L = 100;            // Outer length of the box
W = 85;             // Outer width of the box
H_box = 40;         // Height of the bottom box part
H_lid = 6;          // Total thickness of the lid
wall = 4;           // Outer wall thickness
R = 6;              // Outer corner radius

// --- Glands X-axis ---
show_gland_1 = true;      // Toggle gland 1 (X-axis, left side)
gland_1_D    = 20.5;      // Diameter of gland 1

show_gland_2 = true;      // Toggle gland 2 (X-axis, right side)
gland_2_D    = 28.5;      // Diameter of gland 2

// --- Glands Y-axis (Front & Back) ---
show_gland_y_front_left  = true;  // Toggle front left hole
gland_y_front_left_D     = 12.5;  // Diameter of front left hole (e.g., M12)

show_gland_y_front_right = true;  // Toggle front right hole
gland_y_front_right_D    = 16.2;  // Diameter of front right hole (e.g., M16)

show_gland_y_back_left   = true;  // Toggle back left hole
gland_y_back_left_D      = 20.4;  // Diameter of back left hole (e.g., M20)

show_gland_y_back_right  = true;  // Toggle back right hole
gland_y_back_right_D     = 16.2;  // Diameter of back right hole (e.g., M16)

gland_y_spacing = 40; // Center-to-center distance between left and right hole on the Y-axis

// --- Lip & Seal ---
lip_h = 2;          // Height of the interlocking lip
lip_offset = 2;     // Thickness/offset of the inner lip

// --- Tolerances & Fit ---
fit_tolerance = 0.2; // Extra clearance between lid and box

// --- Mounting Posts & Screws ---
post_R = 6;         // Radius of the solid screw posts in the corners
hole_R = 2;         // Radius of the screw hole
head_R = 3.8;       // Radius at the top of the head
head_depth = 2.5;   // Depth of the chamfer
fillet_R = 3;       // Radius of the smooth fillet between posts and walls

// --- Resolution ---
$fn = 60;           // Number of fragments for circles/arcs

module outer_profile() {
    offset(r=R) square([L - 2*R, W - 2*R], center=true);
}

module raw_cavity() {
    difference() {
        offset(r=R - wall) square([L - 2*R, W - 2*R], center=true);
        for(i = [-1, 1], j = [-1, 1]) {
            translate([i*(L/2 - R), j*(W/2 - R)])
                circle(r=post_R);
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

module enclosure_box() {
    difference() {
        union() {
            linear_extrude(wall)
                outer_profile();

            translate([0, 0, wall])
                linear_extrude(H_box - lip_h - wall)
                    difference() {
                        outer_profile();
                        cavity_profile();
                    }

            translate([0, 0, H_box - lip_h])
                linear_extrude(lip_h)
                    lip_profile();
        }

        for(i = [-1, 1], j = [-1, 1]) {
            translate([i*(L/2 - R), j*(W/2 - R), wall])
                cylinder(r=hole_R, h=H_box + 1);
        }
        
        if (show_gland_1) {
            translate([-L/2, 0, H_box/2])
                rotate([0, 90, 0])
                cylinder(d=gland_1_D, h=wall * 4, center=true);
        }
            
        if (show_gland_2) {
            translate([L/2, 0, H_box/2])
                rotate([0, 90, 0])
                cylinder(d=gland_2_D, h=wall * 4, center=true);
        }
            
        if (show_gland_y_front_left) {
            translate([-gland_y_spacing/2, -W/2, H_box/2])
                rotate([90, 0, 0])
                cylinder(d=gland_y_front_left_D, h=wall * 4, center=true);
        }
            
        if (show_gland_y_front_right) {
            translate([gland_y_spacing/2, -W/2, H_box/2])
                rotate([90, 0, 0])
                cylinder(d=gland_y_front_right_D, h=wall * 4, center=true);
        }
            
        if (show_gland_y_back_left) {
            translate([-gland_y_spacing/2, W/2, H_box/2])
                rotate([90, 0, 0])
                cylinder(d=gland_y_back_left_D, h=wall * 4, center=true);
        }
            
        if (show_gland_y_back_right) {
            translate([gland_y_spacing/2, W/2, H_box/2])
                rotate([90, 0, 0])
                cylinder(d=gland_y_back_right_D, h=wall * 4, center=true);
        }
    }
}

module enclosure_lid() {
    difference() {
        linear_extrude(H_lid)
            outer_profile();

        translate([0, 0, -0.1])
            linear_extrude(lip_h + 0.2)
                offset(r=lip_offset + fit_tolerance) cavity_profile();

        for(i = [-1, 1], j = [-1, 1]) {
            translate([i*(L/2 - R), j*(W/2 - R), 0]) {
                translate([0, 0, -1])
                    cylinder(r=hole_R * 1.1, h=H_lid + 2);
                
                translate([0, 0, H_lid - head_depth])
                    cylinder(r1=hole_R * 1.1, r2=head_R, h=head_depth + 0.01); 
            }
        }
    }
}

if (show_box) {
    color("green") enclosure_box();
}

if (show_lid) {
    translate([0, 0, H_box + 25]) 
        color("Orange") enclosure_lid();
}

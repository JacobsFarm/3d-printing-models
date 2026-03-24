// --- Render Options ---
show_box = true;    // Set to true to render the bottom enclosure
show_lid = true;    // Set to true to render the top lid

// --- Dimensions ---
L = 100;            // Outer length of the box
W = 85;             // Outer width of the box
H_box = 40;         // Height of the bottom box part
H_lid = 5.5;        // Total thickness of the lid
wall = 3.8;         // Outer wall thickness
R = 6;              // Outer corner radius

// --- Lip & Seal ---
lip_h = 3;          // Height of the interlocking lip
lip_offset = 2;     // Thickness/offset of the inner lip

// --- Tolerances & Fit ---
fit_tolerance = 0.2; // Extra clearance between lid and box (increase if too tight, decrease if too loose)

// --- Mounting Posts ---
post_R = 6;         // Radius of the solid screw posts in the corners
hole_R = 2;         // Radius of the screw hole (e.g., 1.5 for an M3 screw)

// --- Screw Head Settings ---
head_R = 3.8;       // Radius at the top of the head (increase for a shallower angle)
head_depth = 2.5;   // Depth of the chamfer (increase for a shallower angle)

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
    }
}

module enclosure_lid() {
    difference() {
        linear_extrude(H_lid)
            outer_profile();

        // Apply the fit_tolerance here for the lip offset
        translate([0, 0, -0.1])
            linear_extrude(lip_h + 0.2)
                offset(r=lip_offset + fit_tolerance) cavity_profile();

        for(i = [-1, 1], j = [-1, 1]) {
            translate([i*(L/2 - R), j*(W/2 - R), 0]) {
                
                // The straight through-hole for the screw
                translate([0, 0, -1])
                    cylinder(r=hole_R * 1.1, h=H_lid + 2);
                
                // Smooth (conical) countersink for the screw head
                translate([0, 0, H_lid - head_depth])
                    cylinder(r1=hole_R * 1.1, r2=head_R, h=head_depth + 0.01); 
            }
        }
    }
}

if (show_box) {
    color("LightSteelBlue") enclosure_box();
}

if (show_lid) {
    translate([0, 0, H_box + 25]) 
        color("Orange") enclosure_lid();
}

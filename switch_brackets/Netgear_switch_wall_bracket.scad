// --- Parameters ---
inner_length = 160;       // Internal length of the box
inner_width = 28;         // Internal width of the box
wall_thickness = 4;       // Thickness of the outer walls
wall_height = 40;         // Height of the box walls
backplate_height = 40;    // Independent height of the back mounting plate
overhang = 30;            // Extension of the mounting ears at the back

// --- Support Rim Parameters (The Stop) ---
support_rim_base = 5;     // Standard width of the support rim (front/back/sides)
support_height = 3;       // Thickness/height of the rim on the Z-axis

extra_support_left = 5;   // Extra width for the left support rim
extra_support_right = 5;  // Extra width for the right support rim

hole_diameter = 4.2;      // Diameter of the mounting holes
hole_distance_z = 10;     // Vertical distance of holes from top and bottom edge

// --- Calculations ---
outer_length = inner_length + (2 * wall_thickness);
outer_width = inner_width + (2 * wall_thickness);
backplate_length = outer_length + (2 * overhang);

total_support_left = support_rim_base + extra_support_left;
total_support_right = support_rim_base + extra_support_right;

// --- Model ---
difference() {
    union() {
        // 1. Backplate
        translate([-overhang, 0, 0])
            cube([backplate_length, wall_thickness, backplate_height]);

        // 2. Box Walls
        difference() {
            cube([outer_length, outer_width, wall_height]);

            // Main cavity
            translate([wall_thickness, wall_thickness, support_height])
                cube([inner_length, inner_width, wall_height + 1]);

            // Bottom opening (Pass-through)
            translate([wall_thickness + total_support_left, wall_thickness + support_rim_base, -1])
                cube([inner_length - total_support_left - total_support_right, 
                      inner_width - (2 * support_rim_base), 
                      support_height + 2]);

            // Clear back wall area for backplate integration
            translate([-1, -1, -1])
                cube([outer_length + 2, wall_thickness + 1, max(wall_height, backplate_height) + 2]);
        }
    }

    // 3. Screw Holes
    union() {
        // Left holes
        translate([-overhang/2, -1, hole_distance_z])
            rotate([-90, 0, 0]) cylinder(d=hole_diameter, h=wall_thickness + 2, $fn=50);
        translate([-overhang/2, -1, backplate_height - hole_distance_z])
            rotate([-90, 0, 0]) cylinder(d=hole_diameter, h=wall_thickness + 2, $fn=50);

        // Right holes
        translate([outer_length + overhang/2, -1, hole_distance_z])
            rotate([-90, 0, 0]) cylinder(d=hole_diameter, h=wall_thickness + 2, $fn=50);
        translate([outer_length + overhang/2, -1, backplate_height - hole_distance_z])
            rotate([-90, 0, 0]) cylinder(d=hole_diameter, h=wall_thickness + 2, $fn=50);
    }
}

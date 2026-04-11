// --- PARAMETERS ---
$fn = 100; // Resolution of the circles (higher is smoother)

// Main body dimensions (Outer layer)
outer_diameter = 50;
outer_height = 20;

// Dimensions for the stepped interior (Width = Diameter)
layer1_diameter = 30;
layer1_height = 4.5;

layer2_diameter = 35;
layer2_height = 6;

layer3_diameter = 42;
layer3_height = 10;

// --- RENDERING ---

difference() {
    // 1. Main body (The base shape)
    color("lightblue")
    cylinder(d = outer_diameter, h = outer_height, center = true);

    // 2. Cutouts (Subtracted from top to bottom)
    
    // Layer 1
    translate([0, 0, outer_height/2 - layer1_height/2])
        cylinder(d = layer1_diameter, h = layer1_height + 0.1, center = true);

    // Layer 2
    translate([0, 0, outer_height/2 - layer1_height - layer2_height/2])
        cylinder(d = layer2_diameter, h = layer2_height + 0.1, center = true);

    // Layer 3
    translate([0, 0, outer_height/2 - layer1_height - layer2_height - layer3_height/2])
        cylinder(d = layer3_diameter, h = layer3_height + 0.1, center = true);
}

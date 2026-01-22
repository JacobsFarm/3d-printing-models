// --- RENDER INSTELLINGEN ---
show_front_clamp = true;
show_back_clamp  = false;
show_ref_rod     = true;

// --- PARAMETERS ---
cylinder_diameter = 48; 
block_height      = 30;
block_depth       = 60;
block_width       = 80;
gap               = 3;  
tolerance         = 0.1; 

bolt_diameter     = 8.4;
// De bout komt nu in het midden, dus margin is niet meer direct nodig voor de lus
// Maar we behouden de variabelen voor overzicht

recess_diameter   = 16.2; 
recess_depth      = 5;  

$fn = 60; 

// Parameters voor de verbreding (ringen)
ring_h = 5; 
ring_t = 2; 
upper_ring_z = 17; 

// --- CALCULATIONS ---
x_pos_bolt = (cylinder_diameter / 2) + ((block_width - cylinder_diameter) / 4);
z_pos_bolt = block_height / 2; // Exact in het verticale midden

// --- MODULES ---

// --- AANGEPASTE MODULE ---

module internal_negative_shape() {
    d_with_tol = cylinder_diameter + tolerance;
    // De diameter van de ring in de klem moet ook de tolerantie krijgen
    ring_d_with_tol = (cylinder_diameter + (ring_t * 2)) + tolerance;
    
    // De bevel_size moet hier hetzelfde zijn als in de reference_rod
    bevel_size = 0.6; 

    // Centrale as gat
    translate([0, 0, -1]) 
        cylinder(h = block_height + 2, d = d_with_tol);
    
    // Onderste ring uitsparing (met bevel)
    render_beveled_ring(-0.1, ring_h + 0.1, ring_d_with_tol, bevel_size);
    
    // Bovenste ring uitsparing (met bevel)
    translate([0, 0, upper_ring_z])
        render_beveled_ring(0, ring_h, ring_d_with_tol, bevel_size);
}
module reference_rod() {
    // Variabele voor de grootte van het bevel (bijv. 1mm)
    bevel_size = 0.6; 
    
    if (show_ref_rod) {
        %union() {
            // De hoofdas
            cylinder(h = block_height, d = cylinder_diameter);
            
            // Onderste ring met bevel
            render_beveled_ring(0, ring_h, cylinder_diameter + (ring_t * 2), bevel_size);
            
            // Bovenste ring met bevel
            translate([0, 0, upper_ring_z])
                render_beveled_ring(0, ring_h, cylinder_diameter + (ring_t * 2), bevel_size);
        }
    }
}

// Hulpmiddel om een ring met bevels te maken
module render_beveled_ring(z, h, d, b) {
    translate([0, 0, z]) {
        union() {
            // Onderste schuine deel
            cylinder(h = b, d1 = d - (b * 2), d2 = d);
            
            // Middelste rechte deel
            translate([0, 0, b])
                cylinder(h = h - (b * 2), d = d);
            
            // Bovenste schuine deel
            translate([0, 0, h - b])
                cylinder(h = b, d1 = d, d2 = d - (b * 2));
        }
    }
}

// Aangepast naar 1 gat per zijde
module bolt_holes() {
    for (x = [-x_pos_bolt, x_pos_bolt]) {
        translate([x, 0, z_pos_bolt])
            rotate([90, 0, 0])
            cylinder(h = block_depth * 2, d = bolt_diameter, center = true);
    }
}

// Aangepast naar 1 uitsparing per zijde
module bolt_recesses(face_y_position) {
    for (x = [-x_pos_bolt, x_pos_bolt]) {
        translate([x, face_y_position, z_pos_bolt])
            rotate([90, 0, 0])
            cylinder(h = recess_depth * 2, d = recess_diameter, center = true);
    }
}

// VOORKANT
module front_clamp() {
    half_depth = (block_depth - gap) / 2;
    y_shift = (gap / 2) + (half_depth / 2);
    outer_y = y_shift + (half_depth / 2);

    difference() {
        translate([0, y_shift, block_height / 2])
            cube([block_width, half_depth, block_height], center = true);
        
        internal_negative_shape();
        bolt_holes();
        bolt_recesses(outer_y);
    }
}

// ACHTERKANT
module back_clamp() {
    half_depth = (block_depth - gap) / 2;
    y_shift = (gap / 2) + (half_depth / 2);
    outer_y = - (y_shift + (half_depth / 2));

    difference() {
        translate([0, -y_shift, block_height / 2])
            cube([block_width, half_depth, block_height], center = true);
        
        internal_negative_shape();
        bolt_holes();
        bolt_recesses(outer_y);
    }
}

// --- EXECUTION ---
reference_rod();

if (show_front_clamp) {
    color("Cyan") front_clamp();
}

if (show_back_clamp) {
    color("RoyalBlue") back_clamp();
}

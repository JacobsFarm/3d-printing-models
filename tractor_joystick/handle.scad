$fn = 60;

// Module 1: De asymmetrische basis
module basis_vorm() {
    rotate([0, 0, 180]) {
        hull() {
            translate([0, 0, 0]) circle(r=20);
            translate([30, 15, 0]) circle(r=35);
        }
    }
}

// Module 2: De ovale schijf
module ovale_schijf(straal) {
    scale([0.7, 1.0, 1]) circle(r=straal);
}

// --- CONFIGURATIE ---
straal_onder = 20;
x_schaal_ovaal = 0.7;
hoogte_deel_1 = 60;
hoogte_deel_2 = 15;
hoogte_deel_3 = 40; 

breedte_factor_max = 1.6;
breedte_factor_eind_d2 = 1.5;
breedte_factor_top_d3 = 1.1; 

y_schaal_top = 0.7; // Schijf wordt dunner op de Y-as
y_offset_top = -6;  // VERSCHUIIVING NAAR ACHTEREN (-Y)

// Berekeningen voor verticale rechterkant
verschuiving_x_max = -((straal_onder * x_schaal_ovaal * breedte_factor_max) - (straal_onder * x_schaal_ovaal));
verschuiving_x_eind_d2 = -((straal_onder * x_schaal_ovaal * breedte_factor_eind_d2) - (straal_onder * x_schaal_ovaal));
verschuiving_x_top_d3 = -((straal_onder * x_schaal_ovaal * breedte_factor_top_d3) - (straal_onder * x_schaal_ovaal));

// --- DE CONSTRUCTIE ---

// 1. De basisvorm
color("SteelBlue")
linear_extrude(height = 5.1) 
    basis_vorm();

translate([0, 0, 5]) {
    // 2. Deel 1: Uitlopend (0-60mm)
    color("Crimson")
    hull() {
        linear_extrude(height = 0.1) 
            ovale_schijf(straal = straal_onder);
        
        translate([verschuiving_x_max, 0, hoogte_deel_1]) 
            scale([breedte_factor_max, 1, 1]) 
                linear_extrude(height = 0.1)
                    ovale_schijf(straal = straal_onder);
    }

    // 3. Deel 2: Naar binnen komend (60-75mm)
    color("FireBrick")
    translate([0, 0, hoogte_deel_1]) {
        hull() {
            translate([verschuiving_x_max, 0, 0]) 
                scale([breedte_factor_max, 1, 1]) 
                    linear_extrude(height = 0.1)
                        ovale_schijf(straal = straal_onder);
            
            translate([verschuiving_x_eind_d2, 0, hoogte_deel_2]) 
                scale([breedte_factor_eind_d2, 1, 1]) 
                    linear_extrude(height = 0.1)
                        ovale_schijf(straal = straal_onder);
        }
    }

    // 4. Deel 3: Naar binnen (X), naar binnen (Voor/Y+) en naar achteren (-Y)
    color("Orange")
    translate([0, 0, hoogte_deel_1 + hoogte_deel_2]) {
        hull() {
            // Start (sluit aan op deel 2)
            translate([verschuiving_x_eind_d2, 0, 0]) 
                scale([breedte_factor_eind_d2, 1, 1]) 
                    linear_extrude(height = 0.1)
                        ovale_schijf(straal = straal_onder);
            
            // Top (verschoven naar -Y)
            translate([verschuiving_x_top_d3, y_offset_top, hoogte_deel_3]) 
                scale([breedte_factor_top_d3, y_schaal_top, 1]) 
                    linear_extrude(height = 0.1)
                        ovale_schijf(straal = straal_onder);
        }
    }
}

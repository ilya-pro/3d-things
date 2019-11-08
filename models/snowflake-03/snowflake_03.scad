// snowflake 3
// @author Ilya Protasov

/* TODO
? fix central figure for branch_count
*/

/* [Base] */
height = 3;
radius = 40;
hanger_type = "ring";// [ring, none]

/* [Extended] */
// coefficient of radius for central (main) branch thickness
central_thickness_coef = 0.125; // [0:0.001:0.300]
central_branch_start_coef = 0.25; // [0:0.001:1]

middle_branch_start_coef = 0.5; // [0:0.001:1]
middle_branch_length_coef = 0.3; // [0:0.001:1]
middle_thickness_coef = 0.100; // [0:0.001:0.300]

outer_branch_start_coef = 0.8; // [0:0.001:1]
outer_branch_length_coef = 0.2; // [0:0.001:1]
outer_thickness_coef = 0.100; // [0:0.001:0.300]

ring_inner_radius_coef = 0.065; // [0:0.001:0.300]
ring_thick_coef = 0.080; // [0:0.001:0.300]

/* [Quality ] */
//count of segments in arcs https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#$fa,_$fs_and_$fn
$fn = 24; 

/* [Hidden]  */
branch_count = 6;

thickMain = radius * central_thickness_coef;
middleThick = radius * middle_thickness_coef;
outerThick = radius * outer_thickness_coef;

module branchMain() {
    centralAngle = 120;//360 / branch_count * 2;
    lenHex = radius * central_branch_start_coef;
    middleStart = radius * middle_branch_start_coef;
    outerStart = radius * outer_branch_start_coef;
    
    //central hexagon
    translate([0, lenHex, 0]) rotate([0, 0, centralAngle]) branch2(thickMain, lenHex);
    
    //central branch
    translate([0, lenHex, 0]) branch2(thickMain, radius-lenHex);
    
    //middle branchs
    translate([0, middleStart, 0]) rotate([0, 0, 60]) branch2(middleThick, radius * middle_branch_length_coef);
    translate([0, middleStart, 0]) rotate([0, 0, -60]) branch2(middleThick, radius * middle_branch_length_coef);
    
    //outer branchs
    translate([0, outerStart, 0]) rotate([0, 0, 60]) branch2(outerThick, radius * outer_branch_length_coef);
    translate([0, outerStart, 0]) rotate([0, 0, -60]) branch2(outerThick, radius * outer_branch_length_coef);
}

module branch2(thick, length) {
    translate([-thick/2, 0, 0]) cube([thick, length, height], false);
    translate([0, length, 0]) cylinder(height, thick/2, thick/2, false);
}

module ring(height, outerR, innerR) {
    difference() {
        cylinder(height, outerR, outerR, true);
        cylinder(height * 2, innerR, innerR, true);
    }
}

module snowflake3(branchCount) {
    angle = 360 / branchCount;
    ringInnerRadius = radius * ring_inner_radius_coef;
    ringThick = radius * ring_thick_coef;
    for (i=[0:branchCount-1]) {
        rotate([0, 0, i * angle]) branchMain();
    }
    if (hanger_type == "ring") {
        translate([0, radius + ringInnerRadius + ringThick, height/2])
            ring(height = height, 
                 outerR = ringInnerRadius + ringThick,
                 innerR = ringInnerRadius );
    }
        
}

color("DeepSkyBlue") snowflake3(branch_count);
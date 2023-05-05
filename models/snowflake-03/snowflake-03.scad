// snowflake 3
// @author Ilya Protasov

/* TODO
? fix central figure for branch_count
? hole hanger type
*/

/* [Base] */
height = 3.2;
radius = 40;
hanger_type = "ring";// [ring, slot ,none]
// only for slot hanger type
slot_rounded = true;

/* [Extended coefficients] */
// coefficient of radius for central (main) branch thickness
central_thickness_coef = 0.125; // [0:0.001:0.300]
central_branch_start_coef = 0.25; // [0:0.001:1]

middle_branch_start_coef = 0.5; // [0:0.001:1]
middle_branch_length_coef = 0.3; // [0:0.001:1]
middle_thickness_coef = 0.100; // [0:0.001:0.300]

outer_branch_start_coef = 0.8; // [0:0.001:1]
outer_branch_length_coef = 0.2; // [0:0.001:1]
outer_thickness_coef = 0.100; // [0:0.001:0.300]

// (for ring type hanger only)
ring_inner_radius_coef = 0.065; // [0:0.001:0.300]
// difference between outer and inner radius (for ring type hanger only)
ring_thick_coef = 0.080; // [0:0.001:0.300]

slot_start_coef = 0.95; // [0:0.01:1.000]
// slot thickness coeficient from snowflake height
slot_thick_coef = 0.100; // [0:0.001:2.200]
// slot height coeficient from snowflake height
slot_height_coef = 0.300; // [0:0.001:0.500]
// change it only if slot intersects main sub branches
slot_length_coef = 1.010; // [1.010:0.001:5.000]

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

module slot(length, thick, height, rounded = true) {
    if (rounded) {
        rotate([0, 90, 0]) {
            translate([0, thick/2 - height/2, 0])
                cylinder(length, height/2, height/2, true);
            translate([0, -thick/2 + height/2, 0])
                cylinder(length, height/2, height/2, true);
        }
    }

    cube([length,
          thick - height * (rounded ? 1 : 0),
          height], true);

}

module snowflake3(branchCount) {
    angle = 360 / branchCount;
    ringInnerRadius = radius * ring_inner_radius_coef;
    ringThick = radius * ring_thick_coef;
    difference() {
        union() {
            for (i=[0:branchCount-1]) {
                rotate([0, 0, i * angle]) branchMain();
            }
        }
        if (hanger_type == "slot") {
            translate([0, radius * slot_start_coef, height/2])
                slot(radius * central_thickness_coef * slot_length_coef,
                    radius * slot_thick_coef,
                    height * slot_height_coef,
                    rounded = slot_rounded);
            }
        // hole for spinner
        //translate([0, 0, height/2])
            //for d 3.88 r=2.1
            //cylinder(h=height*2, r=2, center=true);
    }
    if (hanger_type == "ring") {
        translate([0, radius + ringInnerRadius + ringThick, height/2])
            ring(height = height,
                 outerR = ringInnerRadius + ringThick,
                 innerR = ringInnerRadius );
    }


}

//projection()
color("DeepSkyBlue") snowflake3(branch_count);

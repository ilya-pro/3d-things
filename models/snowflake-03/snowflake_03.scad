// snowflake 3
// @author Ilya Protasov

/* TODO
- ring params
- length sub branches
- refactoring coefficients
? fix central figure for branch_count
*/

/* [Base] */
height = 3;
radius = 40;
hanger_type = "ring";// [ring, none]

/* [Extended] */
// coefficient of radius for main branch thickness
main_thickness_coef = 0.125; // [0:0.001:0.300]
big_thickness_coef = 0.167; // ~ 1 / 6
small_thickness_coef = 0.101; // [0:0.001:0.300]

/* [Quality ] */
//count of segments in arcs https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#$fa,_$fs_and_$fn
$fn = 24; 

/* [Hidden]  */
branch_count = 6;

thickA = radius * big_thickness_coef;
thickMain = radius * main_thickness_coef;
thickC = radius * small_thickness_coef;

module branchMain() {
    centralAngle = 120;//360 / branch_count * 2;
    lenSub = radius*0.25;
    lenSubM = lenSub;
    deltaX = lenSub*sin(60);
    deltaY = lenSub*cos(60);
    lenBig = radius - 2*deltaY - lenSubM;
    
    //central hexagon
    translate([0, lenSub, 0]) rotate([0, 0, centralAngle]) branch2(thickMain, lenSub);
    
    //central line
    translate([0, lenSub, 0]) branch2(thickMain, radius-lenSub);
    
    //separate subbranch
    translate([0, lenBig*1, 0]) rotate([0, 0, 60]) branch2(thickC, lenSub*1.2);
    translate([0, lenBig*1, 0]) rotate([0, 0, -60]) branch2(thickC, lenSub*1.2);
    //separate subbranch
    translate([0, radius*0.8, 0]) rotate([0, 0, 60]) branch2(thickC, lenSub*.8);
    translate([0, radius*0.8, 0]) rotate([0, 0, -60]) branch2(thickC, lenSub*.8);
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
    for (i=[0:branchCount-1]) {
        rotate([0, 0, i * angle]) branchMain();
    }
    if (hanger_type == "ring") {
        translate([0, radius + thickA, height/2])
            ring(height = height, outerR = thickA, innerR = thickA/2);
    }
        
}

color("DeepSkyBlue") snowflake3(branch_count);
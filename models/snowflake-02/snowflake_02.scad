// snowflake 2
// @author Ilya Protasov

height = 3;
radius = 40;
thickA = radius/6;
thickB = radius/8;
thickC = radius/10;

//count of segments in arcs https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#$fa,_$fs_and_$fn
$fn = 18; 
//Indigo DeepSkyBlue YellowGreen DeepPink OrangeRed LawnGreen DarkSlateBlue Magenta

module box(xCount, yCount, zCount) {
    translate([halfGap, halfGap, halfGap]) cube([boundDist(xCount), boundDist(yCount), boundDist(zCount)], false);
}

module branch1() {
    lenSub = radius*0.25;
    lenSubM = lenSub;
    deltaX = lenSub*sin(60);
    deltaY = lenSub*cos(60);
    lenBig = radius - 2*deltaY - lenSubM;
    
    //big
    translate([-thickA/2, 0, 0]) cube([thickA, lenBig, height], false);
    //translate([0, radius, 0])  cylinder(height, thickA/2, thickA/2, false);
    //hexagon
    translate([0, lenBig, 0]) rotate([0, 0, 60]) branch2(thickB, lenSub);
    translate([0, lenBig, 0]) rotate([0, 0, -60]) branch2(thickB, lenSub);
    translate([deltaX, lenBig + deltaY, 0]) rotate([0, 0, 0]) branch2(thickB, lenSubM);
    translate([-deltaX, lenBig + deltaY, 0]) rotate([0, 0, 0]) branch2(thickB, lenSubM);
    translate([deltaX, radius - deltaY, 0]) rotate([0, 0, 60]) branch2(thickB, lenSubM);
    translate([-deltaX, radius - deltaY, 0]) rotate([0, 0, -60]) branch2(thickB, lenSubM);
    //separate subbranch
    translate([0, lenBig*0.6, 0]) rotate([0, 0, 60]) branch2(thickC, lenSub*.6);
    translate([0, lenBig*0.6, 0]) rotate([0, 0, -60]) branch2(thickC, lenSub*.6);
}

module branch2(thick, length) {
    translate([-thick/2, 0, 0]) cube([thick, length, height], false);
    translate([0, length, 0]) cylinder(height, thick/2, thick/2, false);
}

module ring() {
    translate([0, radius + thickA, 0])
        difference() {
            cylinder(height, thickA, thickA, false);
            cylinder(height * 2, thickA/2, thickA/2, true);
        }
}

module snowflake1(branchCount) {
    angle = 360 / branchCount;
    for (i=[0:branchCount-1]) {
        rotate([0, 0, i * angle]) branch1();
    }
    //ring();
}

color("DeepSkyBlue") snowflake1(6);
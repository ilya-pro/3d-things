// snowflake 1
// @author Ilya Protasov

height = 3;
radius = 40;
thicknessA = radius/6;
//Indigo DeepSkyBlue YellowGreen DeepPink OrangeRed LawnGreen DarkSlateBlue Magenta

//function boundDist(blockCount) = cell * blockCount - gap;

module box(xCount, yCount, zCount) {
    translate([halfGap, halfGap, halfGap]) cube([boundDist(xCount), boundDist(yCount), boundDist(zCount)], false);
}

module branch1() {
    translate([-thicknessA/2, 0, 0]) cube([thicknessA, radius, height], false);
    translate([0, radius, 0])  cylinder(height, thicknessA/2, thicknessA/2, false);
    translate([0, radius*0.4, 0]) rotate([0, 0, 60]) branch2();
    translate([0, radius*0.4, 0]) rotate([0, 0, -60]) branch2();
}

module branch2() {
    translate([-thicknessA/2, 0, 0]) cube([thicknessA, radius*0.4, height], false);
    translate([0, radius*0.4, 0]) cylinder(height, thicknessA/2, thicknessA/2, false);
}

module ring() {
    translate([0, radius + thicknessA, 0])
        difference() {
            cylinder(height, thicknessA, thicknessA, false);
            cylinder(height * 2, thicknessA/2, thicknessA/2, true);
        }
}

module snowflake1(branchCount) {
    angle = 360 / branchCount;
    for (i=[0:branchCount-1]) {
        rotate([0, 0, i * angle]) branch1();
    }
    ring();
}

color("DeepSkyBlue") snowflake1(6);
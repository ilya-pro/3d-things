// joiner
// @author Ilya Protasov

betweenCenters = 23 - 4.6;
inDiameter = 4.6;
outDiameter = 8.6;
thickness = 2;
barThickness = 2;
barWidth = 2;

$fn = 36;
//Indigo DeepSkyBlue YellowGreen DeepPink OrangeRed LawnGreen DarkSlateBlue Magenta

//function boundDist(blockCount) = cell * blockCount - gap;


module branch1() {
    translate([-thicknessA/2, 0, 0]) cube([thicknessA, radius, height], false);
    translate([0, radius, 0])  cylinder(height, thicknessA/2, thicknessA/2, false);
    translate([0, radius*0.4, 0]) rotate([0, 0, 60]) branch2();
    translate([0, radius*0.4, 0]) rotate([0, 0, -60]) branch2();
}

module clip(thickness, inD, outD, gapAngle) {
    outR = outD/2;
    inR = inD/2;
    centerR = inR + (outR - inR)/2;
    halfA = gapAngle/2;
    
    /*points = [
        [0, 0], 
        [outD * cos(90 + gapAngle/2), -outD * sin(gapAngle/2 + 90)], 
        [-outD * cos(90 +gapAngle/2), -outD * sin(gapAngle/2 + 90)]
    ];*/
    points = [
        [0, 0], 
        [outR * cos(halfA), outR * sin(halfA)], 
        [outR * cos(halfA), -outR * sin(halfA)]
    ];
    x1 = outR * sin(halfA);
    y1 = outR * cos(halfA);
    x2 = x1 * outR / y1;
    // x is changed with y because 0 angle is X-axis
    points2 = [
        [0, 0], 
        [outR, -x2], 
        [outR, x2]
    ];
    difference() {
        cylinder(thickness, outR, outR, false);
        translate([0, 0, -thickness/2]) {
            cylinder(thickness*2, inR, inR, false);
            color("Magenta") linear_extrude(5) polygon(points2);
        }
    }
    roundingR = (outR - inR) / 2;
    translate([centerR * cos(halfA), centerR * sin(halfA)]) 
        cylinder(h = thickness, r = roundingR);//, $fn = 24
    translate([centerR * cos(halfA), -centerR * sin(halfA)]) 
        cylinder(h = thickness, r = roundingR);
    //color("LawnGreen") linear_extrude(10) polygon(points);
    //color("Magenta") linear_extrude(5) polygon(points2);
}

module bar(thickness, length, width, holeD) {
    holeR = holeD / 2;
    difference() {
        translate([-width/2, 0, 0]) 
            cube([width, length, thickness], false);
        union() {
            translate([0, 0, -thickness/2])
                cylinder(h = thickness*2, r = holeR);
            translate([0, length, -thickness/2])
                cylinder(h = thickness*2, r = holeR);
        }
    }
    *translate([0, 0, -thickness/2])
        cylinder(h = thickness*2, r = holeR);
}

module joiner1() {
    //A
    clip(thickness, inDiameter, outDiameter, 90);
    //B
    translate([0, betweenCenters, 0]) 
        clip(thickness, inDiameter, outDiameter, 100);
    bar(barThickness, betweenCenters, barWidth, inDiameter);
}

joiner1();
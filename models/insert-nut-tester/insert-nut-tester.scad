// tester for insert nuts
// @author Ilya Protasov

betweenCenters = 23 - 4.6;
inDiameter = 4.6;
outDiameter = 8.6;
barThick = 2;
barWidth = 8;
barLength = 10;

$fn = 72;

module hole(inD, inH, chamferTopH = 0, chamferTopW = 0, extraTopH = 1, extraBottomH = 1) {
    inR = inD / 2;
    //rotate([0,90,0])
    //    polygon( points=[[0,0],[2,1],[1,2],[1,3],[3,4],[0,5]] );
    //angle=90 convexity=10
    rotate_extrude()
        polygon( points=[
            [0,-extraTopH],[inR, -extraTopH],
            [inR, inH - chamferTopH],
            [inR + chamferTopW, inH],
            // extraTop
            [inR + chamferTopW, inH + extraTopH],
            // end
            [0, inH + extraTopH]] );  
}

// make bar with rounded cornter without minkowski
module bar(length, width, thick, cornerRadius) {
    translate([0, cornerRadius])
        cube([length, width - cornerRadius*2, thick], false);
    translate([cornerRadius, 0])
        cube([length - cornerRadius*2, width, thick], false);
    //top right
    translate([length - cornerRadius, width - cornerRadius])
        cylinder(h = thick, r = cornerRadius);
    //bottom right
    translate([length - cornerRadius, cornerRadius])
        cylinder(h = thick, r = cornerRadius);
    //bottom left
    translate([cornerRadius, cornerRadius])
        cylinder(h = thick, r = cornerRadius);
    //top left
    translate([cornerRadius, width - cornerRadius])
        cylinder(h = thick, r = cornerRadius);
}

module barWHoles(length, width, thick, cornerRadius) {
    difference() {
        bar(length, width, thick, cornerRadius);
        translate([5, 5, 0])
            hole(4, 5.7, .4, .4, 1);
        translate([13, 5, -.4])
            hole(4, 5.7, .4, .4, 1);
        translate([20, 5, 0])
            hole(3.6, 5.7, .4, .4, 1);
        translate([27, 5, -.4])
            hole(3.2, 5.7, .4, .4, 1);
    }
    
}

//hole(4, 5.7, .4, .4, 1);

//bar(barLength, barWidth, barThick, .2);

//translate([10, 0, 0])
//    bar(barLength, barWidth, barThick, 1);

translate([0, 0, 0])
    barWHoles(33, 10, 5.7, 1);
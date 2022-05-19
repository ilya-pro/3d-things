// pipe adapter
// @author Ilya Protasov

/*
TODO
- chamfer
- Measurements visual
- minimal middle thick, based on the minimal thick A or B
- show text error for sizes
? rim
*/

/* [Base] */
// if unchecked sizes will be for inner diameter
offset_A = "out";// [in, out]
// height of part A
height_A = 10.00;// [0.2:0.01:100]
// (dA) diameter at center of height the part A
diameter_A = 22.02; // [0.2:0.01:100]
// wall thickness
thick_A = 3.00;// [0.1:0.01:50]
// negative angle for outside pipe
angle_A = 5;// [-90:0.1:90]


offset_B = "out";// [in, center, out]
height_B = 31; // [0.2:0.01:100]
// (dB)
diameter_B = 40; // [0.2:0.01:100]

thick_B = 4; // [0.1:0.01:50]
angle_B = 10;// [-90:0.1:90]

// angle for inner surface that joins A and B parts
innerAngleM = 10;// [0:0.1:89]
/* [Advanced] */

/* [Quality] */
$fn = 72;

/* [Debug] */
cutaway = false;
cut_angle = 180; // [1:1:359]
show_measures = false;
// TODO fix
show_diameters = false;

function pipePoints(thick, angle, radius, height, offset) =
    // TODO check let in Thingerverse
    let (
        thickProj = thick / cos(angle),
        // get offset for x axis
        xAOffset = offset == "in" ? 0 : - thickProj,
        // divide on 2 needs for align to center of height
        xATopOffset = tan(angle) * height / 2
        )
    [
    // anticlockwise: bottom
    [radius + xAOffset + xATopOffset, 0], 
    [radius + xAOffset + xATopOffset + thickProj, 0],
    // top
    [radius + xAOffset + thickProj - xATopOffset, height],
    [radius + xAOffset - xATopOffset, height]
    ];

module rotatedPoints(points) {
    rotateAngle = cutaway ? cut_angle : 360;
    rotate_extrude(angle = rotateAngle)
        polygon( points );
}

module measure(length, thick = 1, prefix="", postfix="") {
    coneH = 7*thick;
    // TODO needs parameter maybe, 40 just for test
    isSmall = coneH * 40 > length;
    coneA = isSmall ? 90 : -90;
    coneDelta = isSmall ? 0 : coneH;
    lengthUnderText = coneH*2;
    color("red") {
        //line
        rotate([45,0,0])
            cube([length - coneDelta*2, thick, thick], center=true);
        //left cone
        translate([-length/2, 0])
        rotate([0,coneA,0])
        translate([0,0,-coneH])
            cylinder(h=coneH, r1=3*thick, r2=0, center=false, $fn=4);
        //rigth cone
        translate([length/2, 0])
        rotate([0, -coneA, 0])
        translate([0, 0, -coneH])
            cylinder(h=coneH, r1=3*thick, r2=0, center=false, $fn=4);
        //line under text
        translate([length/2 + lengthUnderText/2 + coneH - coneDelta, 0, 0])
        rotate([45,0,0])
            cube([lengthUnderText, thick, thick], center=true);
        //text
        translate([length/2 + coneH - coneDelta + thick, thick/2, thick*2])
        rotate([90, 0, 0])
        linear_extrude(thick)
            text(str(prefix, length), size = thick*6, valign="bottom");
    }
}

module adapter(i) {
    //4/Math.cos(30*Math.PI/180)
    thickAProj = thick_A / cos(angle_A);
    //echo(thickAProj);
    //thickH = thick_A * sin(angle_A);
    //echo(thickH);
    // get offset for x axis
    xAOffset = offset_A == "in" ? 0 :
               (offset_A == "center" ? -thickAProj / 2 : -thickAProj);
    //echo(xAOffset);

    // A part
    pipePointsA = pipePoints(
        height = height_A,
        radius = diameter_A / 2,
        thick=thick_A,
        offset = offset_A,
        angle=angle_A);
    rotatedPoints(points = pipePointsA);
    if (show_diameters) {
        color("yellow", .3)
            cylinder(h = height_A, r = diameter_A / 2);
        color("yellow", .3)
        // TODO add Z offset for join pipe
            translate([0,0, -height_B])
            *cylinder(h = height_B, r = diameter_B / 2);
    }

    // B part only points (needs for Middel part
    pipePointsB = pipePoints(
        height = height_B,
        radius = diameter_B / 2,
        thick=thick_B,
        offset = offset_B,
        angle=angle_B);

    // Middle part
    // TODO minimal middle thick
    innerDeltaXAB = pipePointsB[3][0] - pipePointsA[0][0];
    //heightM = innerDeltaXAB / cos(innerAngleM);
    minThickM = min(thick_A, thick_B);
    //    minThickDeltaY = 0;//minThickM * tan(innerAngleM);//thick_A / cos(angle_A);
    //minThickDeltaX = tan(innerAngleM) / minThickM ;
    minThickDeltaX = cos(90-innerAngleM) * minThickM ;
    minThickDeltaY = minThickM * sin(90-innerAngleM);
    echo("min=", minThickM);

    heightM = abs(innerDeltaXAB) * tan(innerAngleM);
    pipePointsMiddle=[
            // anticlockwise: bottom
            [pipePointsB[3][0], 0],
            //[pipePointsB[2][0], 0],
            // minThickCorner bottom
            [pipePointsB[3][0] + minThickDeltaX, 0 + minThickDeltaY],
            // top
            //[pipePointsA[1][0], heightM],
            // minThickCorner top inner
            [pipePointsA[0][0] + minThickDeltaX, heightM + minThickDeltaY],
            [pipePointsA[0][0], heightM]];
    translate([0,0, -heightM])
    color("cyan")
        // TODO get params
        //middle(topInX=7, topOutX=10, bottomInX=14, bottomOutX=20, height=heightM);
        rotatedPoints(points = pipePointsMiddle);
        //rotatedPoints(points = pipePointsA);

    // B part here because heightM needs to be calulated
    translate([0,0, -heightM-height_B])
        rotatedPoints(points = pipePointsB);

    if (show_measures) {
        // A part
        translate([0,0,height_A/2])
            measure(length=diameter_A, thick=1, prefix="dA: ");
        // B part
        translate([0,0,-heightM-height_B/2])
            measure(length=diameter_B, thick=1, prefix="dB: ");
    }
}

adapter();

// pipe adapter
// @author Ilya Protasov

/*
TODO
Measurements visual
minimal middle thick
show text error for sizes
? rim
*/

/* [Simple] */
// if unchecked sizes will be for inner diameter
offset_A = "out";// [in, center, out]
// height of part A
height_A = 10.00;// [0.2:0.01:100]
// diameter at center of height the part A
diameter_A = 22.02; // [0.2:0.01:100]
// wall thickness
thick_A = 3.00;// [0.1:0.01:50]
// negative angle for outside pipe
angle_A = 5;// [-90:0.1:90]


offset_B = "out";// [in, center, out]
height_B = 31; // [0.2:0.01:100]
diameter_B = 40; // [0.2:0.01:100]

thick_B = 4; // [0.1:0.01:50]
angle_B = 10;// [-90:0.1:90]

// angle for inner surface that joins A and B parts
innerAngleM = 45;// [-90:0.1:89]
/* [Advanced] */

/* [Quality] */
$fn = 72;


/* [Debug] */
cutaway = false;
cut_angle = 180; // [1:1:359]
// TODO fix
show_diameters = false;
//TODO show_sizes = false;

function pipePoints(thick, angle, radius, height, offset) =
    // check let in Thingerverse
    let (
        thickProj = thick / cos(angle),
        // get offset for x axis
        xAOffset = offset == "in" ? 0 :
               (offset == "center" ? -thickProj / 2 : - thickProj),
        xATopOffset = height / 2 * sin(angle)
        )
    [
    // anticlockwise: bottom
    [radius + xAOffset + xATopOffset, 0], [radius + xAOffset + xATopOffset + thickProj, 0],
    // top
    [radius + xAOffset + thickProj - xATopOffset, height],
    [radius + xAOffset - xATopOffset, height]
    ];

module middle(topInX, topOutX, bottomInX, bottomOutX, height) {
    rotateAngle = cutaway ? cut_angle : 360;
    rotate_extrude(angle = rotateAngle)
        polygon( points=[
            // anticlockwise: bottom
            [bottomInX, 0], [bottomOutX, 0],
            // top
            [topOutX, height],
            [topInX, height]] );
}

module rotatedPoints(points) {
    rotateAngle = cutaway ? cut_angle : 360;
    rotate_extrude(angle = rotateAngle)
        polygon( points );
}

module adapter(i) {
    //4/Math.cos(30*Math.PI/180)
    thickAProj = thick_A / cos(angle_A);
    //echo(thickAProj);
    thickH = thick_A * sin(angle_A);
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
    if (show_diameters)
        color("yellow", .3)
            cylinder(h = height_A, r = diameter_A / 2);

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
    heightM = abs(innerDeltaXAB) * tan(innerAngleM);
    pipePointsMiddle=[
            // anticlockwise: bottom
            [pipePointsB[3][0], 0],
            [pipePointsB[2][0], 0],
            // top
            [pipePointsA[1][0], heightM],
            [pipePointsA[0][0], heightM]];
    translate([0,0, -heightM])
    color("forestgreen")
        // TODO get params
        //middle(topInX=7, topOutX=10, bottomInX=14, bottomOutX=20, height=heightM);
        rotatedPoints(points = pipePointsMiddle);
        //rotatedPoints(points = pipePointsA);

    // B side here because heightM needs to be calulated
    translate([0,0, -heightM-height_B])
        rotatedPoints(points = pipePointsB);
}

adapter();

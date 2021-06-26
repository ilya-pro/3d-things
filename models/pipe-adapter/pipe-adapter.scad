// pipe adapter
// @author Ilya Protasov

/*
TODO
Top, Middle, Bottom
debug mode
Measurements visual
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

thick_B = 4;
angle_B = 10;// [-90:0.1:90]

// angle for inner surface that joins A and B parts
innerAngleM = 45;// [-90:0.1:90]
/* [Advanced] */

/* [Quality] */
$fn = 72;


/* [Debug] */
cutaway = false;
show_diameters = false;
//TODO show_sizes = false;

module pipe(thick, angle, radius, height, offset) {
    //4/Math.cos(30*Math.PI/180)
    thickProj = thick / cos(angle);
    // get offset for x axis
    xAOffset = offset == "in" ? 0 :
               (offset == "center" ? -thickProj / 2 : -thickProj);
    xATopOffset = height / 2 * sin(angle);
    
    rotateAngle = cutaway ? 180 : 360;
    rotate_extrude(angle = rotateAngle)
        polygon( points=[
            // anticlockwise: bottom
            [radius + xAOffset + xATopOffset, 0], [radius + xAOffset + xATopOffset + thickProj, 0],
            // top
            [radius + xAOffset + thickProj - xATopOffset, height],
            [radius + xAOffset - xATopOffset, height]] );
    if (show_diameters)
        color("yellow", .3)       
            cylinder(h = height, r = radius);
}

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
    rotateAngle = cutaway ? 180 : 360;
    rotate_extrude(angle = rotateAngle)
        polygon( points=[
            // anticlockwise: bottom
            [bottomInX, 0], [bottomOutX, 0],
            // top
            [topOutX, height],
            [topInX, height]] );
}

module rotatedPoints(points) {
    rotateAngle = cutaway ? 180 : 360;
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
    
    //echo(xATopOffset);
    
    
    //rotate([0,90,0])
    //    polygon( points=[[0,0],[2,1],[1,2],[1,3],[3,4],[0,5]] );
    //angle=90 convexity=10
    // test triangle
    /*
    rotate([0,0,0*(90-angle_A)])//90-angle_A
        polygon( points=[
            [0, 0], [thickAProj, 0], 
            [thick_A * cos(angle_A), thickH]] );
    */
    /*
    rotateAngle = cutaway ? 180 : 360;
    rotate_extrude(angle = rotateAngle)
        polygon( points=[
            // anticlockwise: bottom
            [radiusA + xAOffset + xATopOffset, 0], [radiusA + xAOffset + xATopOffset + thickAProj, 0],
            // top
            [radiusA + xAOffset + thickAProj - xATopOffset, height_A],
            [radiusA + xAOffset - xATopOffset, height_A]] );
            
            */
    pipePointsA = pipePoints(
        height = height_A, 
        radius = diameter_A / 2,
        thick=thick_A,
        offset = offset_A,
        angle=angle_A);        
    /*pipe(
        height = height_A, 
        radius = diameter_A / 2,
        thick=thick_A,
        offset = offset_A,
        angle=angle_A
    );*/
    rotatedPoints(points = pipePointsA);
    
    // B side
    pipePointsB = pipePoints(
        height = height_B, 
        radius = diameter_B / 2,
        thick=thick_B,
        offset = offset_B,
        angle=angle_B);
    translate([0,0, -heightM-height_B])    
        rotatedPoints(points = pipePointsB);    
    // Middle
    // TODO get height
    heightM = 10;
    pipePointsMiddle=[
            // anticlockwise: bottom
            [pipePointsB[3][0], 0], 
            [pipePointsB[2][0], 0],
            // top
            [pipePointsA[1][0], heightM],
            [pipePointsA[0][0], heightM]];
    translate([0,0, -heightM])
    color("green")
        // TODO get params
        //middle(topInX=7, topOutX=10, bottomInX=14, bottomOutX=20, height=heightM);
        rotatedPoints(points = pipePointsMiddle);
        //rotatedPoints(points = pipePointsA);
    
    
    /*pipe(
        height = height_B, 
        radius = diameter_B / 2,
        thick=thick_B,
        offset = offset_B,
        angle=angle_B
    );*/
    /*color("green")
        translate([0,0])
        cube([thickAProj, height_A , 1]);*/
    
    /*
    color("yellow")
        rotate([0,0,0*-45]) {
            translate([-2,0])
                cube([2, thick_A, 1]);
            translate([0,thick_A])
                cube([thick_A, 1, 1]);
        }
    color("green")
        translate([0,-2])
        cube([thick_A, 2 , 1]);
    */
}

// thick projection


//adapterOld(4, 5.7, .4, .4, 1);
adapter();

module adapterOld(inD, inH, chamferTopH = 0, chamferTopW = 0, extraTopH = 1, extraBottomH = 1) {
    inR = inD / 2;
    //rotate([0,90,0])
    //    polygon( points=[[0,0],[2,1],[1,2],[1,3],[3,4],[0,5]] );
    //angle=90 convexity=10
    // 
    //rotate_extrude()
        polygon( points=[
            [1,-extraTopH],[inR, -extraTopH],
            [inR, inH - chamferTopH],
            [inR + chamferTopW, inH],
            // extraTop
            [inR + chamferTopW, inH + extraTopH],
            // end
            [1, inH + extraTopH]] );  
}
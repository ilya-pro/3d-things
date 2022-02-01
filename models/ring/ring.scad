// ring module
// @author Ilya Protasov

/*
TODO
- prevent incorrect chamfer size (greater than possible)
- use scale for correct ring to height and radius
- show_measures
*/


profile_type = "rect";// [ring, rect]
profile_angle = 0; // [0:.5:359]
height = 3;
innerR = 5;
outerR = 15;

// chamfer is 45 degrees only and applies for rect profile for each corner
chamfer = 1;

// if use 4 then profile will be square (4 sides)
profile_ring_segments = 5; // [3:72]

cutaway = false;
cut_angle = 180; // [1:1:359]
//show_measures = false;

/* [Expert mode] */
// ? scale

/* [Quality] */
$fn = 72;

module ring(height, outerR, innerR) {
    rotateAngle = cutaway ? cut_angle : 360;
    rotate_extrude(angle = rotateAngle) {
        translate([innerR,0]) 
            scale([1,1])     
                rotate([0, 0, profile_angle])
                    profile(profile_type);
    }
}

module profile(type) {
    if (type == "ring") {
        //translate([innerR,0])
            circle(r=10, $fn=profile_ring_segments);
    } else if  (type == "rect") {
        chamferedRect();
    }
}

module chamferedRect() {
    thick = outerR - innerR;
    // clocwise point orientation
    points = [
        // top left corner
        [0, height - chamfer], [0 + chamfer, height],
        // top right corner
        [thick - chamfer, height], [thick, height- chamfer],
        // bottom right
        [thick, 0 + chamfer],[thick - chamfer, 0],
        // bottom left
        [0 + chamfer,0], [0,0 + chamfer],
    ];
    polygon( points );
}

module rotatedPoints(points) {
    rotateAngle = cutaway ? cut_angle : 360;
    rotate_extrude(angle = rotateAngle)
        polygon( points );
}

ring(height = height, outerR = outerR, innerR = innerR);
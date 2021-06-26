// customizable laptop camera cover
// @author Ilya Protasov

/*
TODO
- front radius
- thickness radius
*/

inner_depth = 3;
inner_height = 5;
width = 10;
thick = 2; // [0.2:0.1:10]
//frontRadiusA = 2;

$fn = 72;

module profile(inDepth, inH, width, thick) {
    polygon( points=[
        // front
        [0,0], [0,inH],
        [thick, inH],
        [thick, 0-thick],
        // top outer
        [-inDepth-thick, 0-thick],
        // back outer
        [-inDepth-thick, inH],
        [-inDepth, inH],
        [-inDepth, 0]] );  
}

module cover(inDepth, inH, width, thick) {
    color("DeepSkyBlue")
    linear_extrude(width)
        profile(inDepth, inH, width, thick);
}

cover(inner_depth, inner_height, width, thick);
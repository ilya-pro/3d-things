// upgrade connectors for 3d printer Flyingbear
// @author Ilya Protasov

/* TODO
*/

/* [Base] */
base_plate = true;
joint_test = true;

base_height = 2;
base_armx_length = 40;
base_army_length = 40;

base_armx_width = 20;
base_army_width = 20;

vconector_thick = 4;
/* [Hidden]  */
base_inner_corner_radius = 20;
$fn = 48;

module cornerPlate() {
    difference() {
        translate([base_army_width, base_armx_width])
            cube([base_inner_corner_radius, base_inner_corner_radius, base_height], false);
        translate([base_army_width + base_inner_corner_radius, base_armx_width + base_inner_corner_radius,
        base_height/2]) 
            cylinder(h=base_height*2, d1=base_inner_corner_radius*2, d2=base_inner_corner_radius*2, center = true);
    }
    //armx
    cube([base_armx_length, base_armx_width, base_height], false);
    //army
    cube([base_army_width, base_army_length, base_height], false);
    
    // joiners    octo circle
    translate([20, 0, -0.005]) lockJoiner(
        type = "octo",
        isNotch = true, h=10, 
        maxLen = 7,
        minLen = 5,
        depth = 3);
    
    // axis X
    //translate([20-5, 0]) cube([10, 5, 10]);
    
    // axis Y
    translate([0, 20-5]) cube([5, 10, 10]);
}

module basePlate() {
    difference() {
        cornerPlate();
        // big
        translate([11.5, 22.5, base_height/2])
            cylinder(h=base_height*2, d1=12, d2=12, center = true);
        // open circle hole
        translate([11.5, 22.5, -base_height/2]) rotate([0,0,35]) 
            branch(20, 12, base_height*2);
        // === left bottom
        translate([11.5, 11, base_height/2])
            cylinder(h=base_height*2, d1=4, d2=4, center = true);
        // open circle hole
        translate([11.5, 11, -base_height/2]) rotate([0,0,35]) 
            branch(30, 4, base_height*2);
        // bottom right
        translate([28.5, 11, base_height/2])
            cylinder(h=base_height*2, d1=4, d2=4, center = true);
        // open circle hole
        translate([28.5, 11, -base_height/2]) rotate([0,0,35]) 
            branch(30, 4, base_height*2);
        translate([6, 31, base_height/2])
            cylinder(h=base_height*2, d1=4, d2=4, center = true);
                        
        // joiners    octo circle
        translate([20, 0, -0.005]) lockJoiner(
            type = "octo",
            isNotch = true, h=10, 
            maxLen = 7,
            minLen = 5,
            depth = 3);
        translate([0, 20, -0.005]) rotate([0,0,-90]) lockJoiner(
            type = "notch",
            isNotch = true, h=10, 
            maxLen = 7,
            minLen = 5,
            depth = 3);     
    }
}

module branch(len, width, height) {
    translate([0, -width/2, 0])
            cube([len, width, height], false);
}

function pointsNotch(isNotch, maxLen, minLen, gap, depth, depthGap) = [
        [-minLen/2 + (isNotch ? 0 : gap), -0.01], 
        [-maxLen/2 + (isNotch ? 0 : gap), depth - (isNotch ? 0 : depthGap)], 
        [maxLen/2 - (isNotch ? 0 : gap), depth - (isNotch ? 0 : depthGap)],
        [minLen/2 - (isNotch ? 0 : gap), -0.01]
    ];

function pointsCross(isNotch, maxLen, minLen, gap, depth, depthGap) = [
        [-minLen/2 + (isNotch ? 0 : gap), 0],
        [-minLen/2 + (isNotch ? 0 : gap), (maxLen-minLen)/2],
        [-maxLen/2 + (isNotch ? 0 : gap), (maxLen-minLen)/2],
        [-maxLen/2 + (isNotch ? 0 : gap), maxLen - (maxLen - minLen)/2],
        [-minLen/2 + (isNotch ? 0 : gap), maxLen - (maxLen - minLen)/2],
        [-minLen/2 + (isNotch ? 0 : gap), maxLen],
        
        [minLen/2 + (isNotch ? 0 : gap), maxLen],
        [minLen/2 + (isNotch ? 0 : gap), maxLen - (maxLen - minLen)/2],
        
        [maxLen/2 + (isNotch ? 0 : gap), maxLen - (maxLen - minLen)/2],
        [maxLen/2 + (isNotch ? 0 : gap), (maxLen-minLen)/2],
        
        [minLen/2 + (isNotch ? 0 : gap), (maxLen-minLen)/2],    
        [minLen/2 + (isNotch ? 0 : gap), 0]
    ];

module lockJoiner(type, isNotch, h, maxLen, minLen, depth) {
    gap = 0.2;
    depthGap = 0.1;

    pointsNotch = pointsNotch(isNotch, maxLen, minLen, gap, depth, depthGap); 
    
    pointsCross = pointsCross(isNotch, maxLen, minLen, gap, depth, depthGap);
    
    pointsOcto = [
        [-minLen/2 + (isNotch ? 0 : gap), 0],
        [-maxLen/2 + (isNotch ? 0 : gap), (maxLen-minLen)/2],
        [-maxLen/2 + (isNotch ? 0 : gap), maxLen - (maxLen - minLen)/2],
        [-minLen/2 + (isNotch ? 0 : gap), maxLen],
        [minLen/2 + (isNotch ? 0 : gap), maxLen],
        [maxLen/2 + (isNotch ? 0 : gap), maxLen - (maxLen - minLen)/2],
        [maxLen/2 + (isNotch ? 0 : gap), (maxLen-minLen)/2],   
        [minLen/2 + (isNotch ? 0 : gap), 0]
    ];
    // TODO offset(r=1) - фигура с отступом
    color(isNotch ? "Magenta" : "Red") 
        linear_extrude(h + (isNotch ? 0.01 : 0))
            if (type == "notch")
                polygon(pointsNotch);
            else if (type == "facetsSquare")
                //offset(delta=(maxLen-minLen)/2, chamfer = true)
                //square(minLen);
                polygon(pointsOcto);
            else if (type == "cross")
                polygon(pointsCross);
            else if (type == "circle")
                circle(r = maxLen/2);
            else if (type == "octo")
                rotate([0, 0, 45/2])
                    circle(r = maxLen/2, $fn = 8);
    if (isNotch)
        translate([0, 4, 7])
            rotate([90, 0, 0])
                cylinder(h=10, d1=2.5, d2=2.5, center = true);     
}

module testJoiner() {
    translate([20, 0])  lockJoiner(isNotch = false, h=base_height, 
               outer_length = 7,
               neck_length = 5,
               depth = 3);
    translate([0, -10]) cube([40, 10, base_height], false);
}

if (base_plate) basePlate();
if (joint_test) testJoiner();
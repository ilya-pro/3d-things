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
}

module basePlate() {
    difference() {
        cornerPlate();
        // big
        translate([12, 23.5, base_height/2])
            cylinder(h=base_height*2, d1=12, d2=12, center = true);
        //open circle hole
        translate([12, 23.5, -base_height/2]) rotate([0,0,35]) 
            branch(20, 12, base_height*2);
        // === left bottom
        translate([12, 12, base_height/2])
            cylinder(h=base_height*2, d1=4, d2=4, center = true);
        //open circle hole
        translate([12, 12, -base_height/2]) rotate([0,0,35]) 
            branch(30, 4, base_height*2);
        //bottom right
        translate([29, 12, base_height/2])
            cylinder(h=base_height*2, d1=4, d2=4, center = true);
        //open circle hole
        translate([29, 12, -base_height/2]) rotate([0,0,35]) 
            branch(30, 4, base_height*2);
        translate([6.5, 32, base_height/2])
            cylinder(h=base_height*2, d1=4, d2=4, center = true);
        translate([20, 0]) lockJoiner(isNotch = true, h=3, 
               outer_length = 7,
               neck_length = 5,
               depth = 3);
        translate([0, 20]) rotate([0,0,-90]) lockJoiner(isNotch = true, h=3, 
               outer_length = 7,
               neck_length = 5,
               depth = 3);
        
    }
    
}

module branch(len, width, height) {
    translate([0, -width/2, 0])
            cube([len, width, height], false);
}

module lockJoiner(isNotch, h, outer_length, neck_length, depth) {
    gap = 0.2;
    depthGap = 0.1;
    points2 = [
        [-neck_length/2 + (isNotch ? 0 : gap), 0], 
        [-outer_length/2 + (isNotch ? 0 : gap), depth - (isNotch ? 0 : depthGap)], 
        [outer_length/2 - (isNotch ? 0 : gap), depth - (isNotch ? 0 : depthGap)],
        [neck_length/2 - (isNotch ? 0 : gap), 0]
    ];
    color(isNotch ? "Magenta" : "Red") 
        linear_extrude(h) 
            polygon(points2);
    
}

module testJoiner() {
    translate([20, 0])  lockJoiner(isNotch = false, h=base_height, 
               outer_length = 7,
               neck_length = 5,
               depth = 3);
    translate([0, -10]) cube([40, 10, base_height], false);
}

if (base_plate) basePlate();
//if (joint_test) testJoiner();
// upgrade connectors for 3d printer Flyingbear
// @author Ilya Protasov

/* TODO
*/

/* [Base] */
base_plate = true;
show_connector_A = true;
show_connector_B = true;
show_extension_A = true;

base_height = 2;
base_armx_length = 40;
base_army_length = 40;

base_armx_width = 20;
base_army_width = 20;

gap_socket_plug = 0.2;
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
    }
}

module branch(len, width, height) {
    translate([0, -width/2, 0])
            cube([len, width, height], false);
}


module plugBar(length = 20, width = 4, d = 4) {
    color("green") {
        translate([-length/2, -width/2, 0])
        difference() {
            cube([length, width, 10]);
            translate([length/2, 0, 8]) 
                rotate([45, 0, 0])
                    cube([length+2, 1, 1], true);
            translate([length/2, 4, 8]) 
                rotate([45, 0, 0])
                    cube([length+2, 1, 1], true);
            //translate([length/2, width/2, 5]) 
            //    rotate([90, 0, 0]) 
            //        cylinder(h=width*2, d1=4, d2=4, center = true);
            translate([length - (length-d*2)/3 - d/2, width/2, 4]) 
                rotate([90, 0, 0]) 
                    cylinder(h=width*2, d1=d, d2=d, center = true);
            translate([(length-d*2)/3 + d/2, width/2, 4]) 
                rotate([90, 0, 0]) 
                    cylinder(h=width*2, d1=d, d2=d, center = true);
        }
    }
}

module socketBar(length = 20, plugW = 4, d = 4, socketW = 6) {
    
    triangle = sqrt(pow(plugW + gap_socket_plug * 2, 2) / 2); 
    color("lime") {
        translate([-length/2, -plugW/2, 0]) {
            difference() {
                cube([length, socketW, 14]);
                translate([-1, (socketW - plugW)/2 - gap_socket_plug, -1])
                    cube([length+2, plugW + gap_socket_plug * 2, 10+1]);
            
                translate([length - (length-d*2)/3 - d/2, plugW/2, 4]) 
                    rotate([90, 0, 0]) 
                        cylinder(h=socketW*2, d1=d, d2=d, center = true);
                translate([(length-d*2)/3 + d/2, plugW/2, 4]) 
                    rotate([90, 0, 0]) 
                        cylinder(h=socketW*2, d1=d, d2=d, center = true);
                // top triangle
                translate([length/2, socketW/2, 10]) 
                    rotate([45, 0, 0]) 
                        cube([length+2, triangle, triangle], true);
            }
            translate([length/2, (socketW - plugW)/2 - gap_socket_plug , 8]) 
                rotate([45, 0, 0])
                    cube([length, 1, 1], true);
            translate([length/2, socketW - (socketW - plugW)/2 + gap_socket_plug, 8]) 
                rotate([45, 0, 0])
                    cube([length, 1, 1], true);
        }
    }
}

module socket2(length = 20, plugW = 4, d = 4, socketW = 6) {
    translate([-length/2, -plugW/2, 0]) {
        translate([0, plugW/2, 10])
            cube([length, socketW, socketW/2]);
        difference() {
            translate([0, plugW*1.5, 0]) {
                cube([length, socketW/2, 14]);
            }
            translate([length - (length-d*2)/3 - d/2, plugW/2, 4]) 
                rotate([90, 0, 0]) 
                    cylinder(h=socketW*3, d1=d, d2=d, center = true);
            translate([(length-d*2)/3 + d/2, plugW/2, 4]) 
                rotate([90, 0, 0]) 
                    cylinder(h=socketW*3, d1=d, d2=d, center = true);
        }
    }
}

module connectorA() {
    translate([20, 4/2, base_height])
        plugBar(20, 4, 3);
}

module connectorB() {
    translate([4/2, 17, base_height])
        rotate([0, 0, 90])
            plugBar(20, 4, 3);
}

module extensionA() {
    translate([20, 0, base_height])
        socketBar(20, 4, 3.5, 8);
}

module extensionA2() {
    points = [
        [0, 0],
        [5, 23],
        [25, 23],
        [30, 0]
    ];
    
    holesDist = 8.4;
    holeDiam = 4;
    holeGap = 0.5;
    holeExtDiam = holeDiam + holeGap;
    
    translate([20, 0, base_height]) {
        socket2(20, 4, 3.5, 8);
        translate([10, 0, 0])
            cube([10, 8, 14]);
        //translate([0, 0, 10])
        //    cube([10, 03, 20]);
        difference() {
            translate([-10, 8, 14])
                rotate([90, 0, 0])
                    linear_extrude(8)
                        polygon(points);
            translate([5 - holesDist/2, 0, 30])
                rotate([90, 0, 0])
                    cylinder(h=30, d1=holeExtDiam, d2=holeExtDiam, center = true);
            // TODO check D and interval
            translate([5 + holesDist/2, 0, 30])
                rotate([90, 0, 0])
                    cylinder(h=30, d1=holeExtDiam, d2=holeExtDiam, center = true);
        }
        // debug
        translate([-5, 8, 30 - 30/2])
            %cube([22, 19, 30]);
    }
}

// connector A
// extension A
// 

if (base_plate) basePlate();
if (show_connector_A) connectorA();
if (show_connector_B) connectorB();
//if (show_extension_A) extensionA();
if (show_extension_A) extensionA2();
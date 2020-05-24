// rack box depth stopper
// @author Ilya Protasov

/* [Base] */
full_depth = 21;
width = 12;
height = 12;
damping_pad_thickness = 2.5;
lock_thickness = 2.8; //0.4 * 7
lock_height = 8;


/* [Hidden]  */
depth_without_pad = full_depth - damping_pad_thickness;


module stopper() {
    // item lay on the side
    cube([depth_without_pad, height, width], false);
    // lock
    color("green") 
        translate([0, -lock_height, 0])
            cube([lock_thickness, lock_height, width], false);
    
    // show pad for debug only
    translate([depth_without_pad, 0, 0]) 
        %cube([damping_pad_thickness, height, width], false);
}

stopper();
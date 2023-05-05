// spinner frame
// @author Ilya Protasov

/* TODO

*/

/* [Base] */
//height = 3.2;
rotor_radius = 28;
frame_radius_gap = 2;
frame_thick = 10;
frame_outH = 52;
frame_topH = 8;
frame_bottomH = 8;
// extra space left from rotate axis
frame_leftW = frame_thick/2 + 1;

frame_sideW = 16;
bevel_inner_radius = 1;
bevel_outer_radius = 1;
bevel = bevel_inner_radius + bevel_outer_radius;

thick = 2; // [0.2:0.1:10]

/* [Quality ] */
//count of segments in arcs https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#$fa,_$fs_and_$fn
$fn = 24; 

/* [Hidden]  */
branch_count = 6;

//thickMain = radius * central_thickness_coef;

inner_depth = 30;
inner_height = 50;
width = 10;


// Round-Anything-1.0.4
// https://github.com/Irev-Dev/Round-Anything
include <polyround.scad>
use <JetBrainsMono-Medium.ttf>


module profile() {
    // clocwise direction
    polygon( points=[
        // top
        [0,0], 
        [frame_leftW + rotor_radius + frame_radius_gap + frame_sideW, 0],
        // side
        [frame_leftW + rotor_radius + frame_radius_gap + frame_sideW, -frame_outH],
        // bottom
        [0,-frame_outH],
        [0,-frame_outH +frame_bottomH],
        [frame_leftW + rotor_radius + frame_radius_gap, -frame_outH +frame_bottomH],
        // side inner
        [frame_leftW + rotor_radius + frame_radius_gap, -frame_topH],
        //top inner
        [0, -frame_topH]] );  
}

module profileTop() {
    square([frame_leftW+rotor_radius+frame_radius_gap+frame_leftW-bevel*2, 
            frame_topH- bevel*2],center=false);
}

module profileBottom() {
    square([frame_leftW+rotor_radius+frame_radius_gap+frame_leftW-bevel*2, 
            frame_bottomH- bevel*2],center=false);
}

module profileSide() {
    square([frame_sideW - bevel*2, frame_outH-bevel*2],center=false);
}

module frameTop() {
    
    hull() {
       //inner
    linear_extrude(frame_thick)
        offset(r = bevel_inner_radius) {
      //square(30, center = true);
            profileTop();
            //profile(inner_depth, inner_height, width, thick);
     }
    translate([0, 0, bevel/2])
     linear_extrude(frame_thick - bevel)
        offset(r = bevel) 
            //profile(inner_depth, inner_height, width, thick);
            profileTop();
     
     }
}

module frameBottom() {
    hull() {
       //inner
    linear_extrude(frame_thick)
        offset(r = bevel_inner_radius) {
            profileBottom();
     }
    translate([0, 0, bevel/2])
     linear_extrude(frame_thick - bevel)
        offset(r = bevel) 
            profileBottom();
     
     }
}

module frameSide() {
    hull() {
       //inner
    linear_extrude(frame_thick)
        offset(r = bevel_inner_radius) {
            profileSide();
     }
    translate([0, 0, bevel/2])
     linear_extrude(frame_thick - bevel)
        offset(r = bevel) 
            profileSide();
     
     }
}

module frame() {
    *color("DeepSkyBlue", .5)
    translate([0, 0, -frame_thick/2])
        linear_extrude(frame_thick)
            profile();
    difference() {
        union() {
             // top
           translate([bevel, -frame_topH+bevel, -frame_thick/2])
                frameTop();
           // bottom
           translate([bevel, -frame_outH+bevel, -frame_thick/2])
                frameBottom();  
           //side
           translate([frame_leftW+rotor_radius+frame_radius_gap+bevel, -frame_outH+bevel, -frame_thick/2])
                frameSide();     
            }
        // bolt    
        translate([frame_leftW, 1, 0])
            rotate([90,30,0]) {
                cylinder(r=1.5+0.2,h=frame_outH + 2);
                //гайка
                cylinder(r=3+0.4,h=5.5, $fn=6);
                //шляпка
                translate([0, 0, frame_outH-2.25])
                    cylinder(h=2.4, r1=1.5+.2, r2=3+.3);
                translate([0, 0, frame_outH+.1])
                    cylinder(h=1, r=3+.3);
            }
        // text
        //C:/distrib/FreeCAD/FreeCAD_0.19.20310-Win-Conda_vc14.x-x86_64/FontsMy/JetBrainsMono-Medium.ttf
        translate([frame_leftW+rotor_radius+frame_radius_gap + frame_sideW/2 + 2, 
               -frame_outH+frame_bottomH-bevel+.5, 
                frame_thick/2 - 0.6])
        rotate([0,0,90])
            linear_extrude(2)
                text("ilya-pro", size = 5, halign="left", font="JetBrains Mono:style=Medium");
        
            
    }
    //bolt
    *translate([frame_leftW, 0, 0])
        rotate([90,0,0])
            cylinder(r=1.4,h=frame_outH);
    *translate([frame_leftW+rotor_radius+frame_radius_gap + frame_sideW/2 + 2, 
               -frame_outH+frame_bottomH-bevel+.5, frame_thick/2 - 1])
        rotate([0,0,90])
            linear_extrude(2)
                text("ilya-pro", size = 5, halign="left", font="JetBrains Mono:style=Medium");
    
}

module snowflake(branchCount) {
    import("snow-03.12-spinR25h5.8.stl");
}

//projection()
color("DeepSkyBlue")
    rotate([90,30,0])
        snowflake();

!color("Tomato")
    translate([-frame_leftW, 20, 0])
        frame();
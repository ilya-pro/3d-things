// chain
// @author Ilya Protasov

/*
TODO
- rounded path
- chain loop
*/

/* [Chain link] */
//sizes length and width without link thick (outer width will be more with thick)
link_length = 60;
link_width = 40;
link_thick = 4;
link_height = 2;
gap_align = "start";// [start, center]
gap_width = 14;
gap_start = 10;

/* [Chain] */
//link_count = 1;

/* [Quality ] */
//count of segments in arcs https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#$fa,_$fs_and_$fn
$fn = 24;

module chainLink2d() {
    circle(d=link_thick);
    translate([link_width, 0])
        circle(d=link_thick);
    translate([link_width, link_length])
        circle(d=link_thick);
    translate([0, link_length])
        circle(d=link_thick);
    // borders
    // bottom
    translate([0, -link_thick / 2])
        square([link_width, link_thick]);
    // top
    translate([0, link_length - link_thick / 2])
        square([link_width, link_thick]);
    // left
    translate([-link_thick / 2, 0])
        square([link_thick, link_length]);
    // === gaped border
    gapStart = (gap_align == "start") ? gap_start :
        (link_length - gap_width) / 2;
    afterGap = link_length - gap_width - gapStart;

    // before gap
    translate([link_width - link_thick / 2, 0])
        square([link_thick, gapStart]);

    translate([link_width, gapStart])
        circle(d=link_thick);
    // after gap
    translate([link_width - link_thick / 2, link_length - afterGap])
        square([link_thick, afterGap]);
    translate([link_width, link_length - afterGap])
        circle(d=link_thick);
    //polygon(pointsNotch);
}

module chainLink() {
    linear_extrude(link_height)
        chainLink2d();
}

//%color("Magenta") square([link_width, link_length]);
//projection()
chainLink();

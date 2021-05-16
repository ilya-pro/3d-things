// pipe adapter
// @author Ilya Protasov

/*
TODO
Top, Middle, Bottom
debug mode
Measurements visual
*/

betweenCenters = 23 - 4.6;
inDiameter = 4.6;
outDiameter = 8.6;
barThick = 2;
barWidth = 8;
barLength = 10;

$fn = 72;

module hole(inD, inH, chamferTopH = 0, chamferTopW = 0, extraTopH = 1, extraBottomH = 1) {
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

hole(4, 5.7, .4, .4, 1);
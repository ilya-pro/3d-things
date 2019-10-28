// ring module
// @author Ilya Protasov

height = 3;
outerR = 5;
innerR = 4.8;

$fn = 36;

module ring(height, outerR, innerR) {
    difference() {
        cylinder(height, outerR, outerR, true);
        cylinder(height * 2, innerR, innerR, true);
    }
}

ring(height = height, outerR = outerR, innerR = innerR);
import java.util.Arrays;
/// You do not need to change anything in this file, but you can
/// For example, if you want to add additional options controllable by keys
/// keyPressed would be the place for that.

ArrayList<PVector> waypoints = new ArrayList<PVector>();
int lastt;
Map map;

void setup() {
    size(800, 800);
    map = new Map();
}

void draw() {
    background(255);
    map.draw();
}

void keyPressed() {
    if (key == 'g') {
        map.generate(); // Generate a new maze when 'g' is pressed
    }
}

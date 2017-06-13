public class Shape {
  public static final int CIRCLE = 1;
  public static final int SQUARE = 2;
  public static final int TRIANGLE = 3;
  public static final int STAR = 4;
  
  int type;
  int size;
  ArrayList<PVector> vertices = new ArrayList<PVector>();
  
  public Shape(int type) {
    this.type = type;
    this.size = 10;
    init();
  }
  
  private void init() {
    switch (this.type) {
      case CIRCLE: 
        generateCircle();
        break;
      case SQUARE:
        generateSquare();
        break;
      case TRIANGLE:
        generateTriangle();
        break;
      case STAR:
        generateStar();
        break;
    }
  }
  
  private void generateCircle() {
    // Create a circle using vectors pointing from center
    for (int angle = 0; angle < 360; angle += 9) {
      // Note we are not starting from 0 in order to match the
      // path of a circle.  
      PVector v = PVector.fromAngle(radians(angle-135));
      v.mult(size);
      vertices.add(v);
    }
  }
  
  private void generateSquare() {
    // A square is a bunch of vertices along straight lines
    // Top of square
    for (int x = -size; x < size; x += 1) {
      vertices.add(new PVector(x, -size));
    }
    // Right side
    for (int y = -size; y < size; y += 1) {
      vertices.add(new PVector(size, y));
    }
    // Bottom
    for (int x = size; x > -size; x -= 1) {
      vertices.add(new PVector(x, size));
    }
    // Left side
    for (int y = size; y > -size; y -= 1) {
      vertices.add(new PVector(-size, y));
    }
  }
  
  private void generateTriangle() {
    
  }
  
  private void generateStar() {
    
  }
  
  public ArrayList<PVector> getVertices() {
    return this.vertices;
  }
}
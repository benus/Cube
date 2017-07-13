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
    this.size = 20;
    init2();
  }
  
  private void init2() {
    boolean isPolygon = random(1)>0.5;
    int edgeNum = type + 2;
    if(isPolygon) {
      polygon(edgeNum,0,0,size,size,-PI/2f);
    }
    else {
      star(edgeNum,0,0,size,size,-PI/2f,0.4f);
    }
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
  
  void polygon(int n,float cx,float cy,float w,float h,float startAngle) {
    float angle = 2*PI/n;
    w = w/2f;
    h = h/2f;
    
    for(int i=0;i<n;i++) {
      vertices.add(new PVector(cx + w * cos(startAngle + angle * i), cy + h * sin(startAngle + angle * i)));
    }
  }
    
  void star(int n,float cx,float cy,float w,float h,float startAngle,float proportion) {
    float angle = PI/n;   //2*PI/n/2
    w = w/2f;
    h = h/2f;
    float nw,nh;
      
    for(int i=0;i<n*2;i++) {
      nw = w;
      nh = h;
      if(i%2 == 1) {
        nw = w * proportion;
        nh = h * proportion;
      }
      vertices.add(new PVector(cx + nw * cos(startAngle + angle * i), cy + nh * sin(startAngle + angle * i)));
    }
  }
  
  public ArrayList<PVector> getVertices() {
    return this.vertices;
  }
}
static final int interiorWeight = 2;
static final int middleWeight = 8;
static final int exteriorWeight = 16;
static final int interiorAlpha = 255;
static final int middleAlpha = 32;
static final int exteriorAlpha = 4;
public class Widget implements Visible {
  public static final int TYPE_GAME_CELL = 1;
  public static final int TYPE_MENU = 2;
  public static final int TYPE_MENU_ITEM =3;
  
  String name,value;
  PVector position,size;
  Panel panel;
  int type,shapeType;
  ArrayList<PVector> vertices;
  String words;
  PFont font;
  boolean showBorder;
  color frontColor = color(125);
  boolean isDisabled;
  boolean isSparkingLine = true;
  
  public Widget(String name,PVector position,PVector size) {
    this.name = name;
    this.position = position;
    this.size = size;
  }
  
  public void attachToPanel(Panel panel) {
    this.panel = panel;
    panel.addVisibleObject(this);
  }
  
  public void asShape(int shapeType) {
    this.shapeType = shapeType;
    Shape shape = new Shape(shapeType);
    vertices = shape.getVertices();
  }
  
  public void disable() {
    this.isDisabled = true;
  }
  
  public void enable() {
    this.isDisabled = false;
  }
  
  public void transformTo(int shapeType) {
    
  }
  
  public void asFont(String words) {
    font = createFont("Georgia",16);
    this.words = words;
  }
  
  //ISSUE: The alpha of conjunction of lines will be added. It does not make shape good as my expectation
  void drawSparkingLines() {
    for(int i=0;i<vertices.size();i++) {
         drawSparkingLine(vertices.get(i),vertices.get((i + 1) % vertices.size()));
    }
  }
  
  void drawSparkingLine(PVector from,PVector to) {
    drawLine(from,to,frontColor,exteriorWeight,exteriorAlpha);
    drawLine(from,to,frontColor,middleWeight,middleAlpha);
    drawLine(from,to,frontColor,interiorWeight,interiorAlpha);
  }
  
  void drawLine(PVector from,PVector to,int lineColor,float weight,float alpha) {
    panel.pg.strokeWeight(weight);
    panel.pg.stroke(lineColor,alpha);
    panel.pg.line(from.x,from.y,to.x,to.y);
  }
  
  void drawVertices() {
    panel.pg.beginShape();
    for(PVector vertex : vertices) {
      panel.pg.vertex(vertex.x,vertex.y);
    }
    panel.pg.endShape(CLOSE);
  }
  
  public void draw(int elapsedMills) {
    if(panel != null) {
      panel.pg.pushMatrix();
      panel.pg.translate(position.x,position.y);
      panel.pg.stroke(frontColor);
      panel.pg.strokeWeight(2);
      panel.pg.noFill();
      if(vertices != null && !vertices.isEmpty()) {
        if(isSparkingLine) {
          drawSparkingLines();
        }
        else {
          drawVertices();
        }
      }
      else if(words != null) {
        panel.pg.textFont(font);
        panel.pg.textAlign(CENTER, CENTER);
        panel.pg.text(words,0,0);
      }
      if(showBorder) {
        panel.pg.noFill();
        panel.pg.stroke(255,0,0,125);
        panel.pg.rect(0,0,size.x,size.y);
      }
      panel.pg.popMatrix();
    }
  }
  
  public void toggleBorder() {
    showBorder = !showBorder;
  }
}
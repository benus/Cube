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
  boolean showBorder;
  color frontColor = color(125);
  boolean isDisabled;
  
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
    PFont font = createFont("Georgia",16);
    textFont(font);
    textAlign(CENTER, CENTER);
    this.words = words;
  }
  
  public void draw(int elapsedMills) {
    if(panel != null) {
      panel.pg.pushMatrix();
      panel.pg.translate(position.x,position.y);
      panel.pg.fill(frontColor,125);
      panel.pg.noStroke();
      if(vertices != null && !vertices.isEmpty()) {
        panel.pg.beginShape();
        for(PVector vertex : vertices) {
          panel.pg.vertex(vertex.x,vertex.y);
        }
        panel.pg.endShape();
      }
      else if(words != null) {
        text(words,0,0);
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
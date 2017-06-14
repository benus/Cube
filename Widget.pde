public class Widget implements Visible {
  String name;
  PVector position,size;
  Panel panel;
  ArrayList<PVector> vertices;
  String words;
  
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
    Shape shape = new Shape(shapeType);
    vertices = shape.getVertices();
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
      panel.pg.fill(125,125);
      panel.pg.translate(position.x,position.y);
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
      panel.pg.popMatrix();
    }
  }
}
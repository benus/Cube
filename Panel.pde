public class Panel implements Visible{
  String name;
  PVector size;
  PGraphics pg;
  ArrayList<Visible> visibleObjects = new ArrayList<Visible>();
  
  public Panel(String name,PVector size) {
    this.name = name;
    this.size = size;
    pg = createGraphics(int(size.x), int(size.y), P2D);
    pg.rectMode(CENTER);
    pg.ellipseMode(RADIUS);
  }
  
  public Panel(String name) {
    this(name,DEFAULT_PANEL_SIZE);
  }
  
  public void addVisibleObject(Visible visible) {
    visibleObjects.add(visible);
  }
  
  public void draw(int elapsedMills) {
    rect(0,0,size.x,size.y);//border of panel
    pg.beginDraw();
    pg.background(255);
    for(Visible visible : visibleObjects) {
      visible.draw(elapsedMills);
    }
    pg.endDraw();
    image(pg,0,0,size.x,size.y);
  }
}
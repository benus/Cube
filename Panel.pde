public class Panel implements Visible{
  public static final String NAME_OF_WELCOME_PANEL="GameNamePanel";
  public static final String NAME_OF_DEMO_PANEL="GameDemoPanel";
  public static final String NAME_OF_MAIN_PANEL="SelfGamePanel";
  public static final String NAME_OF_REMOTE_PANEL_1="RemoteGamePanel1";
  public static final String NAME_OF_REMOTE_PANEL_2="RemoteGamePanel2";
  public static final String NAME_OF_REMOTE_PANEL_3="RemoteGamePanel3";
  public static final String NAME_OF_REMOTE_PANEL_4="RemoteGamePanel4";
  
  String name;
  PVector size;
  PGraphics pg;
  color backgroundColor;
  ArrayList<Visible> visibleObjects = new ArrayList<Visible>();
  
  public Panel(String name,PVector size) {
    this.name = name;
    this.size = size;
    pg = createGraphics(int(size.x), int(size.y), P2D);
    pg.rectMode(CENTER);//seems this command is not working in processing, but is working in processing.js
    pg.ellipseMode(RADIUS);
  }
  
  public Panel(String name) {
    this(name,DEFAULT_PANEL_SIZE);
  }
  
  public void addVisibleObject(Visible visible) {
    visibleObjects.add(visible);
  }
  
  public void draw(int elapsedMills) {
    //rect(0,0,size.x,size.y);//border of panel
    pg.beginDraw();
    pg.background(backgroundColor);
    for(Visible visible : visibleObjects) {
      visible.draw(elapsedMills);
    }
    pg.endDraw();
    //image(pg.get(),-size.x/2,-size.y/2,size.x,size.y);//processingjs does not support imageMode(center) in P3D
    image(pg.get(),0,0,size.x,size.y);
;  }
}
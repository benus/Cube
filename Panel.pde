public class Panel implements Visible{
  String name;
  PVector size;
  
  public Panel(String name,PVector size) {
    this.name = name;
    this.size = size;
  }
  
  public Panel(String name) {
    this(name,DEFAULT_PANEL_SIZE);
  }
  
  public void draw(int elapsedMills) {
    noStroke();
    rect(0,0,size.x,size.y);
  }
}
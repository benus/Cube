public class Menu extends Widget  {
  public static final int LAYOUT_SQUARE = 1;
  public static final int LAYOUT_BAR = 2;
  private int layout;
  private ArrayList<Widget> menuItems = new ArrayList<Widget>(4);//TODO: Widget for static or Animation for dynamic?
  private ArrayList<Integer> availbeColors = new ArrayList<Integer>(4); //color
  private boolean showing;
  
  public Menu(String name,PVector position,PVector size) {
    super(name,position,size);
  }
  
  public void init(int layout,PVector itemSize) {
    this.layout = layout;
    if(LAYOUT_SQUARE ==  layout) {
      Widget topItem = new Widget("TopItem",new PVector(0,-itemSize.y),itemSize);
      Widget bottomItem = new Widget("BottomItem",new PVector(0,itemSize.y),itemSize);
      Widget leftItem = new Widget("LeftItem",new PVector(-itemSize.x,0),itemSize);
      Widget rightItem = new Widget("RightItem",new PVector(itemSize.x,0),itemSize);
      if(panel != null) {
        topItem.panel = panel;
        bottomItem.panel = panel;
        leftItem.panel = panel;
        rightItem.panel = panel;
      }
      menuItems.add(topItem);
      menuItems.add(bottomItem);
      menuItems.add(leftItem);
      menuItems.add(rightItem);
    }
    else if(LAYOUT_BAR == layout) {
      
    }  
  }
  
  public void addAvailableColor(color colorCode) {
    availbeColors.add(colorCode);
  }
  
  public void setShape(int shapeType) {
    Integer frontColor = null;
    Widget item = null;
    for(int i=0;i<menuItems.size();i++) {
      frontColor = availbeColors.get(i);
      item = menuItems.get(i);
      item.frontColor = frontColor != null?frontColor:GREY;
      item.asShape(shapeType);
      if(item.frontColor ==  GREY) {
        item.disable();
      }
      else {
        item.enable();
      }
    }
  }
  
  public void show(PVector position) {
    this.position = position;
    showing = true;
  }
  
  public void disappear() {
    showing = false;
    availbeColors.clear();
  }
  
  public void draw(int elapsedMills) {
    if(panel != null && showing) {
      panel.pg.pushMatrix();
      panel.pg.translate(position.x,position.y);
      for(Widget item: menuItems) {
        item.draw(elapsedMills);
      }
      panel.pg.popMatrix();
    }
  }
}
public class Menu extends Widget  {
  public static final int LAYOUT_SQUARE = 1;
  public static final int LAYOUT_BAR = 2;
  private int layout;
  private ArrayList<Widget> menuItems = new ArrayList<Widget>(4);//TODO: Widget for static or Animation for dynamic?
  private ArrayList<Integer> availbeValues = new ArrayList<Integer>(4); //color
  private boolean showing;
  
  public Menu(String name,PVector position,PVector size) {
    super(name,position,size);
    this.type = Widget.TYPE_MENU;
  }
  
  public void init(int layout,PVector itemSize) {
    this.layout = layout;
    if(LAYOUT_SQUARE ==  layout) {
      Widget topItem = new Widget("TopItem",new PVector(0,-itemSize.y),itemSize);
      Widget bottomItem = new Widget("BottomItem",new PVector(0,itemSize.y),itemSize);
      Widget leftItem = new Widget("LeftItem",new PVector(-itemSize.x,0),itemSize);
      Widget rightItem = new Widget("RightItem",new PVector(itemSize.x,0),itemSize);
      menuItems.add(topItem);
      menuItems.add(bottomItem);
      menuItems.add(leftItem);
      menuItems.add(rightItem);
      for(Widget item : menuItems) {
        item.panel = panel;
        item.type = Widget.TYPE_MENU_ITEM;
      }
    }
    else if(LAYOUT_BAR == layout) {
      
    }  
  }
  
  public ArrayList<Widget> getItems() {
    return menuItems;
  }
  
  public void addAvailableValue(int value) {
    availbeValues.add(value);
  }
  
  public void setShape(int shapeType) {
    Widget item = null;
    Integer value = -1;
    for(int i=0;i<menuItems.size();i++) {
      item = menuItems.get(i);
      value = availbeValues.get(i);
      item.value = (value != null?value + "":null);
      item.frontColor = (value != null?colors[value]:GREY);
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
    availbeValues.clear();
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
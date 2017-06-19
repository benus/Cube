public class Layout {
  public static final int LAYOUT_FULL_SCREEN = 1;
  public static final int LAYOUT_TWO_PANELS_PORTRAIT = 2;
  public static final int LAYOUT_THREE_PANELS_PORTRAIT = 3;
  public static final int LAYOUT_TWO_PANELS_LANDSCAPE = 4;
  public static final int LAYOUT_THREE_PANELS_LANDSCAPE = 5;
  public static final int LAYOUT_ALL_PANELS = 6;
    
  public static final int LOCATION_CENTER = 1;
  public static final int LOCATION_TOP = 2;
  public static final int LOCATION_BOTTOM = 3;
  public static final int LOCATION_LEFT = 4;
  public static final int LOCATION_RIGHT = 5;

  private int type;
  //detail defines the accurate postion and apperance of visible objects in the specific location
  private HashMap<Integer,Frame> detail = new HashMap<Integer,Frame>();//<Location,Frame>
  
  public Layout(int type) {
    this.type = type;
    LayoutHelper helper = new LayoutHelper(SIZE);
    helper.setLayoutType(type);
    helper.setPanelSize(DEFAULT_PANEL_SIZE.copy());
    helper.setMargin(MARGIN);
    switch (type) {
      case LAYOUT_FULL_SCREEN:
            detail.put(LOCATION_CENTER,new Frame(CENTER_POSITION));                  
            break;
      case LAYOUT_TWO_PANELS_PORTRAIT:
            detail.put(LOCATION_TOP,new Frame(new PVector(VERTICAL_GOLD_POSITION.x,VERTICAL_GOLD_POSITION.y - helper.getVerticalPanelYOffset()),new PVector(acos(helper.getVerticalPanelHeight()/DEFAULT_PANEL_SIZE.y),0,0),new PVector(0,DEFAULT_PANEL_SIZE.y/2,0)));
            detail.put(LOCATION_BOTTOM,new Frame(VERTICAL_GOLD_POSITION));
            break;   
      case LAYOUT_TWO_PANELS_LANDSCAPE:
            detail.put(LOCATION_LEFT,new Frame(new PVector(HORIZONTAL_GOLD_POSITION.x - helper.getHorizontalPanelXOffset(),HORIZONTAL_GOLD_POSITION.y),new PVector(0,-acos(helper.getHorizontalPanelWidth()/DEFAULT_PANEL_SIZE.x),0),new PVector(DEFAULT_PANEL_SIZE.x/2,0,0)));
            detail.put(LOCATION_RIGHT,new Frame(HORIZONTAL_GOLD_POSITION));
            break;  
      case LAYOUT_THREE_PANELS_PORTRAIT:
            detail.put(LOCATION_CENTER,new Frame(CENTER_POSITION));   
            detail.put(LOCATION_TOP,new Frame(new PVector(CENTER_POSITION.x,CENTER_POSITION.y - helper.getVerticalPanelYOffset()),new PVector(acos(helper.getVerticalPanelHeight()/DEFAULT_PANEL_SIZE.y),0,0),new PVector(0,DEFAULT_PANEL_SIZE.y/2,0)));
            detail.put(LOCATION_BOTTOM,new Frame(new PVector(CENTER_POSITION.x,CENTER_POSITION.y + helper.getVerticalPanelYOffset()),new PVector(-acos(helper.getVerticalPanelHeight()/DEFAULT_PANEL_SIZE.y),0,0),new PVector(0,-DEFAULT_PANEL_SIZE.y/2,0)));
            break;   
      case LAYOUT_THREE_PANELS_LANDSCAPE:
            detail.put(LOCATION_CENTER,new Frame(CENTER_POSITION));
            detail.put(LOCATION_LEFT,new Frame(new PVector(CENTER_POSITION.x - helper.getHorizontalPanelXOffset(),CENTER_POSITION.y),new PVector(0,-acos(helper.getHorizontalPanelWidth()/DEFAULT_PANEL_SIZE.x),0),new PVector(DEFAULT_PANEL_SIZE.x/2,0,0)));
            detail.put(LOCATION_RIGHT,new Frame(new PVector(CENTER_POSITION.x + helper.getHorizontalPanelXOffset(),CENTER_POSITION.y),new PVector(0,acos(helper.getHorizontalPanelWidth()/DEFAULT_PANEL_SIZE.x),0),new PVector(-DEFAULT_PANEL_SIZE.x/2,0,0)));
            break;  
      case LAYOUT_ALL_PANELS:
            float scalar = 0.5;
            helper.setScalar(scalar);
            detail.put(LOCATION_CENTER,new Frame(CENTER_POSITION,scalar));
            detail.put(LOCATION_LEFT,new Frame(new PVector(CENTER_POSITION.x - helper.getHorizontalPanelXOffset(),CENTER_POSITION.y),new PVector(0,acos(helper.getHorizontalPanelWidth()/DEFAULT_PANEL_SIZE.x),0),new PVector(DEFAULT_PANEL_SIZE.x/2,0,0),scalar));
            detail.put(LOCATION_RIGHT,new Frame(new PVector(CENTER_POSITION.x + helper.getHorizontalPanelXOffset(),CENTER_POSITION.y),new PVector(0,-acos(helper.getHorizontalPanelWidth()/DEFAULT_PANEL_SIZE.x),0),new PVector(-DEFAULT_PANEL_SIZE.x/2,0,0),scalar));
            detail.put(LOCATION_TOP,new Frame(new PVector(CENTER_POSITION.x,CENTER_POSITION.y - helper.getVerticalPanelYOffset()),new PVector(-acos(helper.getVerticalPanelHeight()/DEFAULT_PANEL_SIZE.y),0,0),new PVector(0,DEFAULT_PANEL_SIZE.y/2,0),scalar));
            detail.put(LOCATION_BOTTOM,new Frame(new PVector(CENTER_POSITION.x,CENTER_POSITION.y + helper.getVerticalPanelYOffset()),new PVector(acos(helper.getVerticalPanelHeight()/DEFAULT_PANEL_SIZE.y),0,0),new PVector(0,-DEFAULT_PANEL_SIZE.y/2,0),scalar));
            break; 
    }
  }
  
  public Integer getLayoutType() {
    return this.type;
  }


}
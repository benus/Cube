public class Layout {
  public static final int LAYOUT_FULL_SCREEN = 1;
  public static final int LAYOUT_TWO_PANELS_LANDSCAPE = 2;
  public static final int LAYOUT_TWO_PANELS_PORTRAIT = 3;
  public static final int LAYOUT_ALL_PANELS = 4;
    
  public static final int LOCATION_CENTER = 1;
  public static final int LOCATION_TOP = 2;
  public static final int LOCATION_BOTTOM = 3;
  public static final int LOCATION_LEFT = 4;
  public static final int LOCATION_RIGHT = 5;

  private int type;
  //detail defines the accurate postion and apperance of visible objects in the specific location
  private Map<Integer,Frame> detail = new HashMap<Integer,Frame>();//<Location,Frame>
  
  public Layout(int type) {
    this.type = type;
    switch (type) {
      case LAYOUT_FULL_SCREEN:
            detail.put(LOCATION_CENTER,new Frame(new PVector(SIZE.x/2,SIZE.y/2),new PVector(),1,255));                  
            break;
      case LAYOUT_TWO_PANELS_LANDSCAPE:
            detail.put(LOCATION_LEFT,new Frame(new PVector(SIZE.x/3/2,SIZE.y/2),new PVector(),0.5,255));
            detail.put(LOCATION_RIGHT,new Frame(new PVector(SIZE.x/3*2,SIZE.y/2),new PVector(),1,255));
            break;
      case LAYOUT_TWO_PANELS_PORTRAIT:
            detail.put(LOCATION_TOP,new Frame(new PVector(SIZE.x/2,SIZE.y/3),new PVector(PI/3,0,0),1,255));
            detail.put(LOCATION_BOTTOM,new Frame(new PVector(SIZE.x/2,SIZE.y/3*2),new PVector(),1,255));
            break;      
      case LAYOUT_ALL_PANELS:
            detail.put(LOCATION_CENTER,new Frame(new PVector(SIZE.x/2,SIZE.y/2),new PVector(),1,255));  
            detail.put(LOCATION_LEFT,new Frame(new PVector(SIZE.x/8,SIZE.y/2),new PVector(0,PI/3,0),0.7,255));
            detail.put(LOCATION_RIGHT,new Frame(new PVector(SIZE.x/8*7,SIZE.y/2),new PVector(),0.5,255));
            detail.put(LOCATION_TOP,new Frame(new PVector(SIZE.x/2,SIZE.y/4),new PVector(),0.5,255));
            detail.put(LOCATION_BOTTOM,new Frame(new PVector(SIZE.x/2,SIZE.y/4*3),new PVector(),0.5,255));
            break;        
    }
  }
  
  public Integer getLayoutType() {
    return this.type;
  }
  
  
  

}
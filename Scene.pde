/**
** Scene is a composition of panels of the loations are defined by layout
**
**/
public class Scene {
  public static final int TYPE_WELCOME = 1;
  //public static final int TYPE_DEMO = 2;
  public static final int TYPE_MAIN = 2;
  public static final int TYPE_END = 3;
  
  int type;
  boolean finished;
  int during;
  Integer lifeMills; //refers to mills of this scene will stay without enterruptted by outside
  Layout currentLayout,nextLayout;
  private HashMap<Integer,Layout> availableLayouts = new HashMap<Integer,Layout>();//<layout type,layout>
  //PGraphics[] layers = new PGraphics[NUM_LAYERS];//pending to implement the layers
  ArrayList<Animation> animations = new ArrayList<Animation>();
  
  public Scene(int type) {
    this.type = type; 
  }
  
  public void setLifeMills(int mills) {
    this.lifeMills = mills;
  }
  
  public void addLayout(Layout layout) {
    availableLayouts.put(layout.type,layout);
  }
  
  public void addPanel(Panel panel) {
    Animation panelLayer = new Animation(panel);
    animations.add(panelLayer);
  }
  
  public void setCurrentLayout(int layoutType) {
    this.currentLayout = availableLayouts.get(layoutType);
  }
  
  //while the scene display at firt time, the next layout should be set to make all visible objects faded in. 
  public void setNextLayout(int layoutType) {
    this.nextLayout = availableLayouts.get(layoutType);
  }
  
  public void appear() {
    this.currentLayout = null;
    if(this.nextLayout == null) {
      println("Error!!! no layout set for appearing scene(" + type+ ")");
    }
    switchLayout();
  }
  
  public void run(int elapsedMills) {
    for(Animation animation : animations) {
      animation.draw(elapsedMills);
    }
    
    during += elapsedMills;
    if(lifeMills != null && during >= lifeMills) {
      stop();
    }
  }
  
  public void disappear() {
    this.nextLayout = null;
    if(this.currentLayout == null) {
      println("Error!!! no layout set for disappearing scene(" + type+ ")");
    }
    switchLayout();
  }
  
  //whether all animations are completed mean scene is ready?
  public boolean isReady() {
    for(Animation animation : animations) {
      if(animation.isRunning()) {
        return false;
      }
    }
    return true;
  }
  
  public void stop() {
    finished = true;
  }
  
  public boolean isFinished() {
    return finished;
  }
  
  // switch layout from currentLayout to the next one. 
  //the current or next layout maybe is null for scenario of appearing and disappearing
  public void switchLayout() {
    if(!isReady() && during > 0) {
      //println("Scene(" + type + ") is switching layout, waiting for completion");
      return;
    }
    Integer currentLocation = null,nextLocation = null;
    for(Animation animation : animations) {
      if(currentLayout != null) {
        currentLocation = locationMapping.getLocation(this,currentLayout,animation.panel.name);
      }
      if(nextLayout != null) {
        nextLocation = locationMapping.getLocation(this,nextLayout,animation.panel.name);
      }//println("name:" + animation.panel.name + ",layout:" + (nextLayout==null?null:nextLayout.type) + ",current:" + currentLocation + ",next:" + nextLocation);
      if(currentLocation != null || nextLocation != null) {
        animation.setPath(((currentLocation==null)?null:currentLayout.detail.get(currentLocation)),((nextLocation==null)?null:nextLayout.detail.get(nextLocation)));
      }
    }
    this.currentLayout = this.nextLayout;
    this.nextLayout = null;
  }
}
public class Controller {
  public static final int EVENT_SHORT_CLICK = 1;
  public static final int EVENT_LONG_CLICK = 2;
  public static final int EVENT_DRAGGING = 3;
  public static final int EVENT_DRAG_RELEASE = 4;
  
  public void handleInteraction(int event) {
    ArrayList<Animation> animations = spiral.currentScene.animations; //<>//
    for(Animation animation : animations) {
      if(isInside(animation,null)) {
        if(animation.panel.name.equals(Panel.NAME_OF_MAIN_PANEL)) {
          handleMainPanel(animation,event);
        }
        else {
          handleLayoutChange(event);
        }
        break;
      }
    }
  }
  
  private void handleMainPanel(Animation animation,int event) {
    Widget widget = getFocusedwidget(animation); //<>//
    if(widget != null) {
      switch(event) {
        case EVENT_SHORT_CLICK:
            showCommonMenu(widget);
            break;
        case EVENT_LONG_CLICK:
            showSpecialMenu(widget);
            break;
        case EVENT_DRAGGING:
            handleWidget(widget);
            break;
        case EVENT_DRAG_RELEASE:
            stopHandleWidget(widget);
            break;
      }
    }
  }
  
  private void showSpecialMenu(Widget widget) {

  }
  
  private void showCommonMenu(Widget widget) {println("click on " + widget.name);
    widget.toggleBorder();
  }
  
  private void handleWidget(Widget widget) {
        widget.toggleBorder();
  }
  
  private void stopHandleWidget(Widget widget) {
    
  }
  
  private Widget getFocusedwidget(Animation animation) {
    for(Visible visible : animation.panel.visibleObjects) {
      if(isInside(animation,(Widget)visible)) {
        return (Widget)visible;
      }
    }
    return null;
  }
  
  private void handleLayoutChange(int event) {
    int layoutType = spiral.currentScene.currentLayout.type;
    layoutType++;
    if(layoutType > 6) {
      layoutType = 1;
     }
    spiral.currentScene.setNextLayout(layoutType);
    spiral.currentScene.switchLayout();
  }
  
  private boolean isInside(Animation animation,Widget widget) {
    PVector halfSize = widget==null?PVector.div(animation.panel.size,2):PVector.div(widget.size,2);
    PVector offset = widget==null?new PVector():PVector.sub(widget.position,PVector.div(animation.panel.size,2));
    PVector center = PVector.add(animation.current.position,offset);
    PVector topLeft = PVector.sub(center,halfSize);
    PVector bottomRight = PVector.add(center,halfSize);
    if(mouseX >= topLeft.x && mouseX <= bottomRight.x &&
       mouseY >= topLeft.y && mouseY <= bottomRight.y) {
         return true;
       }
    return false;
  }
  
  public void handleSynchronizatoin(String synData) {
    
  }
}
public class Controller {
  public static final int ORIGINAL_EVENT_CLICK = 1;
  public static final int ORIGINAL_EVENT_PRESS = 2;
  public static final int ORIGINAL_EVENT_DRAGGING = 3;
  public static final int ORIGINAL_EVENT_RELEASE = 4;
  public static final int EVENT_SHORT_CLICK = 5;
  public static final int EVENT_DOUBLE_CLICK = 6;
  public static final int EVENT_LONG_PRESS = 7;

  
  private int pressedTime;
  private int clickIntervalTime;
  boolean isFirstClicked;
  boolean isPressed,isLongPressedEventTriggered;
  Menu commonMenu,specialMenu;
  
  public void run(int elapsedMills) {
    pressedTime += elapsedMills;
    if(isFirstClicked) {
      clickIntervalTime += elapsedMills;
    }
    if(isPressed && pressedTime > LONG_PRESS_MILLIS) {
      if(!isLongPressedEventTriggered) {
        isLongPressedEventTriggered = true;
        handleInteraction(EVENT_LONG_PRESS);
      }
    }
  }
  
  private int handleEvent(int originalEvent) {
    switch(originalEvent) {
      case ORIGINAL_EVENT_PRESS:
        pressedTime = 0;
        isPressed = true;
        break;
      case ORIGINAL_EVENT_RELEASE:
        isPressed = false;
        isLongPressedEventTriggered = false;
        break;
      case ORIGINAL_EVENT_CLICK:
        if(isFirstClicked && clickIntervalTime <= DOUBLE_CLICK_INTERVAL) {
          isFirstClicked = false;
          return EVENT_DOUBLE_CLICK;
        }
        else {
          isFirstClicked = true;
        }
        clickIntervalTime = 0;
        break;
    }
    return originalEvent;
  }
  
  public void handleInteraction(int event) {
    int derivedEVent = handleEvent(event);
    ArrayList<Animation> animations = spiral.currentScene.animations; //<>//
    for(Animation animation : animations) {
      if(isInside(animation)) {
        if(animation.panel.name.equals(Panel.NAME_OF_MAIN_PANEL)) {
          handleMainPanel(animation,derivedEVent);
        }
        else {
          handleLayoutChange(derivedEVent);
        }
        break;
      }
      else {
        handleLayoutChange(derivedEVent);
      }
    }
  }
  
  private void handleMainPanel(Animation animation,int event) {
    Widget widget = getFocusedwidget(animation); //<>//
    if(widget != null) {
      switch(event) {
        case EVENT_LONG_PRESS:
            showCommonMenu(widget);
            break;
        case EVENT_DOUBLE_CLICK:
            showSpecialMenu(widget);
            break;
        case ORIGINAL_EVENT_DRAGGING:
            handleWidget(widget);
            break;
        case ORIGINAL_EVENT_RELEASE:
            stopHandleWidget(widget);
            break;
      }
    }
    else if(ORIGINAL_EVENT_RELEASE == event) {
      stopHandleWidget(widget);//TODO: stop all event
    }
  }
  
  private void showSpecialMenu(Widget widget) {
    println("double click on " + widget.name);
  }
  
  private void showCommonMenu(Widget widget) {println("long press on " + widget.name);
    if(commonMenu != null) {
      for(int widgetColor : gameColors) {
        if(widgetColor != widget.frontColor) {
          commonMenu.addAvailableColor(widgetColor);
        }
      }
      commonMenu.setShape(widget.shapeType);
      commonMenu.show(widget.position);
    }
  }
  
  private void handleWidget(Widget widget) {
        //widget.toggleBorder();
  }
  
  private void stopHandleWidget(Widget widget) {
    if(widget != null) {      
      println("release on " + widget.name);
    }
    if(commonMenu != null) {
      commonMenu.disappear();
    }
  }
  
  private Widget getFocusedwidget(Animation animation) {
    Widget focusedWidget = null;
    for(Visible visible : animation.panel.visibleObjects) {
      focusedWidget = getFocusedWidget(animation,(Widget)visible);
      if(focusedWidget != null) {
        return focusedWidget;
      }
    }
    return null;
  }
  
  private void handleLayoutChange(int event) {
    if(event == Controller.ORIGINAL_EVENT_DRAGGING) {
      int layoutType = spiral.currentScene.currentLayout.type;
      layoutType++;
      if(layoutType > 6) {
        layoutType = 1;
       }
      spiral.currentScene.setNextLayout(layoutType);
      spiral.currentScene.switchLayout();
    }
  }
  
   private Widget getFocusedWidget(Animation animation,Widget widget) {
     if(widget instanceof Menu) {
       boolean isFocused = false;
       for(Widget item : ((Menu)widget).getItems()) {
           isFocused = this.isWidgetFocused(animation,item,widget.position);
           if(isFocused) {
             return item;
           }
       }
     }
     else {
       if(this.isWidgetFocused(animation,widget,new PVector())) {
         return widget;
       }
     }
     return null;
   }
   
  private boolean isInside(Animation animation) {
    return isWidgetFocused(animation,null,new PVector());
  }
  
  //outsideOffset refers to the offset is out of the widget, is based on a middle layer position.
  private boolean isWidgetFocused(Animation animation,Widget widget,PVector outSideOffset) {
    if(animation.current != null) {
      PVector halfSize = widget==null?PVector.div(animation.panel.size,2):PVector.div(widget.size,2);
      PVector offset = new PVector();
      if(widget != null) {
        offset = PVector.add(widget.position,outSideOffset);
        offset.sub(PVector.div(animation.panel.size,2));
      }
      PVector center = PVector.add(animation.current.position,offset);
      PVector topLeft = PVector.sub(center,halfSize);
      PVector bottomRight = PVector.add(center,halfSize);
      //maybe the animation scaled
      PVector topLeftToPanelCenter = PVector.sub(topLeft,animation.current.position);
      topLeftToPanelCenter.mult(animation.current.scalar);
      topLeft = PVector.add(animation.current.position,topLeftToPanelCenter);
      PVector bottomRightToPanelCenter = PVector.sub(bottomRight,animation.current.position);
      bottomRightToPanelCenter.mult(animation.current.scalar);
      bottomRight = PVector.add(animation.current.position,bottomRightToPanelCenter);
      if(mouseX >= topLeft.x && mouseX <= bottomRight.x &&
         mouseY >= topLeft.y && mouseY <= bottomRight.y) {
           return true;
         }
    }
    return false;
  }
  
  public void handleSynchronizatoin(String synData) {
    
  }
}
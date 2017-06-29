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
  Widget focusedWidget;
  Panel synTarget;
  
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
      stopHandleWidget(null);//TODO: stop all event
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
      focusedWidget = widget;
    }
  }
  
  private void handleWidget(Widget widget) {
        //widget.toggleBorder();
  }
  
  private void stopHandleWidget(Widget widget) {
    if(commonMenu != null && commonMenu.showing) {
      commonMenu.disappear();
      if(widget != null && widget.type ==  Widget.TYPE_MENU_ITEM) {      
         //println("release on " + widget.name + ".color:" + focusedWidget.frontColor + ",item.color" + widget.frontColor);
         focusedWidget.frontColor = widget.frontColor;
         focusedWidget.value = widget.value;
         synGameCellValue(focusedWidget);
         //println("after release on " + widget.name + ".color:" + focusedWidget.frontColor);
      }
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
  
  public String getGameCellValues() {
    String values = "";
    for(Visible cell : synTarget.visibleObjects) {
      if(((Widget)cell).type == Widget.TYPE_GAME_CELL) {
        values += ((Widget)cell).value;
      }
    }
    return values;
  }
  
  public String synGameCellValue(Widget widget) {
    return null;
    //NetConnector.synData(synTarget.visibleObjects.indexOf(widget),widget.value);
  }
  
  public void updateGameCellValue(int index, int value) {
    Widget cell = (Widget)synTarget.visibleObjects.get(index);
    cell.frontColor = value;
  }
  
  public void handleSynchronizatoin(String synData) {
    
  }
  
  public void addRemotePanel(String values) {
    Scene scene = spiral.currentScene;
    if(scene.type ==  Scene.TYPE_MAIN) {
      int nextPanelIndex = scene.animations.size();
      String remotePanelName = null;
      switch(nextPanelIndex) {
        case 1:
          remotePanelName = Panel.NAME_OF_REMOTE_PANEL_1;
          break;
        case 2:
          remotePanelName = Panel.NAME_OF_REMOTE_PANEL_2;
          break;
        case 3:
          remotePanelName = Panel.NAME_OF_REMOTE_PANEL_3;
          break;
        case 4:
          remotePanelName = Panel.NAME_OF_REMOTE_PANEL_4;
          break;
      }
      Panel remotePanel = new Panel(remotePanelName);
      int cellWidth = int(DEFAULT_PANEL_SIZE.x/sqrt(values.length())/2);
      spiral.addPanel(Scene.TYPE_MAIN,attachShapeWidgets(remotePanel,cellWidth,values));
    }
  }
  
  public Panel attachShapeWidgets(Panel panel,int offsetOfWidgetCenter,String values) {
    Widget widget;
    int randomShapeType,widgetValue;
    for(int i=0;i<cellNumOfLevel;i++) {
      for(int j=0;j<cellNumOfLevel;j++) {
        randomShapeType = int(random(1,3));
        widget = new Widget("Shape_" + i + "_" + j, new PVector((2*i+1)*offsetOfWidgetCenter,(2*j+1)*offsetOfWidgetCenter),new PVector(offsetOfWidgetCenter,offsetOfWidgetCenter));
        widget.asShape(randomShapeType);
        widget.type = Widget.TYPE_GAME_CELL;
        widgetValue = int(values == null?random(0,5):values.charAt(i * cellNumOfLevel + j));
        widget.value = widgetValue + "";
        widget.frontColor = colors[widgetValue];
        widget.attachToPanel(panel);
      }
    }
    return panel;
  }
}
static final int NUM_LAYERS = 3;
static final int LAYER_BACKGROUND = 0;
static final int LAYER_MAIN = 1;
static final int LAYER_INFOMATION = 2;

int elapsedMills,currentMills,previousMills;
Spiral spiral;
VisibleLocationMapping locationMapping;
Controller controller;

/*void settings() {//not working in processingjs
  //fullScreen();
  size(int(SIZE.x),int(SIZE.y),P3D); //TODO: change to a better size or auto-resizble.
}*/

void setup() {
  size(180,320,P3D);
  rectMode(CENTER);
  ellipseMode(RADIUS);
  imageMode(CENTER);//not woriking in processingjs
  frameRate(FRAME_RATE);
  smooth();
  init();
  //network.init();
  //String[] fontList = PFont.list();
  //printArray(fontList);
}

public void init() {
 locationMapping = new VisibleLocationMapping();
 controller = new Controller();
 spiral = new Spiral();
 Panel welcomePanel = new Panel(Panel.NAME_OF_WELCOME_PANEL,new PVector(40,40));
 
 Widget circle = new Widget("Circle",new PVector(20,20),new PVector(20,20));
 //circle.asShape(Shape.CIRCLE);
 circle.asFont("Cube is a game");
 circle.attachToPanel(welcomePanel);
 spiral.addPanel(Scene.TYPE_WELCOME,welcomePanel);
 
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel(Panel.NAME_OF_MAIN_PANEL)));
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel(Panel.NAME_OF_REMOTE_PANEL_1)));
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel(Panel.NAME_OF_REMOTE_PANEL_2)));
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel(Panel.NAME_OF_REMOTE_PANEL_3)));
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel(Panel.NAME_OF_REMOTE_PANEL_4)));
 currentMills = millis();
}

private Panel attachRandomShapeWidgets(Panel panel) {
  Widget widget;
  int randomShapeType;
  int span = int(DEFAULT_PANEL_SIZE.x/CELL_NUM_OF_FIRST_LEVEL_GAME_PANEL);
  int offsetOfWidgetCenter = span/2;
  for(int i=0;i<CELL_NUM_OF_FIRST_LEVEL_GAME_PANEL;i++) {
    for(int j=0;j<CELL_NUM_OF_FIRST_LEVEL_GAME_PANEL;j++) {
      randomShapeType = int(random(1,3));
      widget = new Widget("Shape_" + i + "_" + j, new PVector((2*i+1)*offsetOfWidgetCenter,(2*j+1)*offsetOfWidgetCenter),new PVector(offsetOfWidgetCenter,offsetOfWidgetCenter));
      widget.asShape(randomShapeType);
      widget.attachToPanel(panel);
    }
  }
  return panel;
}

void draw() {
  background(0);
  previousMills = currentMills;
  currentMills =  millis();
  elapsedMills = currentMills - previousMills;
  spiral.run(elapsedMills);
}

void mouseDragged() {
  
  controller.handleInteraction(Controller.EVENT_DRAGGING);
  /*if(spiral.currentScene.type == Scene.TYPE_MAIN) {
    
    int layoutType = spiral.currentScene.currentLayout.type;
    layoutType++;
    if(layoutType > 6) {
      layoutType = 1;
     }
    spiral.currentScene.setNextLayout(layoutType);
    spiral.currentScene.switchLayout();
  }*/
}

void mouseClicked() {
  controller.handleInteraction(Controller.EVENT_SHORT_CLICK); //<>//
}

/*
void touchStart(TouchEvent touchEvent);
void touchMove(TouchEvent touchEvent);
void touchEnd(TouchEvent touchEvent);
void touchCancel(TouchEvent touchEvent);
touchEvent.touches array. offsetX and offsetY attributes of each element represent the position relative to the canvas, and can go outside the canvas
*/
static final int NUM_LAYERS = 3;
static final int LAYER_BACKGROUND = 0;
static final int LAYER_MAIN = 1;
static final int LAYER_INFOMATION = 2;

int elapsedMills,currentMills,previousMills;
Spiral spiral;
VisibleLocationMapping locationMapping;
Controller controller;
int cellNumOfLevel;
ArrayList<Integer> gameColors = new ArrayList<Integer>();
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
 gameColors.add(RED);
 gameColors.add(BLUE);
 gameColors.add(GREEN);
 gameColors.add(YELLOW);
 gameColors.add(PURPLE);
 cellNumOfLevel = CELL_NUM_OF_FIRST_LEVEL_GAME_PANEL;
 locationMapping = new VisibleLocationMapping();
 controller = new Controller();
 spiral = new Spiral();
 Panel welcomePanel = new Panel(Panel.NAME_OF_WELCOME_PANEL,new PVector(40,40));
 
 Widget circle = new Widget("Circle",new PVector(20,20),new PVector(20,20));
 //circle.asShape(Shape.CIRCLE);
 circle.asFont("Cube is a game");
 circle.attachToPanel(welcomePanel);
 spiral.addPanel(Scene.TYPE_WELCOME,welcomePanel);
 
 Panel mainPanel = new Panel(Panel.NAME_OF_MAIN_PANEL);
 Menu commonMenu = new Menu("commonMenu",new PVector(),new PVector());//the menu position and size is not predefined
 int cellWidth = int(DEFAULT_PANEL_SIZE.x/cellNumOfLevel/2);
 PVector cellSize = new PVector(cellWidth,cellWidth);
 commonMenu.attachToPanel(mainPanel);
 commonMenu.init(Menu.LAYOUT_SQUARE,cellSize);
 controller.commonMenu = commonMenu;
 
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(mainPanel,cellWidth));
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel(Panel.NAME_OF_REMOTE_PANEL_1),cellWidth));
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel(Panel.NAME_OF_REMOTE_PANEL_2),cellWidth));
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel(Panel.NAME_OF_REMOTE_PANEL_3),cellWidth));
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel(Panel.NAME_OF_REMOTE_PANEL_4),cellWidth));
 currentMills = millis();
}

private Panel attachRandomShapeWidgets(Panel panel,int offsetOfWidgetCenter) {
  Widget widget;
  int randomShapeType;
  for(int i=0;i<cellNumOfLevel;i++) {
    for(int j=0;j<cellNumOfLevel;j++) {
      randomShapeType = int(random(1,3));
      widget = new Widget("Shape_" + i + "_" + j, new PVector((2*i+1)*offsetOfWidgetCenter,(2*j+1)*offsetOfWidgetCenter),new PVector(offsetOfWidgetCenter,offsetOfWidgetCenter));
      widget.asShape(randomShapeType);
      widget.type = Widget.TYPE_GAME_CELL;
      widget.frontColor = colors[int(random(0,5))];
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
  controller.run(elapsedMills);
  spiral.run(elapsedMills);
}

private boolean isInMainScene() {
  if(spiral.currentScene != null && spiral.currentScene.type == Scene.TYPE_MAIN) {
    return true;
  }
  return false;
}

private void handleEvent(int event) {
  if(isInMainScene()) {
    controller.handleInteraction(event);
  }
}

void mouseDragged() {
  if(isInMainScene()) {
      controller.handleInteraction(Controller.ORIGINAL_EVENT_DRAGGING);
  }
}

void mousePressed() {
  handleEvent(Controller.ORIGINAL_EVENT_PRESS);
}

void mouseReleased() {
  handleEvent(Controller.ORIGINAL_EVENT_RELEASE); //<>//
}

void mouseClicked() {
  handleEvent(Controller.ORIGINAL_EVENT_CLICK);
}

/*
mouseEvent.getClickCount();
void touchStart(TouchEvent touchEvent);
void touchMove(TouchEvent touchEvent);
void touchEnd(TouchEvent touchEvent);
void touchCancel(TouchEvent touchEvent);
touchEvent.touches array. offsetX and offsetY attributes of each element represent the position relative to the canvas, and can go outside the canvas
*/
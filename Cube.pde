static final int NUM_LAYERS = 3;
static final int LAYER_BACKGROUND = 0;
static final int LAYER_MAIN = 1;
static final int LAYER_INFOMATION = 2;

int elapsedMills,currentMills,previousMills;
Spiral spiral;
VisibleLocationMapping locationMapping;
Controller controller;
int cellNumOfLevel;

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
  //NetConnector.init();
  //String[] fontList = PFont.list();
  //printArray(fontList);
}

public void init() {
 cellNumOfLevel = CELL_NUM_OF_FIRST_LEVEL_GAME_PANEL;
 locationMapping = new VisibleLocationMapping();
 controller = new Controller();
 spiral = new Spiral();
 Panel welcomePanel = new Panel(Panel.NAME_OF_WELCOME_PANEL,new PVector(180,40));
 welcomePanel.backgroundColor = color(0);
 
 Widget welcome = new Widget("welcome",new PVector(90,20),new PVector(20,20));
 //circle.asShape(Shape.CIRCLE);
 welcome.asFont("Cube is a game");
 welcome.attachToPanel(welcomePanel);
 spiral.addPanel(Scene.TYPE_WELCOME,welcomePanel);
 
 Panel mainPanel = new Panel(Panel.NAME_OF_MAIN_PANEL);
 mainPanel.backgroundColor = color(0);
 Menu commonMenu = new Menu("commonMenu",new PVector(),new PVector());//the menu position and size is not predefined
 int cellWidth = int(DEFAULT_PANEL_SIZE.x/cellNumOfLevel/2);
 PVector cellSize = new PVector(cellWidth,cellWidth);
 commonMenu.attachToPanel(mainPanel);
 commonMenu.init(Menu.LAYOUT_SQUARE,cellSize);
 controller.commonMenu = commonMenu;
 controller.synTarget = mainPanel;
 
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(mainPanel,cellWidth));
 //spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel(Panel.NAME_OF_REMOTE_PANEL_1),cellWidth));
 //spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel(Panel.NAME_OF_REMOTE_PANEL_2),cellWidth));
 //spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel(Panel.NAME_OF_REMOTE_PANEL_3),cellWidth));
 //spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel(Panel.NAME_OF_REMOTE_PANEL_4),cellWidth));
 currentMills = millis();
}

private Panel attachRandomShapeWidgets(Panel panel,int offsetOfWidgetCenter) {
  return controller.attachShapeWidgets(panel,offsetOfWidgetCenter,null);
}

public void go() {
  //not used, maybe never use. just make the construction consistency with SimeplGo in client.js
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

void updateNetConnectionNum(int count) {
  //implement later
}

public String getLocalGameCellValues() {
  println("syn values to others: ");
  return controller.getLocalGameCellValues();
}

public void updateRemoteGameCellValue(String remotePeerId,int index, String value) {
  println("get update form : " + remotePeerId);
  controller.updateRemoteGameCellValue(remotePeerId,index,value);
}

public void initRemoteGame(String remotePeerId,String values) {
  println("New peer get connection: " + remotePeerId);
  controller.initRemoteGame(remotePeerId,values);
}

/*
mouseEvent.getClickCount();
void touchStart(TouchEvent touchEvent);
void touchMove(TouchEvent touchEvent);
void touchEnd(TouchEvent touchEvent);
void touchCancel(TouchEvent touchEvent);
touchEvent.touches array. offsetX and offsetY attributes of each element represent the position relative to the canvas, and can go outside the canvas
*/
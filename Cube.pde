import java.util.Map;

static final int NUM_LAYERS = 3;
static final int LAYER_BACKGROUND = 0;
static final int LAYER_MAIN = 1;
static final int LAYER_INFOMATION = 2;

int elapsedMills,currentMills,previousMills;
Spiral spiral;
VisibleLocationMapping locationMapping;

void settings() {
  //fullScreen();
  size(int(SIZE.x),int(SIZE.y),P3D); //TODO: change to a better size or auto-resizble.
}

void setup() {
  rectMode(CENTER);
  ellipseMode(RADIUS);
  imageMode(CENTER);
  frameRate(FRAME_RATE);
  init();
  //network.init();
  //String[] fontList = PFont.list();
  //printArray(fontList);
}

public void init() {
 locationMapping = new VisibleLocationMapping();
 spiral = new Spiral();
 Panel welcomePanel = new Panel("GameDisplayName",new PVector(40,40));
 
 Widget circle = new Widget("Circle",new PVector(20,20),new PVector(20,20));
 //circle.asShape(Shape.CIRCLE);
 circle.asFont("Cube is a game");
 circle.attachToPanel(welcomePanel);
 spiral.addPanel(Scene.TYPE_WELCOME,welcomePanel);
 
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel("SelfGamePanel")));
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel("RemoteGamePanel1")));
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel("RemoteGamePanel2")));
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel("RemoteGamePanel3")));
 spiral.addPanel(Scene.TYPE_MAIN,attachRandomShapeWidgets(new Panel("RemoteGamePanel4")));
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
  if(spiral.currentScene.type == Scene.TYPE_MAIN) {
    int layoutType = spiral.currentScene.currentLayout.type;
    layoutType++;
    if(layoutType > 6) {
      layoutType = 1;
     }
    spiral.currentScene.setNextLayout(layoutType);
    spiral.currentScene.switchLayout();
  }
}
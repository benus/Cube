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
  frameRate(FRAME_RATE);
  init();
  //network.init();
}

public void init() {
 locationMapping = new VisibleLocationMapping();
 spiral = new Spiral();
 spiral.addPanel(Scene.TYPE_WELCOME,new Panel("GameDisplayName",new PVector(40,40)));
 spiral.addPanel(Scene.TYPE_MAIN,new Panel("SelfGamePanel",new PVector(100,100)));
 spiral.addPanel(Scene.TYPE_MAIN,new Panel("RemoteGamePanel1",new PVector(100,100)));
 spiral.addPanel(Scene.TYPE_MAIN,new Panel("RemoteGamePanel2",new PVector(100,100)));
 spiral.addPanel(Scene.TYPE_MAIN,new Panel("RemoteGamePanel3",new PVector(100,100)));
 spiral.addPanel(Scene.TYPE_MAIN,new Panel("RemoteGamePanel4",new PVector(100,100)));
 currentMills = millis();
}

void draw() {
  background(125);
  previousMills = currentMills;
  currentMills =  millis();
  elapsedMills = currentMills - previousMills;
  spiral.run(elapsedMills);
}

void mouseDragged() {
  if(spiral.currentScene.type == Scene.TYPE_MAIN) {
    int layoutType = spiral.currentScene.currentLayout.type;
    layoutType++;
    if(layoutType > 4) {
      layoutType = 1;
     }
    spiral.currentScene.setNextLayout(layoutType);
    spiral.currentScene.switchLayout();
  }
}
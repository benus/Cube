/**
** Which controls scenes and flow
** The idea about it is like Thread
**/
public class Spiral {
  public static final int STATUS_RUNNING = 1;
  public static final int STATUS_SWITCHING = 2;
  public static final int STATUS_EDNING = 3;
  
  int status; 
  Scene currentScene,nextScene; 
  private Map<Integer,Scene> availableScenes = new HashMap<Integer,Scene>();//<layout type,layout>
  
  public Spiral() {
    Scene welcome = new Scene(Scene.TYPE_WELCOME);
    welcome.setLifeMills(LIFE_MILLIS_SCENE_WELCOME);
    welcome.addLayout(new Layout(Layout.LAYOUT_FULL_SCREEN));
    welcome.setNextLayout(Layout.LAYOUT_FULL_SCREEN);
    availableScenes.put(Scene.TYPE_WELCOME,welcome);
    
    Scene main = new Scene(Scene.TYPE_MAIN);
    main.addLayout(new Layout(Layout.LAYOUT_FULL_SCREEN));
    main.addLayout(new Layout(Layout.LAYOUT_TWO_PANELS_LANDSCAPE));
    main.addLayout(new Layout(Layout.LAYOUT_TWO_PANELS_PORTRAIT));
    main.addLayout(new Layout(Layout.LAYOUT_THREE_PANELS_LANDSCAPE));
    main.addLayout(new Layout(Layout.LAYOUT_THREE_PANELS_PORTRAIT));
    main.addLayout(new Layout(Layout.LAYOUT_ALL_PANELS));
    main.setNextLayout(Layout.LAYOUT_FULL_SCREEN);
    availableScenes.put(Scene.TYPE_MAIN,main);
    
    //TODO : end scene
    nextScene = welcome;
  }
  
  public void addPanel(int sceneType,Panel panel) {
    Scene scene = availableScenes.get(sceneType);
    if(scene != null) {
      scene.addPanel(panel);
    }
  }
  
  //while switching, the current and next scene are runing in parrallel
  public void run(int elapsedMills) {
    if(currentScene != null) {
       if(currentScene.isFinished() && status != STATUS_SWITCHING) {
          switchScene();
          status = STATUS_SWITCHING;
        }
      currentScene.run(elapsedMills);
    }
    else if(nextScene != null && status != STATUS_SWITCHING) {      
      switchScene();
      status = STATUS_SWITCHING;
    }
    
    if(nextScene != null) {
       nextScene.run(elapsedMills);
       if(nextScene.isReady()) {
          status = STATUS_RUNNING;
          currentScene = nextScene;
          nextScene = null;
       }    
    }
  }
    
  private void switchScene() {
    int nextSceneType = 1;
    if(currentScene != null) {
      currentScene.disappear();
      nextSceneType = currentScene.type + 1;
    }
    nextScene = availableScenes.get(nextSceneType);
    nextScene.appear();
  }
}
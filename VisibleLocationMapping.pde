public class VisibleLocationMapping {
  private static final String DELIMITER = ":";
  HashMap<String,Integer> mapping = new HashMap<String,Integer>();//<scene:layout:panelName,location>
  
  public VisibleLocationMapping() {
    //Scene "WELCOME"
    mapping.put(Scene.TYPE_WELCOME + DELIMITER + Layout.LAYOUT_FULL_SCREEN + DELIMITER + "GameDisplayName",Layout.LOCATION_CENTER);
    //Scene "MAIN"
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_FULL_SCREEN + DELIMITER + "SelfGamePanel",Layout.LOCATION_CENTER);
    
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_TWO_PANELS_LANDSCAPE + DELIMITER + "SelfGamePanel",Layout.LOCATION_RIGHT);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_TWO_PANELS_LANDSCAPE + DELIMITER + "RemoteGamePanel1",Layout.LOCATION_LEFT);
    
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_TWO_PANELS_PORTRAIT + DELIMITER + "SelfGamePanel",Layout.LOCATION_BOTTOM);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_TWO_PANELS_PORTRAIT + DELIMITER + "RemoteGamePanel1",Layout.LOCATION_TOP);
    
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_THREE_PANELS_LANDSCAPE + DELIMITER + "SelfGamePanel",Layout.LOCATION_CENTER);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_THREE_PANELS_LANDSCAPE + DELIMITER + "RemoteGamePanel1",Layout.LOCATION_LEFT);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_THREE_PANELS_LANDSCAPE + DELIMITER + "RemoteGamePanel2",Layout.LOCATION_RIGHT);
        
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_THREE_PANELS_PORTRAIT + DELIMITER + "SelfGamePanel",Layout.LOCATION_CENTER);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_THREE_PANELS_PORTRAIT + DELIMITER + "RemoteGamePanel1",Layout.LOCATION_TOP);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_THREE_PANELS_PORTRAIT + DELIMITER + "RemoteGamePanel2",Layout.LOCATION_BOTTOM);
    
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_ALL_PANELS + DELIMITER + "SelfGamePanel",Layout.LOCATION_CENTER);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_ALL_PANELS + DELIMITER + "RemoteGamePanel1",Layout.LOCATION_LEFT);    
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_ALL_PANELS + DELIMITER + "RemoteGamePanel2",Layout.LOCATION_TOP);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_ALL_PANELS + DELIMITER + "RemoteGamePanel3",Layout.LOCATION_RIGHT);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_ALL_PANELS + DELIMITER + "RemoteGamePanel4",Layout.LOCATION_BOTTOM);
  }
  
  public Integer getLocation(Scene scene,Layout layout, String visibleName) {
    return mapping.get(scene.type + DELIMITER + layout.type + DELIMITER + visibleName);
  }
}
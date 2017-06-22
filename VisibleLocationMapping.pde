public class VisibleLocationMapping {
  private static final String DELIMITER = ":";
  HashMap<String,Integer> mapping = new HashMap<String,Integer>();//<scene:layout:panelName,location>
  
  public VisibleLocationMapping() {
    //Scene "WELCOME"
    mapping.put(Scene.TYPE_WELCOME + DELIMITER + Layout.LAYOUT_FULL_SCREEN + DELIMITER + Panel.NAME_OF_WELCOME_PANEL,Layout.LOCATION_CENTER);
    //Scene "MAIN"
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_FULL_SCREEN + DELIMITER + Panel.NAME_OF_MAIN_PANEL,Layout.LOCATION_CENTER);
    
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_TWO_PANELS_LANDSCAPE + DELIMITER + Panel.NAME_OF_MAIN_PANEL,Layout.LOCATION_RIGHT);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_TWO_PANELS_LANDSCAPE + DELIMITER + Panel.NAME_OF_REMOTE_PANEL_1,Layout.LOCATION_LEFT);
    
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_TWO_PANELS_PORTRAIT + DELIMITER + Panel.NAME_OF_MAIN_PANEL,Layout.LOCATION_BOTTOM);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_TWO_PANELS_PORTRAIT + DELIMITER + Panel.NAME_OF_REMOTE_PANEL_1,Layout.LOCATION_TOP);
    
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_THREE_PANELS_LANDSCAPE + DELIMITER + Panel.NAME_OF_MAIN_PANEL,Layout.LOCATION_CENTER);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_THREE_PANELS_LANDSCAPE + DELIMITER + Panel.NAME_OF_REMOTE_PANEL_1,Layout.LOCATION_LEFT);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_THREE_PANELS_LANDSCAPE + DELIMITER + Panel.NAME_OF_REMOTE_PANEL_2,Layout.LOCATION_RIGHT);
        
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_THREE_PANELS_PORTRAIT + DELIMITER + Panel.NAME_OF_MAIN_PANEL,Layout.LOCATION_CENTER);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_THREE_PANELS_PORTRAIT + DELIMITER + Panel.NAME_OF_REMOTE_PANEL_1,Layout.LOCATION_TOP);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_THREE_PANELS_PORTRAIT + DELIMITER + Panel.NAME_OF_REMOTE_PANEL_2,Layout.LOCATION_BOTTOM);
    
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_ALL_PANELS + DELIMITER + Panel.NAME_OF_MAIN_PANEL,Layout.LOCATION_CENTER);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_ALL_PANELS + DELIMITER + Panel.NAME_OF_REMOTE_PANEL_1,Layout.LOCATION_LEFT);    
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_ALL_PANELS + DELIMITER + Panel.NAME_OF_REMOTE_PANEL_2,Layout.LOCATION_TOP);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_ALL_PANELS + DELIMITER + Panel.NAME_OF_REMOTE_PANEL_3,Layout.LOCATION_RIGHT);
    mapping.put(Scene.TYPE_MAIN + DELIMITER + Layout.LAYOUT_ALL_PANELS + DELIMITER + Panel.NAME_OF_REMOTE_PANEL_4,Layout.LOCATION_BOTTOM);
  }
  
  public Integer getLocation(Scene scene,Layout layout, String visibleName) {
    return mapping.get(scene.type + DELIMITER + layout.type + DELIMITER + visibleName);
  }
}
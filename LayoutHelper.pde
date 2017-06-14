public class LayoutHelper {
  
  private float margin,scalar = 1;
  private int layoutType;
  private PVector size,panelSize;
  
  public LayoutHelper(PVector size) {
    this.size = size;
  }
  
  public void setMargin(float margin) {
    this.margin = margin;
  }
  
  public void setLayoutType(int type) {
    this.layoutType = type;
  }
  
  //the size of panel refers to all panels . should ensure all panels have same size
  public void setPanelSize(PVector size) {
    this.panelSize = size;
  }
  
  //this scalar is for main panel
  public void setScalar(float scalar) {
    this.scalar = scalar;
  }
  
  public float getVerticalPanelHeight() {
    float remainderHeight = this.size.y;
    if(this.size.y > this.size.x) {
      remainderHeight -= margin;
    }
    if(layoutType == Layout.LAYOUT_TWO_PANELS_PORTRAIT ||
       layoutType == Layout.LAYOUT_THREE_PANELS_PORTRAIT
       ) {
        remainderHeight -= panelSize.y * scalar;
    }
    else if(layoutType == Layout.LAYOUT_ALL_PANELS) {
      remainderHeight -= panelSize.y * scalar;
      remainderHeight /=2;
    }
    return remainderHeight;
  }
  
    
  public float getHorizontalPanelWidth() {
    float remainderWidth = this.size.x;
    if(this.size.x > this.size.y) {
      remainderWidth -= margin;
    }
    if(layoutType == Layout.LAYOUT_TWO_PANELS_LANDSCAPE ||
       layoutType == Layout.LAYOUT_THREE_PANELS_LANDSCAPE
       ) {
        remainderWidth -= panelSize.x * scalar;
    }
    else if(layoutType == Layout.LAYOUT_ALL_PANELS) {
      remainderWidth -= panelSize.x * scalar;
      remainderWidth /= 2;
    }
    return remainderWidth;
  }
  
  
  public float getVerticalPanelYOffset() {
    return this.panelSize.y/2 * scalar + this.panelSize.y/2;
  }
  
  public float getHorizontalPanelXOffset() {
    //the half size of main panel plus half size of other panel.
    //main panel is maybe scaled
    return this.panelSize.x/2 * scalar + this.panelSize.x/2;
  }
}
/**
** From design perspective, the Animation is a decorator of Panel
*/
public class Animation implements Visible {
  private Panel panel; //this is the object to be animated.
  Frame from,to,current;// from refers the first frame, to refers to the last frame.
  float progress = -1; //it is a rate about animation progress
  boolean available; //if there is no from and to set, this animation should not be drawed

  public Animation(Panel panel) {
    this.panel = panel;
  }
  
  public void setPath(Frame from, Frame to) {
    this.from = from;
    this.to = to;
    if(from != null || to != null) {
      if(from == null) {
        this.from = new Frame(new PVector(to.position.x,to.position.y,BACKSTAGE_POSITION_Z),to.rotate.copy(),to.rotateOffset.copy(),0,0);
      }
      else if(to == null) {
        this.to = new Frame(new PVector(from.position.x,from.position.y,BACKSTAGE_POSITION_Z),from.rotate.copy(),from.rotateOffset.copy(),0,0);
      }
      this.current = new Frame(this.from.position.copy(),this.from.rotate.copy(),this.from.rotateOffset.copy(),this.from.scalar,this.from.alpha);
      progress = 0;
      available = true;
    }
    else {
      progress = 1;
      available = false;
    }
    
  }
  
  private void run(int elapsedMills) {
    progress += (((float)elapsedMills)/MILLIS_FOR_MOVE_SPEED);
    if(progress >= 1) {
      progress = 1;
    }

    float x = lerp(from.position.x,to.position.x,progress);
    float y = lerp(from.position.y,to.position.y,progress);
    float z = lerp(from.position.z,to.position.z,progress);
    float angleX = lerp(from.rotate.x,to.rotate.x,progress);
    float angleY = lerp(from.rotate.y,to.rotate.y,progress);
    float angleZ = lerp(from.rotate.z,to.rotate.z,progress);
    float rotateOffsetX = lerp(from.rotateOffset.x,to.rotateOffset.x,progress);
    float rotateOffsetY = lerp(from.rotateOffset.y,to.rotateOffset.y,progress);
    float rotateOffsetZ = lerp(from.rotateOffset.z,to.rotateOffset.z,progress);
    float scalar = lerp(from.scalar,to.scalar,progress);
    float alpha = lerp(from.alpha,to.alpha,progress);
    current = new Frame(new PVector(x,y,z),new PVector(angleX,angleY,angleZ),new PVector(rotateOffsetX,rotateOffsetY,rotateOffsetZ),scalar,alpha);
  }
  
  public boolean isRunning() {
    return progress >=0 && progress < 1;
  }
  
  public void draw(int elapsedMills) {
    if(!available) {
      return;
    }
    if(isRunning()) {
      run(elapsedMills);
    }
    else {//a weird thing happens in processingjs. the disappeared panel will pop up agin. try to do not paint it while the saclar is much small.
      //println(panel.name + ",z=" + current.position.z + ",scalar="+ current.scalar);
      if(current.scalar <= 0.1) {
        return;
      }
    }
    pushMatrix();
    //rotateOffset is used to make the rotation center is different from object center, eg. rotation around one side of object
    translate(current.position.x + current.rotateOffset.x,current.position.y + current.rotateOffset.y,current.position.z + current.rotateOffset.z);
    //translate(0,0,current.position.z); //to make the visible object looks bigger or smaller
    scale(current.scalar);
    rotateX(current.rotate.x);
    rotateY(current.rotate.y);
    rotateZ(current.rotate.z);
    translate(-current.rotateOffset.x,-current.rotateOffset.y,-current.rotateOffset.z);
    fill(MY_MAIN_PANEL_COLOR,current.alpha);//TODO: change fill to title 
    panel.draw(elapsedMills);
    popMatrix();
  }
}
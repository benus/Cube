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
        this.from = new Frame(new PVector(to.position.x,to.position.y,BACKSTAGE_POSITION_Z),to.rotate.copy(),0,0);
      }
      else if(to == null) {
        this.to = new Frame(new PVector(from.position.x,from.position.y,BACKSTAGE_POSITION_Z),from.rotate.copy(),0,0);
      }
      this.current = new Frame(this.from.position.copy(),this.from.rotate.copy(),this.from.scalar,this.from.alpha);
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
    float scalar = lerp(from.scalar,to.scalar,progress);
    float alpha = lerp(from.alpha,to.alpha,progress);
    current = new Frame(new PVector(x,y,z),new PVector(angleX,angleY,angleZ),scalar,alpha);
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
    pushMatrix();
    translate(current.position.x,current.position.y,current.position.z);
    scale(current.scalar);
    rotateX(current.rotate.x);
    rotateY(current.rotate.y);
    rotateZ(current.rotate.z);
    fill(MY_MAIN_PANEL_COLOR,current.alpha);//TODO: change fill to title 
    panel.draw(elapsedMills);
    popMatrix();
  }
}
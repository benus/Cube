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
        this.from = new Frame(to.x,to.y,to.rotate,0,0);
      }
      else if(to == null) {
        this.to = new Frame(from.x,from.y,from.rotate,0,0);
      }
      this.current = new Frame(this.from.x,this.from.y,this.from.rotate,this.from.scalar,this.from.alpha);
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

    float x = lerp(from.x,to.x,progress);
    float y = lerp(from.y,to.y,progress);
    float angleX = lerp(from.rotate.x,to.rotate.x,progress);
    float angleY = lerp(from.rotate.y,to.rotate.y,progress);
    float angleZ = lerp(from.rotate.z,to.rotate.z,progress);
    float scalar = lerp(from.scalar,to.scalar,progress);
    float alpha = lerp(from.alpha,to.alpha,progress);
    current = new Frame(int(x),int(y),new PVector(angleX,angleY,angleZ),scalar,alpha);
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
    translate(current.x,current.y);
    scale(current.scalar);
    rotateX(current.rotate.x);
    rotateY(current.rotate.y);
    rotateZ(current.rotate.z);
    fill(MY_MAIN_PANEL_COLOR,current.alpha);//TODO: change fill to title 
    panel.draw(elapsedMills);
    popMatrix();
  }
}
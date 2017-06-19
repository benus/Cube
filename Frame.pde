public class Frame {
    PVector position,rotate,rotateOffset;
    float scalar,alpha;
    
    public Frame(PVector position,PVector rotate,PVector rotateOffset,float scalar,float alpha) {
      this.position = position;
      this.rotate = rotate;
      this.rotateOffset = rotateOffset;
      this.scalar = scalar;
      this.alpha  = alpha;
    }
    
    public Frame(PVector position,PVector rotate,PVector rotateOffset,float scalar) {
      this(position,rotate,rotateOffset,scalar,255);
    }
    
    public Frame(PVector position,PVector rotate,PVector rotateOffset) {
      this(position,rotate,rotateOffset,1,255);
    }
    
    public Frame(PVector position,float scalar) {
      this(position,new PVector(),new PVector(),scalar,255);
    }
    
    public Frame(PVector position) {
      this(position,new PVector(),new PVector(),1,255);
    }
    
    public String toString() {
      return "x=" + position.x + ",y=" + position.y + ",z=" + position.z + ",angelX=" + rotate.x + ",angleY=" +rotate.y + ",angleZ=" +rotate.z + ",rotateOffsetX=" + rotateOffset.x + ",rotateOffsetY=" +rotateOffset.y + ",rotateOffsetZ=" +rotateOffset.z + ",scalar=" + scalar + ",alpha=" + alpha; 
    }
}
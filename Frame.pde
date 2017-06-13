public class Frame {
    PVector position,rotate;
    float scalar,alpha;
    
    public Frame(PVector position,PVector rotate,float scalar,float alpha) {
      this.position = position;
      this.rotate = rotate;
      this.scalar = scalar;
      this.alpha  = alpha;
    }
    
    public String toString() {
      return "x=" + position.x + ",y=" + position.y + ",z=" + position.z + ",angelX=" + rotate.x + ",angleY=" +rotate.y + ",angleZ=" +rotate.z + ",scalar=" + scalar + ",alpha=" + alpha; 
    }
}
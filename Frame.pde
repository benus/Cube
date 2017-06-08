public class Frame {
    int x,y;
    PVector rotate;
    float scalar,alpha;
    
    public Frame(int x,int y,PVector rotate,float scalar,float alpha) {
      this.x = x;
      this.y = y;
      this.rotate = rotate;
      this.scalar = scalar;
      this.alpha  = alpha;
    }
    
    public String toString() {
      return "x=" + x + ",y=" + y + ",angelX=" + rotate.x + ",angleY=" +rotate.y + ",angleZ=" +rotate.z + ",scalar=" + scalar + ",alpha=" + alpha; 
    }
}
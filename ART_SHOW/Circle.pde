public class Circle extends Shape {

  public Circle(float x, float y, int w, int h) {
    this.shape = createShape(ELLIPSE,x,y,w,h);
    this.shape.fill(128);
    this.X = x;
    this.Y = y;
    this.W = w;
    this.H = h;
    middle = new PVector(x + (w/2), y + (h/2));
  }
  
  public void addX(float x) {
    this.X += x;
  }
  
  public void addY(float y) {
    this.Y += y;
  }
  
  public void redrawShape() {
    this.shape = createShape(ELLIPSE,X,Y,W,H);
    this.middle.x = X + (W/2);
    this.middle.y = Y + (H/2);
    drawShape();
  }
  
  private void moveShape() {
    X += velocity.x;
    Y += velocity.y;
    redrawShape();
  }
  
  private void setStroke(int r, int g, int b) {
    sr = r;
    sg = g;
    sb = b;
  }
  
  private void setStrokeWeight(int weight) {
    sw = weight;
  }
  
  private void setFill(int r, int g, int b) {
    fr = r;
    fg = g;
    fb = b;
  }

}

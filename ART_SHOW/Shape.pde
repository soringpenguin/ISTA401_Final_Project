public class Shape {

  TuioCursor cursor;
  int W;
  int H;
  float X;
  float Y;
  float x_dif;
  float y_dif;
  PVector middle;
  int sr, sg, sb;
  int fr, fg, fb;
  int sw;
  PShape shape;
  PVector velocity = new PVector(0,0);
  PVector outsideShape = new PVector(0,0);
  public Shape() {
    cursor = null;
  }
  
  public void drawShape() {
    shape.stroke(sr,sg,sb);
    if(sw == 0)
      shape.noStroke();
    else  
      shape.strokeWeight(sw);
    shape.fill(fr,fg,fb);
    shape(shape);
  }
  
  public void setDifs(float x, float y) {
    x_dif = x;
    y_dif = y;
  }

}

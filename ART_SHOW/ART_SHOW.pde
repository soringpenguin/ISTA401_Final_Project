import java.util.*;
import TUIO.*;
TuioProcessing tuioClient;

ArrayList<Circle> shapes;

Vector<TuioCursor> cursors;
int W = 1280;
int H = 800;
float[] xspeeds;
float[] yspeeds;

PVector GRAVITY = new PVector(0.0,0.25);

boolean gravityOn = true;
boolean ballCollisionsOn = true;
boolean frictionOn = true;


// -0.65
float TOP_BOUNCE_BACK = -1.00;
float BOTTOM_BOUNCE_BACK = -0.85;
float LEFT_BOUNCE_BACK = -0.85;
float RIGHT_BOUNCE_BACK = -0.85;
float GROUND_FRICTION = 0.0075;

//float lx = 400.0;
//float ly = 400.0;
//float rx = lx + 200.0;
//float ry = ly;

float lx = W/2.0;
float ly = (H*3.0)/8.0 - 100.0;
float rx = lx;
float ry = ly+200.0;

Circle leftHoop;
Circle rightHoop;

Circle cir1;
Circle cir2;
Circle cir3;

void setup() {
  size(W, H, P2D);
  smooth();

  //  hoop = createShape(ELLIPSE, 0,200,200,50);
  //  hoop.stroke(255,255,255);
  //  hoop.strokeWeight(5);
  //  hoop.fill(0);
  //  shape(hoop);

  xspeeds = new float[10];
  yspeeds = new float[10];

  shapes = new ArrayList<Circle>();

  cir1 = new Circle(700, 50, 100, 100);
  cir1.setStroke(255, 255, 255);  
  cir1.setStrokeWeight(7);
  cir1.setFill(0, 0, 255);
  shapes.add(cir1);

  leftHoop = new Circle(lx-(5/2.0), ly-(5.0/2), 5, 5);
  leftHoop.setStroke(255, 255, 255);  
  leftHoop.setStrokeWeight(5);
  leftHoop.setFill(0, 0, 0);

  rightHoop = new Circle(rx-(5/2.0), ry-(5.0/2), 5, 5);
  rightHoop.setStroke(255, 255, 255);  
  rightHoop.setStrokeWeight(5);
  rightHoop.setFill(0, 0, 0);

  cir2 = new Circle(350.0, 0.0, 100, 100);
  cir2.setStroke(255, 255, 255);  
  cir2.setStrokeWeight(5);
  cir2.setFill(0, 255, 0);
  shapes.add(cir2);

  cir3 = new Circle(150, 0, 100, 100);
  cir3.setStroke(255, 255, 255);  
  cir3.setStrokeWeight(5);
  cir3.setFill(255, 0, 0);
  shapes.add(cir3);

  tuioClient  = new TuioProcessing(this);
  cursors = new Vector<TuioCursor>();
  background(0);
}

int speed_index = 0;

void draw() {

  for (Circle c : shapes) {
    if (isTouchingHoop(c, rightHoop) || isTouchingHoop(c, leftHoop)) {
      c.X = c.outsideShape.x;
      c.Y = c.outsideShape.y;
      c.velocity.mult(-0.9);
    }
  }
  if (ballCollisionsOn) {
    if (isTouchingHoop(cir1, cir2)) {
      cir1.X = cir1.outsideShape.x;
      cir1.Y = cir1.outsideShape.y;
      cir2.X = cir2.outsideShape.x;
      cir2.Y = cir2.outsideShape.y;
      PVector temp = cir2.velocity;
      cir2.velocity = cir1.velocity;
      cir1.velocity = temp;
    }
    if (isTouchingHoop(cir2, cir3)) {
      cir3.X = cir3.outsideShape.x;
      cir3.Y = cir3.outsideShape.y;
      cir2.X = cir2.outsideShape.x;
      cir2.Y = cir2.outsideShape.y;
      PVector temp = cir3.velocity;
      cir3.velocity = cir2.velocity;
      cir2.velocity = temp;
    }
    if (isTouchingHoop(cir1, cir3)) {
      cir1.X = cir1.outsideShape.x;
      cir1.Y = cir1.outsideShape.y;
      cir3.X = cir3.outsideShape.x;
      cir3.Y = cir3.outsideShape.y;
      PVector temp = cir3.velocity;
      cir3.velocity = cir1.velocity;
      cir1.velocity = temp;
    }
  }
  //  // For adding more circles randomly on a timer
  //  if(frameCount % 600 == 0) {
  //      int size = (int)random(25,150);
  //      Circle cir2 = new Circle(random(100,1000), random(0,100), size, size);
  //      cir2.setStroke((int)random(255),(int)random(255),(int)random(255));  
  //      cir2.setStrokeWeight(5);
  //      cir2.setFill((int)random(255),(int)random(255),(int)random(255));
  //      shapes.add(cir2);
  //  }
  background(0);
  noFill();
  stroke(255);
  strokeWeight(5);
//  bezier(lx, ly, lx, (ly - ((3.0/18.0)*(rx - lx))), rx, (ry - ((3.0/18.0)*(rx - lx))), rx, ry);
  bezier(lx, ly, (lx - ((3.0/18.0)*(ry - ly))), (ly), (rx - ((3.0/18.0)*(ry - ly))), ry, rx, ry);
  // Show where the cursors are
  trackCursors();
  // Grabing it
  for (Circle cir : shapes) {
    
    // Check speeds
    if(cir.velocity.x > 50.0)
      cir.velocity.x = 50.0;
    if(cir.velocity.y > 50.0)
      cir.velocity.y = 50.0;
    if(cir.velocity.x < -50.0)
      cir.velocity.x = -50.0;
    if(cir.velocity.y < -50.0)
      cir.velocity.y = -50.0;
      
      
    cir.drawShape();
    if (cir.cursor != null) {
      // First time I grab it
      if (cir.x_dif == 0) {
        cir.setDifs(cir.X - cir.cursor.getX()*W, cir.Y - cir.cursor.getY()*H);
        cir.velocity.x = 0.0;
        cir.velocity.y = 0.0;
      }
      
      cir.velocity.x = cir.cursor.getXSpeed()*5;
      cir.velocity.y = cir.cursor.getYSpeed()*5;

      if (cir.cursor != null) {
        cir.X = cir.cursor.getX()*W + cir.x_dif;
        cir.Y = cir.cursor.getY()*H + cir.y_dif;
        cir.redrawShape();
      }
    }
    else {
      if(wentThroughHoop(cir)) {
      if(cir.equals(cir1)) {
        toggleGravity();
      }
      else if(cir.equals(cir2)) {
        toggleFriction();
      }
      else if(cir.equals(cir3)) {
        toggleBallCollisions();
      }
    }
      if (gravityOn) cir.velocity.add(GRAVITY);

      cir.outsideShape.x = cir.X;
      cir.outsideShape.y = cir.Y;
      cir.moveShape();
      // Top bound
      if (cir.Y <= 0) {
        cir.Y = 0;
        cir.velocity.y *= TOP_BOUNCE_BACK;
      }
      
      println("SPEED " + cir.velocity.y);

      PVector bl = new PVector(cir.X, cir.Y+cir.H);
      PVector tl = new PVector(cir.X, cir.Y);
      PVector tr = new PVector(cir.X+cir.W, cir.Y);
      PVector br = new PVector(cir.X+cir.H, cir.Y+cir.H);

      // Bottom bound
      if ((cir.Y + cir.H) >= H) {
        cir.Y = H - cir.H;
        cir.velocity.y *= BOTTOM_BOUNCE_BACK;
      }
      // Right bound
      if ((cir.X + cir.W) >= W) {
        cir.X = W - cir.W;
        cir.velocity.x *= RIGHT_BOUNCE_BACK;
        //                GRAVITY.x *= -1;
      }
      // Left bound
      if (cir.X <= 0) {
        cir.X = 0;
        cir.velocity.x *= LEFT_BOUNCE_BACK;
        //                GRAVITY.x *= -1;
      }
      // Ground static
      if (frictionOn) {
        if (gravityOn) {
          if ((cir.Y + cir.H) >= H && cir.velocity.y >= -1.0) {
            if (cir.velocity.x > 0)
              cir.velocity.x -= GROUND_FRICTION;
            else if (cir.velocity.x < 0)
              cir.velocity.x += GROUND_FRICTION;
          }
        }
        else {
          if (cir.velocity.x > 0.0) {
            cir.velocity.x -= GROUND_FRICTION;
          }
          else if (cir.velocity.x < 0.0) {
            cir.velocity.x += GROUND_FRICTION;
          }
          if (cir.velocity.y > 0.0) {
            cir.velocity.y -= GROUND_FRICTION;
          }
          else if (cir.velocity.y < 0.0) {
            cir.velocity.y += GROUND_FRICTION;
          }
        }
      }
    }
  }
//  bezier(lx, ly, lx, (ly + ((3.0/18.0)*(rx - lx))), rx, (ry + ((3.0/18.0)*(rx - lx))), rx, ry);
  bezier(lx, ly, (lx + ((3.0/18.0)*(ry - ly))), (ly), (rx + ((3.0/18.0)*(ry - ly))), ry, rx, ry);
  leftHoop.drawShape();
}

private void trackCursors() {
  for (int i = 0; i < cursors.size(); i++) {
    TuioCursor c = (TuioCursor)(cursors.elementAt(i));
    TuioPoint p = c.getPosition();
    float xpos = p.getX();
    float ypos = p.getY();
    ellipse(xpos*W, ypos*H, 20, 20);
    //    for(Circle cir : shapes) {
    //      float xmid = cir.middle.x;
    //      float ymid = cir.middle.y;
    //      if(xpos != xmid && ypos != ymid) {
    //        cir.velocity.x *= 1.0+((200.0 - abs(xpos - xmid)) / 200);
    //      }
    //    }
  }
}

private boolean isInsideShape(TuioCursor cur, Shape shape) {
  TuioPoint p = cur.getPosition();
  // In X bound
  if (p.getX()*W >= shape.X && p.getX()*W <= shape.X + shape.W) {
    if (p.getY()*H >= shape.Y && p.getY()*H <= shape.Y + shape.H) {
      return true;
    }
  }
  return false;
}

private boolean isTouchingHoop(Shape cir, Shape rim) {

  float lx1 = rim.X;
  float lx2 = (rim.X + rim.W);
  float lx3 = cir.X;
  float lx4 = (cir.X + cir.W);
  float ly1 = rim.Y;
  float ly2 = (rim.Y + rim.H);
  float ly3 = cir.Y;
  float ly4 = (cir.Y + cir.H);

  if (lx3 <= lx2 && lx4 >= lx1) {
    if (ly3 <= ly2 && ly4 >= ly1) {
      return true;
    }
  }
  return false;
}

private boolean wentThroughHoop(Shape c) {
//  if(c.X > lx && (c.X+c.W) < rx) {
//    if((c.Y+(c.H/2.0)) > (ly-1.0) && (c.Y+(c.H/2.0)) < (ry+1.0)) {
//      return true;
//    }
//  }
//  return false;
  if(c.Y > ly && (c.Y+c.H) < ry) {
    if((c.X+(c.W/2.0)) > (lx-2.0) && (c.X+(c.W/2.0)) < (rx+2.0)) {
      background(255);
      return true;
    }
  }
  return false;
  
}

private void setGravity(float xg, float yg) {
  GRAVITY.x = xg;
  GRAVITY.y = yg;
}

private void toggleGravity() {
  gravityOn = !gravityOn;
  if(gravityOn) {
    if((int)random(10) < 2)
      setGravity(random(-0.3,0.3),random(-0.4,0.4));
    else
      setGravity(0.0,random(-0.4,0.4));
  }
}

private void toggleBallCollisions() {
  BOTTOM_BOUNCE_BACK = random(-1.2,-0.5);
  TOP_BOUNCE_BACK = random(-1.2,-0.5);
  LEFT_BOUNCE_BACK = random(-1.2,-0.5);
  RIGHT_BOUNCE_BACK = random(-1.2,-0.5);
  ballCollisionsOn = !ballCollisionsOn;
}

private void toggleFriction() {
  GROUND_FRICTION = random(0.0025,0.0015);
  frictionOn = !frictionOn;
}

private void addGravity(float xg, float yg) {
  GRAVITY.x += xg;
  GRAVITY.y += yg;
}


// these callback methods are called whenever a TUIO event occurs

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  println("add object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  println("remove object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  println("update object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
    +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  cursors.add(tcur);
  for (Shape cir : shapes) {
    if (isInsideShape(tcur, cir)) {
      cir.cursor = tcur;
      break;
    }
  }
  println("add cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()*W+" "+tcur.getY()*H);
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  //  println("update cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
  //          +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  cursors.remove(tcur);
  for (Shape cir : shapes) {
    if (tcur.equals(cir.cursor)) {
      cir.cursor = null;
      cir.setDifs(0, 0);
    }
  }
  println("remove cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
}

// called after each message bundle
// representing the end of an image frame
void refresh(TuioTime bundleTime) { 
  redraw();
}

void keyPressed() {
  if (key == 'g') {
    toggleGravity();
  }
  else if (key == 'c') {
    toggleBallCollisions();
  }
  else if (key == 'f') {
    toggleFriction();
  }
}


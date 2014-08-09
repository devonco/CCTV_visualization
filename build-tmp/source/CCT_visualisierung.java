import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class CCT_visualisierung extends PApplet {

ArrayList pointList;
PFont font;
PImage bgImage;

String[] temp;
String[] temp2;
String[] lines;
String[] moves;
int fc;
int maxfc;

int n;
int x, x_, y, y_, id, id_; // variables for reading out coordinate list -> splitAssign() 
int r1, r2, g1, g2, b1, b2;
int alpha = 50;
int strokeWeight = 3;
int radius = 3;
int backgroundColor = 100;

PVector location;

//directions
Cell[][] grid;


ControlP5 cp5;

PrintWriter test;


public void setup()
{
  String[] frameNumber = loadStrings("framecount.txt");
  maxfc = Integer.parseInt(frameNumber[0]);
  lines = loadStrings("positions.txt");
  //moves = new String[0];
  background(backgroundColor);
  bgImage = loadImage("bgImage.jpg");

  pointList = new ArrayList();
  font = createFont("Arial", 16, true);

  size(bgImage.width, bgImage.height);
  image(bgImage, 0, 0);
  test = createWriter("test.txt");
  /* directions
   
   xRes = int(W/xParts);
   format = W/H;
   yParts = int(xParts/format+1);
   yRes = int(H/yParts);
   grid = new Cell[xParts][yParts];
   
   for (int i = 0; i < xParts; i++) {
   for (int j = 0; j < yParts; j++) {
   grid[i][j] = new Cell(i*xRes,j*yRes);
   }
   }*/


  // cp5 control

  cp5 = new ControlP5(this);

  // define tabs
  cp5.addTab("Paths")
    .setColorBackground(color(100, 200, 255))
      .setColorLabel(color(255))
        .setColorActive(color(255, 200, 100))
          ;
  cp5.addTab("Directions")
    .setColorBackground(color(100, 200, 255))
      .setColorLabel(color(255))
        .setColorActive(color(255, 200, 100))
          ;
  cp5.addTab("Density")
    .setColorBackground(color(100, 200, 255))
      .setColorLabel(color(255))
        .setColorActive(color(255, 200, 100))
          ;
    cp5.addTab("Tracing")
    .setColorBackground(color(100, 200, 255))
      .setColorLabel(color(255))
        .setColorActive(color(255, 200, 100))
          ;
  // set tab properties
  cp5.getTab("default")
    .hide()
      ;
  cp5.getTab("Paths")
    .activateEvent(true)
      .setId(2)
        ;
  cp5.getTab("Directions")
    .activateEvent(true)
      .setId(3)
        ;
  cp5.getTab("Density")
    .activateEvent(true)
      .setId(4)
        ;
  cp5.getTab("Tracing")
    .activateEvent(true)
      .setId(5)
        ;

  //create controllers
  cp5.addSlider("pThickness_")
    .setBroadcast(false)
      .setRange(0, 10)
        .setValue(3)
          .setPosition(5, 40)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("path thickness")
                  .setColorLabel(color(0))
                    ;
  cp5.addSlider("pAlpha_")
    .setBroadcast(false)
      .setRange(0, 255)
        .setValue(50)
          .setPosition(5, 70)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("path transparency")
                  .setColorLabel(color(0))
                    ;
  cp5.addBang("color1_")
    .setPosition(5, 100)
      .setSize(20, 20)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("moving to the left")
            .setColorLabel(color(0))
              ;
  cp5.addBang("color2_")
    .setPosition(5, 140)
      .setSize(20, 20)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("moving to the right")
            .setColorLabel(color(0))
              ;
  cp5.addSlider("gridSize_")
    .setBroadcast(false)
      .setRange(2, 25)
        .setValue(14)
          .setPosition(5, 70)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("cells in grid")
                  .setColorLabel(color(0))
                    ;
                    
   cp5.addSlider("dRadius_")
    .setBroadcast(false)
      .setRange(0, 5)
        .setValue(3)
          .setPosition(5, 40)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("circle radius")
                  .setColorLabel(color(0))
                    ;
  cp5.addSlider("dAlpha_")
    .setBroadcast(false)
      .setRange(0, 255)
        .setValue(50)
          .setPosition(5, 70)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("circle transparency")
                  .setColorLabel(color(0))
                    ;
  cp5.addBang("reset")
    .setPosition(5, 40)
      .setSize(20, 20)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("reset")
            .setColorLabel(color(0))
              ;

  //arrange controllers in Tabs
  cp5.getController("pThickness_").moveTo("Paths");
  cp5.getController("pAlpha_").moveTo("Paths");
  cp5.getController("color1_").moveTo("Paths");
  cp5.getController("color2_").moveTo("Paths");
  cp5.getController("gridSize_").moveTo("Directions");
  cp5.getController("dRadius_").moveTo("Density");
  cp5.getController("dAlpha_").moveTo("Density");
  cp5.getController("reset").moveTo("Tracing");
}

public void draw() 
{
}

public void splitAssign(int i) {
  String[] temp = split(lines[i], ',');
  id_ = id;
  id = PApplet.parseInt(temp[0]);
  x_ = x;
  y_ = y;
  x = PApplet.parseInt(temp[1]);
  y = PApplet.parseInt(temp[2]);
  fc = PApplet.parseInt(temp[3]);
  location = new PVector(x, y);
}

public void drawPaths(int r1, int g1, int b1, int r2, int g2, int b2, int alpha)
{ 
  for (int i = 0; i < lines.length; ++i)
  {
    splitAssign(i);
    if (id == id_)
    { 
      if (x_-x>0) stroke(r1, g1, b1, alpha); 
      else stroke(r2, g2, b2, alpha); //rgb(1)a moving left --- rgb(2)a moving right
      line(x_, y_, x, y);
    }
    //println(location.x,location.y);
    //textFont(f,10);
    //fill(255,0,0);
    //text(id, location.x, location.y);
    n++;
  }
}

public void drawDirections()
{
  xRes = PApplet.parseInt(W/xParts);
  format = W/H;
  yParts = PApplet.parseInt(xParts/format+1);
  yRes = PApplet.parseInt(H/yParts);
  grid = new Cell[xParts][yParts];

  for (int i = 0; i < xParts; i++) {
    for (int j = 0; j < yParts; j++) {
      grid[i][j] = new Cell(i*xRes, j*yRes);
    }
  }

  for (int i = 0; i < xParts; i++) {
    for (int j = 0; j < yParts; j++) {
      int zCount_ = 0;
      for (int l = 0; l < lines.length; ++l)
      {
        splitAssign(l);
        if (grid[i][j].isInCell(x, y))
        {
          PVector loc = new PVector(x, y);
          PVector loc_ = new PVector(x_, y_);
          PVector dir = loc;
          dir.sub(loc_);
          grid[i][j].averageDir.add(dir);
          zCount_ ++;
          grid[i][j].averageDir.limit(xRes/2);
        }
      }

      grid[i][j].zCount = zCount_;
      grid[i][j].display();
    }
  }
}

public void drawDensity()
{
  for (int i = 0; i < lines.length; ++i)
  {
    splitAssign(i);
  /*
    textFont(font, 10);  // ersetzen durch ellipse mit radius + slider
    fill(255, 0, 0);
    text("O", location.x, location.y);
    */
    noFill();
    stroke(100, 255, 200, alpha); 
    strokeWeight(1);
    ellipseMode(CENTER);
    ellipse(location.x, location.y, radius*2, radius*2);
    
  }
}

public void drawTraces()
{
  tracing();
  //println(maxfc);


}

// control events

public void drPath() 
{
  image(bgImage, 0, 0);
  strokeWeight(strokeWeight);
  drawPaths(200, 255, 100, 100, 255, 200, alpha);
}

public void pThickness_(int t) {
  strokeWeight = t;
  drPath();
}

public void pAlpha_(int a) {
  alpha = a;
  drPath();
}

public void drDirection()
{
  image(bgImage, 0, 0);

  drawDirections(); // execute code for vector analysis
}

public void gridSize_(int x) {
  xParts = x;
  drDirection();
}

public void dRadius_(int x){
  radius = x;
  drDensity();
}

public void dAlpha_(int a){
  alpha = a;
  drDensity();
}

public void drDensity()
{
  image(bgImage, 0, 0);
  drawDensity(); // execute code for vector analysis
}

public void drTraces()
{
  image(bgImage, 0, 0);
  strokeWeight(1);
  drawTraces();
}

public void controlEvent(ControlEvent theEvent) {
  if (theEvent.isTab()) {
    if (theEvent.getTab().getId() == 2) {
      background(backgroundColor); 
      drPath();
    }
    if (theEvent.getTab().getId() == 3) {
      background(backgroundColor); 
      drDirection();
    }
    if (theEvent.getTab().getId() == 4) {
      background(backgroundColor); 
      drDensity();
    }
    if (theEvent.getTab().getId() == 5) {
      background(backgroundColor); 
      drTraces();
    }
  } else {
    println(
    "## controlEvent / id:"+theEvent.controller().id()+
      " / name:"+theEvent.controller().name()+
      " / label:"+theEvent.controller().label()+
      " / value:"+theEvent.controller().value()
      );
  }
}


public void delay(int t)
{
  int time = millis();
  while (millis () - time <= t);
}

class Cell
{
  PVector center;
  PVector location;
  PVector averageDir = new PVector(0,0);
  int zCount = 0;
  ArrayList <PVector> directions = new ArrayList <PVector>();
  
  Cell(int x_, int y_)
  {
    location = new PVector(x_, y_);
    center = new PVector(x_+xRes/2, y_+yRes/2);
  }
  
  public void display()
  {
    stroke(100, 255, 200, 75);
    strokeWeight(1);
    noFill();
    rect(location.x,location.y,xRes,yRes);
    stroke(200, 255, 100);
    noFill();
    ellipseMode(CENTER);
    //ellipse(center.x, center.y, 2, 2);
    pushMatrix();
    translate(center.x,center.y);
    strokeWeight(2); // map(dCount,0,100,1,5)
    line(0,0,averageDir.x, averageDir.y);
    ellipse(averageDir.x, averageDir.y, 2, 2);
    popMatrix();
  }
  
  public void drawArrow(int x1_, int x2_, int y1_, int y2_)
  {
    
  }
  
  public boolean isInCell(int x_, int y_)
  {
    if (x_ > location.x && x_ <= location.x+xRes && y_ > location.y && y_ <= location.y+yRes) return true;
    else return false;
  }
}
int xParts = 14;
int yParts;
int xRes;
int yRes;
float format;

float W = 700.0f;
float H = 394.0f;

//    in setup:

//    xRes = W/xParts;
//    format = W/H;
//    yParts = int(xParts/format+1);

public void raster()
{
  println();
  loadPixels();
  for (int x=0;x<width;x++)
  {
    for (int y=0;y<height;y++)
    {
      int loc = x + y*width;
      //if(x%xRes == 0) pixels[loc] = color(0);
      //else if(y%xRes == 0) pixels[loc] = color(0);
      //else pixels[loc] = color(255);
      //if(x<xRes*2 && x>xRes && y>xRes*6 && y<xRes*7) pixels[loc] = color(100);
      
    }
  }
  updatePixels();
}
public void tracing()
{
	moves = new String[0];
	for (int cf = 0; cf < maxfc; cf++)
	{
	  for (int i = 0; i < lines.length; ++i)
	
  {
    String[] temp2 = split(lines[i], ',');
    fc = PApplet.parseInt(temp2[3]);
    if (fc==cf)
    {
    	moves = append(moves, lines[i]);
    	//println("eins");
    }
   		
  }
  }	
  println(moves.length);
  	for(x=0; x<moves.length;x++)
  	{
  		test.println(moves[x]);
  		println("wink");
  	}
  test.flush();
  test.close();
 }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "CCT_visualisierung" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

ArrayList pointList;
PFont font;
PImage bgImage;

String[] temp;
String[] lines;

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

import controlP5.*;
ControlP5 cp5;


void setup()
{

  lines = loadStrings("positions.txt");
  background(backgroundColor);
  bgImage = loadImage("bgImage.jpg");

  pointList = new ArrayList();
  font = createFont("Arial", 16, true);

  size(bgImage.width, bgImage.height);
  image(bgImage, 0, 0);

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

void draw() 
{
}

void splitAssign(int i) {
  String[] temp = split(lines[i], ',');
  id_ = id;
  id = int(temp[0]);
  x_ = x;
  y_ = y;
  x = int(temp[1]);
  y = int(temp[2]);
  location = new PVector(x, y);
}

void drawPaths(int r1, int g1, int b1, int r2, int g2, int b2, int alpha)
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

void drawDirections()
{
  xRes = int(W/xParts);
  format = W/H;
  yParts = int(xParts/format+1);
  yRes = int(H/yParts);
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

void drawDensity()
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

void drawTraces()
{
  tracing();
}

// control events

void drPath() 
{
  image(bgImage, 0, 0);
  strokeWeight(strokeWeight);
  drawPaths(200, 255, 100, 100, 255, 200, alpha);
}

void pThickness_(int t) {
  strokeWeight = t;
  drPath();
}

void pAlpha_(int a) {
  alpha = a;
  drPath();
}

void drDirection()
{
  image(bgImage, 0, 0);

  drawDirections(); // execute code for vector analysis
}

void gridSize_(int x) {
  xParts = x;
  drDirection();
}

void dRadius_(int x){
  radius = x;
  drDensity();
}

void dAlpha_(int a){
  alpha = a;
  drDensity();
}

void drDensity()
{
  image(bgImage, 0, 0);
  drawDensity(); // execute code for vector analysis
}

void drTraces()
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


void delay(int t)
{
  int time = millis();
  while (millis () - time <= t);
}


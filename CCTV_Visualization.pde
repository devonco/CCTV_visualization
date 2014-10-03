ArrayList pointList;
PFont font;
PImage bgImage;

//arrays for processing positions.txt
String[] temp;
String[] temp2;
String[] temp3;
String[] lines;
String[] speedLines;

int n;
int x, x_, y, y_, id, id_; // variables for reading out coordinate list -> splitAssign() 
int r1, r2, g1, g2, b1, b2; //variables for pathcolors
int alpha = 50;
int strokeWeight = 3;
int radius = 3;
int backgroundColor = 100;
int activeTab = 0;

PVector location;

import controlP5.*;
ControlP5 cp5;



// Interface based on controlp5-Library

void setup()
{
  String[] frameNumber = loadStrings("framecount.txt");
  maxfc = Integer.parseInt(frameNumber[0]);
  lines = loadStrings("positions.txt");
  speedLines = loadStrings("speed.txt");
  background(backgroundColor);
  bgImage = loadImage("bgImage.jpg");

  pointList = new ArrayList();
  font = createFont("Arial", 16, true);

  size(bgImage.width, bgImage.height, P3D);
  image(bgImage, 0, 0);
  personsTotal = new IntList();

  // cp5 interface control

  cp5 = new ControlP5(this);

  // define tabs
  cp5.addTab("Paths")
    .setColorBackground(color(100, 200, 255))
      .setColorLabel(color(255))
        .setColorActive(color(255, 0, 0))
          ;
  cp5.addTab("Directions")
    .setColorBackground(color(100, 200, 255))
      .setColorLabel(color(255))
        .setColorActive(color(255, 0, 0))
          ;
  cp5.addTab("Density")
    .setColorBackground(color(100, 200, 255))
      .setColorLabel(color(255))
        .setColorActive(color(255, 0, 0))
          ;
    cp5.addTab("Tracing")
    .setColorBackground(color(100, 200, 255))
      .setColorLabel(color(255))
        .setColorActive(color(255, 0, 0))
          ;
    cp5.addTab("3D Map")
    .setColorBackground(color(100, 200, 255))
      .setColorLabel(color(255))
        .setColorActive(color(255, 0, 0))
          ;

          cp5.window().setPositionOfTabs(width/2-70,0);
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
  cp5.getTab("3D Map")
    .activateEvent(true)
      .setId(6)
        ;

  //create controllers
  cp5.addSlider("pThickness_")
    .setBroadcast(false)
      .setRange(0, 10)
        .setValue(3)
          .setPosition(5, 70)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("path thickness")
                  .setColorLabel(color(255))
                    ;
  cp5.addSlider("pAlpha_")
    .setBroadcast(false)
      .setRange(0, 255)
        .setValue(50)
          .setPosition(5, 100)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("path transparency")
                  .setColorLabel(color(255))
                    ;
  /* cp5.addBang("color1_")
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
              ; */
  cp5.addSlider("gridSize_")
    .setBroadcast(false)
      .setRange(2, 40)
        .setValue(14)
          .setPosition(5, 70)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("cells in grid")
                  .setColorLabel(color(255))
                    ;
                    
   cp5.addSlider("dRadius_")
    .setBroadcast(false)
      .setRange(0, 5)
        .setValue(3)
          .setPosition(5, 40)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("circle radius")
                  .setColorLabel(color(255))
                    ;
  cp5.addSlider("dAlpha_")
    .setBroadcast(false)
      .setRange(0, 255)
        .setValue(50)
          .setPosition(5, 70)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("circle transparency")
                  .setColorLabel(color(255))
                    ;
  cp5.addBang("resetTraces")
    .setPosition(5, 40)
      .setSize(20, 20)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("reset")
            .setColorLabel(color(255))
              ;
  cp5.addSlider("mapGridSize_")
    .setBroadcast(false)
      .setRange(10, 80)
        .setValue(40)
          .setPosition(5, 70)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("Cells in Grid")
                  .setColorLabel(color(255))
                    ;
  cp5.addSlider("rotationSpeed_")
    .setBroadcast(false)
      .setRange(0.25, -0.25)
        .setValue(0)
          .setPosition(5, 100)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("Rotation Speed")
                  .setColorLabel(color(255))
                    ;
  cp5.addSlider("transparency_")
    .setBroadcast(false)
      .setRange(0, 100)
        .setValue(80)
          .setPosition(5, 130)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("Transparency")
                  .setColorLabel(color(255))
                    ;
  cp5.addButton("density_")
      .setPosition(5,160)
        .setSize(100,20)
          .setLabel("Density")
            ;
  cp5.addButton("speed_")
      .setPosition(5,190)
        .setSize(100,20)
          .setLabel("Speed")
            ;

  //arrange controllers in Tabs
  cp5.getController("pThickness_").moveTo("Paths");
  cp5.getController("pAlpha_").moveTo("Paths");
  //cp5.getController("color1_").moveTo("Paths");
  //cp5.getController("color2_").moveTo("Paths");
  cp5.getController("gridSize_").moveTo("Directions");
  cp5.getController("dRadius_").moveTo("Density");
  cp5.getController("dAlpha_").moveTo("Density");
  cp5.getController("resetTraces").moveTo("Tracing");
  cp5.getController("mapGridSize_").moveTo("3D Map");
  cp5.getController("rotationSpeed_").moveTo("3D Map");
  cp5.getController("transparency_").moveTo("3D Map");
  cp5.getController("density_").moveTo("3D Map");
  cp5.getController("speed_").moveTo("3D Map");

timeCount = millis();
paths = new ArrayList <Path>();
frameRate(60);
} //e.o. setup

// processing data from positions.txt, by splitting every line into an array of substrings //
void splitAssign(int i) {
  temp = split(lines[i], ',');
  id_ = id;
  id = int(temp[0]);
  x_ = x;
  y_ = y;
  x = int(temp[1]);
  y = int(temp[2]);
  fc = int(temp[3]);
  location = new PVector(x, y);
}

void splitAssignSpeed(int i) {
  temp = split(speedLines[i], ',');
  id_ = id;
  id = int(temp[0]);
  x_ = x;
  y_ = y;
  x = int(temp[1]);
  y = int(temp[2]);
  sp = int(temp[3]);
  location = new PVector(x, y);
}



// control events for interfacecontrols
void drPath() 
{
  click=false;
  mapView = false;
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
  click=false;
  mapView = false;
  image(bgImage, 0, 0);
  drawDirections();
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
  click=false;
  mapView = false;
  image(bgImage, 0, 0);
  drawDensity();
}

void drTraces()
{
  mapView = false;
  image(bgImage, 0, 0);
  strokeWeight(1);
  drawTraces();
}

void dr3DMap()
{
  click=false;
  if(densityView){setDensityGrid();}
  if(speedView){setSpeedGrid();}
  mapView = true;
}

void mapGridSize_(int x) {
  xPartsM = x;
  dr3DMap();
}

void rotationSpeed_(float s){
  rotSpeed = s;
}

void transparency_(int t){
  transparency = t;
}

void density_(){
  densityView = true;
  speedView = false;
  setDensityGrid();
}

void speed_(){
  densityView = false;
  speedView = true;
  setSpeedGrid();
}

public void controlEvent(ControlEvent theEvent) {
  if (theEvent.isTab()) {
    if (theEvent.getTab().getId() == 2) {
      background(backgroundColor); 
      drPath();
      activeTab = 2;
    }
    if (theEvent.getTab().getId() == 3) {
      background(backgroundColor); 
      drDirection();
      activeTab = 3;
    }
    if (theEvent.getTab().getId() == 4) {
      background(backgroundColor); 
      drDensity();
      activeTab = 4;
    }
    if (theEvent.getTab().getId() == 5) {
      background(backgroundColor); 
      drTraces();
      activeTab = 5;
    }
    if (theEvent.getTab().getId() == 6) {
      background(backgroundColor); 
      dr3DMap();
      activeTab = 6;
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

void arrow(int direction, int r, int g, int b, int bw, int a)
{
  int baseX = 0;
  int baseY = 0;
  float angle = 0;
  switch(direction) {
  case 0: 
    baseX = 30;
    baseY = 30;
    angle = -HALF_PI/2;
    break;
  case 1: 
    baseX = width-30;
    baseY = 30;
    angle = HALF_PI/2;
    break;
  case 2: 
    baseX = width-30;
    baseY = height-30;
    angle = HALF_PI*1.5;
    break;
  case 3: 
    baseX = 30;
    baseY = height-30;
    angle = HALF_PI*2.5;
    break;
}
pushMatrix();
translate(baseX,baseY);
rotate(angle);
strokeWeight(8);
stroke(bw,bw,bw);
line (0,-9,9,0);
line (0,-9,-9,0);
strokeWeight(4);
stroke(r,g,b);
line (0,-9,9,0);
line (0,-9,-9,0);
popMatrix();
}



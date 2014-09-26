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

public class CCTV_Visualization extends PApplet {

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

PVector location;


ControlP5 cp5;



// Interface based on controlp5-Library

public void setup()
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
                  .setColorLabel(color(0))
                    ;
  cp5.addSlider("pAlpha_")
    .setBroadcast(false)
      .setRange(0, 255)
        .setValue(50)
          .setPosition(5, 100)
            .setSize(100, 20)
              .setBroadcast(true)
                .setLabel("path transparency")
                  .setColorLabel(color(0))
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
  cp5.addBang("resetTraces")
    .setPosition(5, 40)
      .setSize(20, 20)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("reset")
            .setColorLabel(color(0))
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
      .setRange(0.25f, -0.25f)
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
public void splitAssign(int i) {
  temp = split(lines[i], ',');
  id_ = id;
  id = PApplet.parseInt(temp[0]);
  x_ = x;
  y_ = y;
  x = PApplet.parseInt(temp[1]);
  y = PApplet.parseInt(temp[2]);
  fc = PApplet.parseInt(temp[3]);
  location = new PVector(x, y);
}

public void splitAssignSpeed(int i) {
  temp = split(speedLines[i], ',');
  id_ = id;
  id = PApplet.parseInt(temp[0]);
  x_ = x;
  y_ = y;
  x = PApplet.parseInt(temp[1]);
  y = PApplet.parseInt(temp[2]);
  sp = PApplet.parseInt(temp[3]);
  location = new PVector(x, y);
}



// control events for interfacecontrols
public void drPath() 
{
  click=false;
  mapView = false;
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
  click=false;
  mapView = false;
  image(bgImage, 0, 0);
  drawDirections();
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
  click=false;
  mapView = false;
  image(bgImage, 0, 0);
  drawDensity();
}

public void drTraces()
{
  mapView = false;
  image(bgImage, 0, 0);
  strokeWeight(1);
  drawTraces();
}

public void dr3DMap()
{
  click=false;
  if(densityView){setDensityGrid();}
  if(speedView){setSpeedGrid();}
  mapView = true;
}

public void mapGridSize_(int x) {
  xPartsM = x;
  dr3DMap();
}

public void rotationSpeed_(float s){
  rotSpeed = s;
}

public void transparency_(int t){
  transparency = t;
}

public void density_(){
  densityView = true;
  speedView = false;
  setDensityGrid();
}

public void speed_(){
  densityView = false;
  speedView = true;
  setSpeedGrid();
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
    if (theEvent.getTab().getId() == 6) {
      background(backgroundColor); 
      dr3DMap();
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

public void arrow(int direction, int r, int g, int b, int bw, int a)
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
    angle = HALF_PI*1.5f;
    break;
  case 3: 
    baseX = 30;
    baseY = height-30;
    angle = HALF_PI*2.5f;
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
public void drawDensity()
{
  for (int i = 0; i < lines.length; ++i)
  {
    splitAssign(i);
    noFill();
    stroke(100, 255, 200, alpha); 
    strokeWeight(1);
    ellipseMode(CENTER);
    ellipse(location.x, location.y, radius*2, radius*2);
    
  }
}
int xParts = 14;
int yParts;
int xRes;
int yRes;
float format;

Cell[][] grid;

float W = 1200;
float H = 674;

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
      
    }
  }
  updatePixels();
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
  
  public boolean isInCell(int x_, int y_)
  {
    if (x_ > location.x && x_ <= location.x+xRes && y_ > location.y && y_ <= location.y+yRes) return true;
    else return false;
  }
}
// draw loop is only used for tracing animation and 3D map rotation

public void draw() 
{
  //Tracing animation
  if(click){
      temp3 = split(moves[zett], ',');
      int id = PApplet.parseInt(temp3[0]);
      int x = PApplet.parseInt(temp3[1]);
      int y = PApplet.parseInt(temp3[2]);
      if (personsTotal.hasValue(id))
      {
        int place = checkPlace(id);
        Path p = paths.get(place);
        p.update(x,y);
        
      } else {
      personsTotal.append(id);
      paths.add(new Path(id));
      }
      drawTr();

  if (millis ()- timeCount >= 2) {
      timeCount = millis();
      zett++;
  }
  if (zett==moves.length){ click=false; zett=0;personsTotal.clear();paths = new ArrayList <Path>();}
  }

  //3D density map
  if(mapView)
  {
    background(0);
    pushMatrix();
    translate(width/2, height/2);
    rotateX(radians(rotX));
    rotateZ(radians(rotZ));
    scale(zoom);

    translate(-width/2, -height/2, 0);
    image(bgImage, 0, 0);
    translate(0, 0, -1);
    
    if (densityView) {
      for (int i = 0; i < xPartsM; i++) {
        for (int j = 0; j < yPartsM; j++) {
          meshGrid[i][j].displayDensity();
        }
      } 
    }
    if (speedView) {
      for (int i = 0; i < xPartsM; i++) {
        for (int j = 0; j < yPartsM; j++) {
          meshGrid[i][j].displaySpeed();
        }
      } 
    }

    popMatrix();
    rotZ += rotSpeed;
  }
} //e.o. draw
int xPartsM = 40;
int yPartsM;
int xResM;
int yResM;
float formatM;

int idMax;
int sp;
float speedMax;

float rotX = 45;
float rotZ = 10;
float rotSpeed =0;
float zoom = 0.6f;
int transparency = 80;

boolean mapView = false;
boolean densityView = true;
boolean speedView  = false;

MapCell[][] meshGrid;


public void mouseDragged() {
  if (mouseButton == LEFT) {
    rotX -= PApplet.parseFloat(mouseY-pmouseY) * 80/ height;
    rotZ -= PApplet.parseFloat(mouseX-pmouseX) * 200/ width;
  }
  if (mouseButton == RIGHT) {
    zoom -= PApplet.parseFloat(mouseY-pmouseY) / height;
  }
}

public void setDensityGrid()
{
  xResM = PApplet.parseInt(W/xPartsM);
  formatM = W/H;
  yPartsM = PApplet.parseInt(xPartsM/formatM+1);
  yResM = PApplet.parseInt(H/yPartsM);
  meshGrid = new MapCell[xPartsM][yPartsM];

  for (int i = 0; i < xPartsM; i++) {
    for (int j = 0; j < yPartsM; j++) {
      meshGrid[i][j] = new MapCell(i*xResM, j*yResM);
    }
  } 

  for (int i = 0; i < xPartsM; i++) {
    for (int j = 0; j < yPartsM; j++) {
      for (int l = 0; l < lines.length; ++l)
      {
        splitAssign(l);
        if (meshGrid[i][j].isInCell(x, y))
        {
          if(meshGrid[i][j].idList.hasValue(id)==true){ continue; }
          else{ meshGrid[i][j].idList.append(id); }
        }
      }
      //println("Cellposition X: "+i+" Y: "+j+" "+meshGrid[i][j].idList);
      if (idMax < meshGrid[i][j].idList.size()) {
        idMax = meshGrid[i][j].idList.size();
      }
    }
  }
}

public void setSpeedGrid()
{
  xResM = PApplet.parseInt(W/xPartsM);
  formatM = W/H;
  yPartsM = PApplet.parseInt(xPartsM/formatM+1);
  yResM = PApplet.parseInt(H/yPartsM);
  meshGrid = new MapCell[xPartsM][yPartsM];

  for (int i = 0; i < xPartsM; i++) {
    for (int j = 0; j < yPartsM; j++) {
      meshGrid[i][j] = new MapCell(i*xResM, j*yResM);
    }
  } 

  for (int i = 0; i < xPartsM; i++) {
    for (int j = 0; j < yPartsM; j++) {
      int magnitudes = 0;
      int counter = 0;
      for (int l = 0; l < speedLines.length; ++l)
      {
        splitAssignSpeed(l);
        if (meshGrid[i][j].isInCell(x, y))
        {
          magnitudes += sp;
          counter++;
        }
      }
      if(counter != 0){
        meshGrid[i][j].averageSpeed = magnitudes/counter;
      }
      if (speedMax < meshGrid[i][j].averageSpeed) {
        speedMax = meshGrid[i][j].averageSpeed;
      }
    }
  }
}


class MapCell
{
  PVector center;
  PVector location;
  int zCount = 0;
  int averageSpeed;
  IntList idList = new IntList();
  
  MapCell(int x_, int y_)
  {
    location = new PVector(x_, y_);
    center = new PVector(x_+xResM/2, y_+yResM/2);
  }
  
  public void displayDensity()
  {
    stroke(100, 255, 200, 75);
    strokeWeight(1);
    noFill();
    rect(location.x,location.y,xResM,yResM);

    pushMatrix();
    colorMode(RGB,idMax,idMax,idMax,100);
    translate(center.x, center.y, (idList.size()*4)/2);
    noStroke();
    //stroke(100, 255, 200, 50);
    //strokeWeight(2);
    fill(idList.size(),idMax-idList.size(),0,transparency);
    box(xResM, yResM, idList.size()*4);
    popMatrix();
    colorMode(RGB,255);
  }

  public void displaySpeed()
  {
    stroke(100, 255, 200, 75);
    strokeWeight(1);
    noFill();
    rect(location.x,location.y,xResM,yResM);

    pushMatrix();
    colorMode(RGB,speedMax,speedMax,speedMax,100);
    translate(center.x, center.y, (averageSpeed*4)/2);
    noStroke();
    fill(averageSpeed,speedMax-averageSpeed,0,transparency);
    box(xResM, yResM, averageSpeed*4);
    popMatrix();
    colorMode(RGB,255);
  }
  
  public boolean isInCell(int x_, int y_)
  {
    if (x_ > location.x && x_ <= location.x+xResM && y_ > location.y && y_ <= location.y+yResM) return true;
    else return false;
  }
}
public void drawPaths(int r1, int g1, int b1, int r2, int g2, int b2, int alpha)
{ 
  for (int i = 0; i < lines.length; ++i)
  {
    splitAssign(i);
    if (id == id_)
    { 
      if (x_-x>0 && y_-y>0) stroke(r1, g1, b1, alpha); 
      else if (x_-x<=0 && y_-y>0) stroke(r2, g2, b2, alpha); //rgb(1)a moving left --- rgb(2)a moving right
      else if (x_-x>0 && y_-y<=0) stroke(250, 50, 50, alpha);
      else stroke(250, 200, 200, alpha);
      line(x_, y_, x, y);
    }
    n++;
  }
  /*noStroke();
  fill (200, 255, 100, alpha);
  ellipse(20,20,40,40);
  fill (100, 255, 200, alpha);
  ellipse(width-20,20,40,40);
  fill (250, 50, 50, alpha);
  ellipse(20,height-20,40,40);
  fill (250, 200, 200, alpha);
  ellipse(width-20,height-20,40,40);*/

  strokeWeight(4);
arrow(0,200,255,100, 255, alpha); //topleft
arrow(1,100,255,200, 255, alpha); //topright
arrow(2,250,200,200, 255, alpha); //bottomright
arrow(3,250,50,50, 255, alpha); //bottomleft 
}
String[] moves;
int fc;
int maxfc;
IntList personsTotal;
ArrayList <Path> paths;
PVector lWp, cWp;

boolean click=false;
int border=2;
int timeCount;
int zett=0;

public void sortMoves()
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
    }
   		
  }
  }
 }

 class Path
{
  int pId;
  ArrayList <PVector> waypoints = new ArrayList <PVector>();

  Path(int id_)
  {
    pId = id_;
  }

  public void update(int x, int y)
  {
    waypoints.add(new PVector(x,y));
  }

  public void drawTs()
  {
    for (int wp=0;wp<waypoints.size();wp++)
    {
      if(wp>0) {lWp = cWp.get();}
      cWp = waypoints.get(wp);
      if(wp>0) line(lWp.x,lWp.y,cWp.x,cWp.y);
    }
  }
}//e.o.class.Path

public void resetTraces()
{
 image(bgImage, 0, 0);
 zett=0;
 paths = new ArrayList <Path>();
 personsTotal.clear();
 click=true;
} //e.o.void

public int checkPlace(int id)
{
  int position = -1;
  for (int z=0; z<personsTotal.size();z++)
  {
    int a = personsTotal.get(z);
    if (id==a)
      { 
        position = z;
        break;
      }
  }
   return(position);
}

public void drawTr()
{
  for (int p=0;p<paths.size();p++)
  {
    Path cp = paths.get(p);
    cp.drawTs();
 
  }
}

public void drawTraces()
{
  sortMoves();
  stroke(200, 255, 100); 
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "CCTV_Visualization" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

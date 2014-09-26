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
float zoom = 0.6;
int transparency = 80;

boolean mapView = false;
boolean densityView = true;
boolean speedView  = false;

MapCell[][] meshGrid;


void mouseDragged() {
  if (mouseButton == LEFT) {
    rotX -= float(mouseY-pmouseY) * 80/ height;
    rotZ -= float(mouseX-pmouseX) * 200/ width;
  }
  if (mouseButton == RIGHT) {
    zoom -= float(mouseY-pmouseY) / height;
  }
}

void setDensityGrid()
{
  xResM = int(W/xPartsM);
  formatM = W/H;
  yPartsM = int(xPartsM/formatM+1);
  yResM = int(H/yPartsM);
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

void setSpeedGrid()
{
  xResM = int(W/xPartsM);
  formatM = W/H;
  yPartsM = int(xPartsM/formatM+1);
  yResM = int(H/yPartsM);
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
  
  void displayDensity()
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

  void displaySpeed()
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
  
  boolean isInCell(int x_, int y_)
  {
    if (x_ > location.x && x_ <= location.x+xResM && y_ > location.y && y_ <= location.y+yResM) return true;
    else return false;
  }
}
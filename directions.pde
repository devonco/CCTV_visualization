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

void raster()
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
  
  void display()
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
  
  boolean isInCell(int x_, int y_)
  {
    if (x_ > location.x && x_ <= location.x+xRes && y_ > location.y && y_ <= location.y+yRes) return true;
    else return false;
  }
}
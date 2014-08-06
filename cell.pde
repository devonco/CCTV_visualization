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
  
  void drawArrow(int x1_, int x2_, int y1_, int y2_)
  {
    
  }
  
  boolean isInCell(int x_, int y_)
  {
    if (x_ > location.x && x_ <= location.x+xRes && y_ > location.y && y_ <= location.y+yRes) return true;
    else return false;
  }
}
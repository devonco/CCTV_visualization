void drawDensity()
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
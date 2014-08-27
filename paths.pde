void drawPaths(int r1, int g1, int b1, int r2, int g2, int b2, int alpha)
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
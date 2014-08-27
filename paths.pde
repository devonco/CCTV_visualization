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
    n++;
  }
}
int xParts = 14;
int yParts;
int xRes;
int yRes;
float format;

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
      //if(x%xRes == 0) pixels[loc] = color(0);
      //else if(y%xRes == 0) pixels[loc] = color(0);
      //else pixels[loc] = color(255);
      //if(x<xRes*2 && x>xRes && y>xRes*6 && y<xRes*7) pixels[loc] = color(100);
      
    }
  }
  updatePixels();
}

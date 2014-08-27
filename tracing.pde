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

void sortMoves()
{
	moves = new String[0];
	for (int cf = 0; cf < maxfc; cf++)
	{
	  for (int i = 0; i < lines.length; ++i)
	
  {
    String[] temp2 = split(lines[i], ',');
    fc = int(temp2[3]);
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

  void update(int x, int y)
  {
    waypoints.add(new PVector(x,y));
  }

  void drawTs()
  {
    for (int wp=0;wp<waypoints.size();wp++)
    {
      if(wp>0) {lWp = cWp.get();}
      cWp = waypoints.get(wp);
      if(wp>0) line(lWp.x,lWp.y,cWp.x,cWp.y);
    }
  }
}//e.o.class.Path

void resetTraces()
{
 image(bgImage, 0, 0);
 click=true;
} //e.o.void

int checkPlace(int id)
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

void drawTr()
{
  for (int p=0;p<paths.size();p++)
  {
    Path cp = paths.get(p);
    cp.drawTs();
 
  }
}

void drawTraces()
{
  sortMoves();
  stroke(200, 255, 100); 
}

// draw-void only used for tracing-animation
void draw() 
{

if(click){
    temp3 = split(moves[zett], ',');
    int id = int(temp3[0]);
    int x = int(temp3[1]);
    int y = int(temp3[2]);
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

if (millis ()- timeCount >= 5) {
    timeCount = millis();
    zett++;
}
if (zett==moves.length){ click=false; zett=0;personsTotal.clear();paths = new ArrayList <Path>();}
}
} //e.o. draw

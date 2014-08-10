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
    	//println("eins");
    }
   		
  }
  }	
  println(moves.length);
  	for(x=0; x<moves.length;x++)
  	{
  		test.println(moves[x]);
  	}
  test.flush();
  test.close();
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
 //border=1;
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

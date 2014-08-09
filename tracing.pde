void tracing()
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

// draw loop is only used for tracing animation and 3D map rotation

void draw() 
{
  //Tracing animation
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

  if (millis ()- timeCount >= 2) {
      timeCount = millis();
      zett++;
  }
  if (zett==moves.length){ click=false; zett=0;personsTotal.clear();paths = new ArrayList <Path>();}
  }

  //3D density map
  if(mapView)
  {
    background(0);
    pushMatrix();
    translate(width/2, height/2);
    rotateX(radians(rotX));
    rotateZ(radians(rotZ));
    scale(zoom);

    translate(-width/2, -height/2, 0);
    image(bgImage, 0, 0);
    translate(0, 0, -1);
    
    if (densityView) {
      for (int i = 0; i < xPartsM; i++) {
        for (int j = 0; j < yPartsM; j++) {
          meshGrid[i][j].displayDensity();
        }
      } 
    }
    if (speedView) {
      for (int i = 0; i < xPartsM; i++) {
        for (int j = 0; j < yPartsM; j++) {
          meshGrid[i][j].displaySpeed();
        }
      } 
    }

    popMatrix();
    rotZ += rotSpeed;
  }
} //e.o. draw
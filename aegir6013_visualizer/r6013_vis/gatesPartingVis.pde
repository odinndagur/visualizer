void gatesPartingVis(){
  
  //HALF SPECTRUM STARTS IN CENTER
  for (int i = 0; i < spectrumArray.length; i++) {
    beginShape();
    for (int j = 0; j < spectrumArray[0].length; j++) {
      stroke(0, map(i, 0, spectrumArray.length, 255, 0));
      //stroke(255); //HENDA
      strokeWeight(map(i, 0, spectrumArray.length, 4, 0));
      vertex(
        map(j, 0, spectrumArray[0].length, 50, planeW/2), 
        map(i, 0, spectrumArray.length, planeH/2, -planeH/2), 
        spectrumArray[i][j]*1000);
    }
    endShape(OPEN);
  }

  //OTHER HALF
  for (int i = 0; i < spectrumArray.length; i++) {
    beginShape();
    for (int j = 0; j < spectrumArray[0].length; j++) {
      stroke(0, map(i, 0, spectrumArray.length, 255, 0));
      //stroke(255); //HENDA
      strokeWeight(map(i, 0, spectrumArray.length, 4, 0));
      vertex(
        map(j, 0, spectrumArray[0].length, -50, -planeW/2), 
        map(i, 0, spectrumArray.length, planeH/2, -planeH/2), 
        spectrumArray[i][j]*1000);
    }
    endShape(OPEN);
  }
}

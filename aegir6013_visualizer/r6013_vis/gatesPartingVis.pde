void gatesPartingVis() {

  //HALF SPECTRUM STARTS IN CENTER
  for (int i = 0; i < spectrumArray.length; i++) {
    beginShape();
    for (int j = 0; j < spectrumArray[0].length; j++) {

      float index = map(i, 0, spectrumArray.length, 0, 1);
      float x = map(j, 0, spectrumArray[0].length, 50, planeW/2);
      float y = map(i, 0, spectrumArray.length, planeH/2, -planeH/2);
      float z = spectrumArray[i][j] * 1000;
      stroke(0, 255-index*255);
      strokeWeight(map(i, 0, spectrumArray.length, 4, 0));
      vertex(x, y, z);
    }
    endShape(OPEN);
  }

  //OTHER HALF
  for (int i = 0; i < spectrumArray.length; i++) {
    beginShape();
    for (int j = 0; j < spectrumArray[0].length; j++) {
      float index = map(i, 0, spectrumArray.length, 0, 1);
      float x = map(j, 0, spectrumArray[0].length, -50, -planeW/2);
      float y = map(i, 0, spectrumArray.length, planeH/2, -planeH/2);
      float z = spectrumArray[i][j]*1000;
      
      stroke(0, 255-index*255);
      strokeWeight(map(i, 0, spectrumArray.length, 4, 0));
      vertex(x, y, z);
    }
    endShape(OPEN);
  }
}

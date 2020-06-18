void circularVis() {
  for (int i = 0; i < spectrumArray.length; i++) {
    float r = map(i, 0, spectrumArray.length, 200, 1200);
    strokeWeight(map(i, 0, spectrumArray.length, 4, 0));
    beginShape();
    for (int j = 0; j < spectrumArray[0].length/4; j++) {
      float a = map(j, 0, spectrumArray[0].length/4, 0, TWO_PI);
      //float a = map(j, 0, spectrumArray[0].length/4, -TWO_PI/4, TWO_PI-TWO_PI/4);
      float x = r * cos(a);
      float y = r * sin(a);
      float z = spectrumArray[i][j] * 1000;

      vertex(x, y, z);
    }
    endShape(CLOSE);
  }
}

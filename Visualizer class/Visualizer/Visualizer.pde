class Visualizer {
  int bands;
  int spectrumCount;
  float angleMin = 0;
  float angleIterator = 0.005;
  float[][] spectrumArray = new float[spectrumCount][bands];

  int xCenter = width/2;
  int yCenter = height/2;

  int planeW = 800;
  int planeH = 1600;


  void display(float[][] spectrum) {
    if (displayMode == CIRCULAR) {
      this.circularVis();
    }
  }

  void circularVis(float[][] spectrum) {
    for (int layer = 0; layer < spectrum.length; layer++) {
      float r = map(layer, 0, spectrum.length, 200, 1000);
      strokeWeight(map(layer, 0, spectrum.length, 2, 0.5));
      beginShape();
      for (int i = 0; i < spectrum[layer].length; i++) {
        float r2 = r + log(spectrum[layer][i])*15;
        float a = map(i, 0, spectrum[layer].length, angleMin, angleMin+TWO_PI);
        float x = r2 * cos(a);
        float y = r2 * sin(a);
        vertex(x, y);
        // The result of the FFT is normalized
        // draw the line for frequency band i scaling it up by 5 to get more amplitude.
        //fill(0);
        //line(i,height,i,height+log(spectrum[i])*10);
        //ellipse((float)i, (float)height/2, log(spectrum[i])*10, log(spectrum[i])*10);
      }
      endShape(CLOSE);
    }
    angleMin+=angleIterator;
  }
}

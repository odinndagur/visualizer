class Visualizer {
  int _bands;
  int _spectrumCount;
  float angleMin = 0;
  float angleIterator = 0.005;
  float[][] _spectrumArray;

  int xCenter = width/2;
  int yCenter = height/2;

  int planeW = 800;
  int planeH = 1600;

  int CIRCULAR = 0;
  int GATESPARTING = 1;
  int displayMode = CIRCULAR;

  color fgColor = color(255, 0, 0);
  color bgColor = color(0);

  Visualizer(int bands, int spectrumCount, float[][] spectrumArray) {
    this._bands = bands;
    this._spectrumCount = spectrumCount;
    this._spectrumArray = spectrumArray;
  }

  void display() {
    translate(width/2, height/2);
    rectMode(CENTER);
    //rotateX(PI/2.5);
    background(this.bgColor);
    stroke(this.fgColor);
    noFill();

    if (displayMode == CIRCULAR) {
      this.circularVis(_spectrumArray);
    }
  }

  void setFgColor(color inColor) {
    this.fgColor = inColor;
  }

  void setBgColor(color inColor) {
    this.bgColor = inColor;
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

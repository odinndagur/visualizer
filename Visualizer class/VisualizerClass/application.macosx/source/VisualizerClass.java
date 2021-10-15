import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class VisualizerClass extends PApplet {

class Visualizer {
  int _bands;
  int _spectrumCount;
  float angleMin = 0;
  float angleIterator = 0.005f;
  float[][] _spectrumArray;

  int xCenter = width/2;
  int yCenter = height/2;

  int planeW = 800;
  int planeH = 1600;

  int CIRCULAR = 0;
  int GATESPARTING = 1;
  int displayMode = CIRCULAR;

  int fgColor = color(255, 0, 0);
  int bgColor = color(0);

  Visualizer(int bands, int spectrumCount, float[][] spectrumArray) {
    this._bands = bands;
    this._spectrumCount = spectrumCount;
    this._spectrumArray = spectrumArray;
  }

  public void display() {
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

  public void setFgColor(int inColor) {
    this.fgColor = inColor;
  }

  public void setBgColor(int inColor) {
    this.bgColor = inColor;
  }


  public void circularVis(float[][] spectrum) {
    for (int layer = 0; layer < spectrum.length; layer++) {
      float r = map(layer, 0, spectrum.length, 200, 1000);
      strokeWeight(map(layer, 0, spectrum.length, 2, 0.5f));
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


//define our fft
FFT fft1;
//define our audio input
AudioIn in1;

int delay = 0;
float lastMillis = 0;
int current = 0;

SoundFile file;

int bands = 512; //hversu margir punktar per linu, veldi af 2 (512, 256, 128, 64, 32, 16, 8)
int spectrumCount = 15; //hversu margar linur

float[][] spectrumArray = new float[spectrumCount][bands];
float[][] bufferArray = new float[spectrumCount][bands];



Visualizer vis;

public void settings() {
  size(600, 600);
}

public void setup() {
  vis = new Visualizer(bands, spectrumCount, spectrumArray);
  file = new SoundFile(this, "VANO 3000 - Running Away [adult swim].wav");
  file.play();

  fft1 = new FFT(this, bands);

  fft1.input(file);
}

public void draw() {

  if (millis() - lastMillis > delay) {
    shiftArr();
    fft1.analyze(spectrumArray[0]);
    lastMillis = millis();
  }
  vis.display();
}
//function to shift all elements over by one
public void shiftArr() {
  for (int i = 0; i < spectrumArray.length-1; i++) {
    for (int j = 0; j < spectrumArray[0].length; j++) {
      bufferArray[i+1][j] = spectrumArray[i][j]; //move 0 in spectrum to 1 in buffer and so on
    }
  }

  for (int i = 0; i < spectrumArray.length; i++){
    for(int j = 0; j < spectrumArray[0].length; j++){
      spectrumArray[i][j] = bufferArray[i][j]; //set spectrum to buffer array values
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "VisualizerClass" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

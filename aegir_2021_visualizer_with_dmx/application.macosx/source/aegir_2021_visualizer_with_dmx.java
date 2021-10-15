import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 
import dmxP512.*; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class aegir_2021_visualizer_with_dmx extends PApplet {



//define our fft
FFT fft1;
//define our audio input
AudioIn in1;

//BREYTA ÞESSU STUFFI
int bands = 512; //hversu margir punktar per linu, veldi af 2 (512, 256, 128, 64, 32, 16, 8)
int spectrumCount = 15; //hversu margar linur
int framerate = 30; //stilla fps, maxar ut a ca 35 hja mer
float angleMin = 0; //hvar linan a hringnum byrjar
float angleIterator = 0.005f; //hversu hratt hringurinn snyst
//EKKI BREYTA EFTIR ÞETTA

SoundFile file;

float[][] spectrumArray = new float[spectrumCount][bands];
float[][] bufferArray = new float[spectrumCount][bands];

int planeW = 800;
int planeH = 1600;

int delay = 0;
float lastMillis = 0;
int current = 0;

float red = 0;
float blue = 0;
float white = 0;

public void setup() {
  frameRate(framerate);
  //file = new SoundFile(this, "Ægir - almost by force (æ6.1.2).wav");
  file = new SoundFile(this, "VANO 3000 - Running Away [adult swim].wav");
  file.play();

  //initialize the sound thingy and attach it
  //Sound s = new Sound(this);
  //Sound.list();
  //set input device (can use Sound.list() to find which one it is, can also find by name)
  //s.inputDevice(0);
  //size(1920,1080);
  

  //create separate canvases for each channel
  //declare the actual ffts for the audio channels
  fft1 = new FFT(this, bands);

  //in1 = new AudioIn(this, 0);  //declare the actual channel for each audio input
  //in1.play();  //start playing the audio in the sketch
  //attach the ffts to each input
  //fft1.input(in1);
  fft1.input(file);

  dmx=new DmxP512(this, universeSize, false);
  dmx.setupDmxPro(DMXPRO_PORT, DMXPRO_BAUDRATE);
}


public void draw() {     
  //camera(0, 0, 600, 0, 0, 0, 0, 0, 0);
  //camera(width/2.0, mouseX, mouseY, width/2.0, height/2.0, 0, 0, 1, 0);

  if (millis() - lastMillis > delay) {
    shiftArr();
    fft1.analyze(spectrumArray[0]);
    lastMillis = millis();
  }

  background(0);
  //fill(255);
  translate(width/2, height/2);
  rectMode(CENTER);
  //rotateX(PI/2.5);
  stroke(255, 0, 0);
  noFill();

  //if(mouseX >= width/2){
  //circularVis();
  circularVis2(spectrumArray);
  //}
  //else{
  //gatesPartingVis();
  //}
  float red = getEnergy(1, 350, true);
  float blue = getEnergy(351, 5000, true);
  float white = getEnergy(5001, 22050, true);
  updateDMX(red, blue, white, 0.4f, 1); //heildarmynd a channel 1-4
  updateSingleChannelDMX(red, 0.4f, 5);


  //println(frameRate);
}

public float getEnergy(float frequency1, float frequency2, boolean rangeYesOrNo) {
  //var nyquist = p5sound.audiocontext.sampleRate / 2;
  float nyquist = 22050;

  if (!rangeYesOrNo) {
    // if only one parameter:
    int index = round((frequency1 / nyquist) * spectrumArray[0].length);
    return spectrumArray[0][index];
  } else if (rangeYesOrNo) {
    // if two parameters:
    // if second is higher than first
    if (frequency1 > frequency2) {
      float swap = frequency2;
      frequency2 = frequency1;
      frequency1 = swap;
    }
    int lowIndex = round(
      (frequency1 / nyquist) * spectrumArray[0].length
      );
    int highIndex = round(
      (frequency2 / nyquist) * spectrumArray[0].length
      );

    float total = 0;
    int numFrequencies = 0;
    // add up all of the values for the frequencies
    for (int i = lowIndex; i < highIndex; i++) {
      total += spectrumArray[0][i];
      numFrequencies += 1;
    }
    // divide by total number of frequencies
    float toReturn = total / numFrequencies;
    return toReturn;
  }
  return 0;
}

public float mapf(float x, float in_min, float in_max, float out_min, float out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}
public void circularVis2(float[][] spectrum){
  for(int layer = 0; layer < spectrum.length; layer++){
  float r = map(layer,0,spectrum.length,200,1000);
  strokeWeight(map(layer,0,spectrum.length,2,0.5f));
  beginShape();
  for (int i = 0; i < spectrum[layer].length; i++) {
    float r2 = r + log(spectrum[layer][i])*15;
    float a = map(i,0,spectrum[layer].length,angleMin,angleMin+TWO_PI);
    float x = r2 * cos(a);
    float y = r2 * sin(a);
    vertex(x,y);
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




DmxP512 dmx;
int universeSize = 128;
String DMXPRO_PORT="/dev/tty.usbserial-EN283370";
int DMXPRO_BAUDRATE=115200;

public void updateDMX(float r, float b, float w, float scaler, int channel) {
  r = (int)(map(r, 0, scaler, 0, 255));
  b = (int)(map(b, 0, scaler, 0, 255));
  w = (int)(map(w, 0, scaler, 0, 255));
  if (r <= 0) {
    r = 0;
  }
  if (r >= 255) {
    r = 255;
  }
  if (b <= 0) {
    b = 0;
  }
  if (b >= 255) {
    b = 255;
  }
  if (w <= 0) {
    w = 0;
  }
  if (w >= 255) {
    w = 255;
  }
  dmx.set(1+channel-1, (int)r);
  dmx.set(3+channel-1, (int)b);
  dmx.set(4+channel-1, (int)w);
}

public void updateSingleChannelDMX(float value, float scaler, int channel){
  int val = (int)(map(value, 0, scaler, 0, 255));
  if(val <= 0){
    val = 0;
  }
  if(val >= 255){
    val = 255;
  }
  
  dmx.set(channel,val);
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
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "aegir_2021_visualizer_with_dmx" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

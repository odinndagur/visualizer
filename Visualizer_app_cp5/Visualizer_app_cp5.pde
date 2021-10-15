import processing.sound_modified.*;
import visualizerLib.*;
import com.jsyn.devices.AudioDeviceManager;
import java.util.List; 
import java.util.ArrayList;



FFT fft1;
SoundFile file;
Visualizer v;
Visualizer v2;

List<Visualizer> vis;
Visualizer activeVis;

String fileName = "VANO 3000 - Running Away [adult swim].wav";



int bands = 512; //hversu margir punktar per linu, veldi af 2 (512, 256, 128, 64, 32, 16, 8)
int spectrumCount = 15; //hversu margar linur
float[][] spectrumArray = new float[spectrumCount][bands];
float[][] bufferArray = new float[spectrumCount][bands];

float lastMillis = 0;

Sound s;
AudioIn in1;
AudioInOut[] audioDevices;

PApplet p = this;




void setup() {
  vis = new ArrayList<Visualizer>();
  vis.add(new Visualizer(bands, spectrumCount, spectrumArray, this));
  vis.get(0).start();
  vis.get(0).refreshBackground(true);
  activeVis = vis.get(0);
  audioDevices = soundList();

  println(vis);

  //size(960,400);
  s = new Sound(this);
  //Sound.list();
  ////println(s);
  ////println(s.engine.getSelectedInputDeviceName() + " is the engine thingy");

  in1 = new AudioIn(this, 0);
  in1.play();

  fullScreen();
  //size(1200, 600);
  v = new Visualizer(bands, spectrumCount, spectrumArray, this);
  v2 = new Visualizer(bands, spectrumCount, spectrumArray, this);
  v2.interval(3);
  //v2.start();
  v2.setFgColor(color(130, 30, 200));
  v2.setSpeed(0.3);
  v2.bandCount = 124;
  file = new SoundFile(this, fileName);
  file.play();

  fft1 = new FFT(this, bands);
  fft1.input(file);

  //for (AudioInOut d : audioDevices) {
  //  //print(d.deviceName);
  //  //print(d.maxInputs);
  //  ////println(d.maxOutputs);
  //}

  cp5init();
  vis.get(0).start();
}


public void draw() {
  //background(0);
  //if (millis() - lastMillis > delay) {
  Visualizer.shiftArr(spectrumArray, bufferArray);
  fft1.analyze(spectrumArray[0]);
  //lastMillis = millis();
  //}
  //vis.get(0).display();
  ////println(frameRate);
  checkSliders();
  showFrameRate();
}

void showFrameRate(){
    push();
  rectMode(CENTER);
  fill(255);
  stroke(0);
  strokeWeight(1);
  rect(width/2,height/2,80,80);
  stroke(0);
  fill(0);
  textSize(30);
  textAlign(CENTER,CENTER);
  text((int)frameRate, width/2, height/2);
  pop();
}

String getInputDevice() {
  return s.engine.getSelectedInputDeviceName();
}

int getInputChannels() {
  String name = getInputDevice();
  int inputs = -1;
  for (AudioInOut in : audioDevices) {
    if (name == in.deviceName) {
      inputs = in.maxInputs;
    }
  }
  return inputs;
}

String getOutputDevice() {
  return s.engine.getSelectedOutputDeviceName();
}

void setInputDevice(String deviceName) {
  for (AudioInOut in : audioDevices) {
    if (in.deviceName == deviceName) {
      //println("changing to: " + deviceName);
      s.inputDevice(in.index);
    }
  }
}


void keyPressed() {
  if (key == 'h') {
    showMenu = !showMenu;
    if (showMenu) {
      cp5.show();
    }
    if (!showMenu) {
      cp5.hide();
    }
  }

  if (key == 's') {
    noLoop();
  }
  if (key == ' ') {
    loop();
  }
}

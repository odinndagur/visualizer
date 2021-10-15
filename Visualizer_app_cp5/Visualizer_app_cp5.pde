import processing.sound_modified.*;
import visualizerLib.*;
import com.jsyn.devices.AudioDeviceManager;



FFT fft1;
SoundFile file;
Visualizer v;

String fileName = "VANO 3000 - Running Away [adult swim].wav";



int bands = 512; //hversu margir punktar per linu, veldi af 2 (512, 256, 128, 64, 32, 16, 8)
int spectrumCount = 15; //hversu margar linur
float[][] spectrumArray = new float[spectrumCount][bands];
float[][] bufferArray = new float[spectrumCount][bands];

float lastMillis = 0;

Sound s;
AudioIn in1;
AudioInOut[] audioDevices;



void setup() {
  audioDevices = soundList();

  //size(960,400);
  s = new Sound(this);
  Sound.list();
  ////println(s);
  ////println(s.engine.getSelectedInputDeviceName() + " is the engine thingy");

  in1 = new AudioIn(this, 0);
  in1.play();

  fullScreen();
  v = new Visualizer(bands, spectrumCount, spectrumArray, this);
  file = new SoundFile(this, fileName);
  //file.play();

  fft1 = new FFT(this, bands);
  fft1.input(in1);

  //for (AudioInOut d : audioDevices) {
  //  //print(d.deviceName);
  //  //print(d.maxInputs);
  //  ////println(d.maxOutputs);
  //}

  cp5init();
  v.start();
}


public void draw() {
  background(0);
  //if (millis() - lastMillis > delay) {
  v.shiftArr(spectrumArray, bufferArray);
  fft1.analyze(spectrumArray[0]);
  //lastMillis = millis();
  //}
  //v.display();
  ////println(frameRate);
  
  if(specCount != v.specCount){
    v.specCount = specCount;
  }
  
  if(bandCount != v.bandCount){
    v.bandCount = bandCount;
  }
}




String getInputDevice() {
  return s.engine.getSelectedInputDeviceName();
}

int getInputChannels(){
  String name = getInputDevice();
  int inputs = -1;
  for(AudioInOut in : audioDevices){
    if(name == in.deviceName){
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
}

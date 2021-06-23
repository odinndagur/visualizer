import processing.sound.*;

//define our fft
FFT fft1;
//define our audio input
AudioIn in1;

//BREYTA ÞESSU STUFFI
int bands = 512; //hversu margir punktar per linu, veldi af 2 (512, 256, 128, 64, 32, 16, 8)
int spectrumCount = 15; //hversu margar linur
int framerate = 30; //stilla fps, maxar ut a ca 35 hja mer
float angleMin = 0; //hvar linan a hringnum byrjar
float angleIterator = 0.005; //hversu hratt hringurinn snyst
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

void setup() {
  frameRate(framerate);
    file = new SoundFile(this, "Ægir - almost by force (æ6.1.2).wav");
  file.play();

  //initialize the sound thingy and attach it
  Sound s = new Sound(this);
  //Sound.list();
  //set input device (can use Sound.list() to find which one it is, can also find by name)
  s.inputDevice(0);
  //size(1920,1080);
  fullScreen();

  //create separate canvases for each channel
  //declare the actual ffts for the audio channels
  fft1 = new FFT(this, bands);

  in1 = new AudioIn(this, 0);  //declare the actual channel for each audio input
  in1.play();  //start playing the audio in the sketch
  //attach the ffts to each input
  fft1.input(in1);
  //fft1.input(file);
  
    dmx=new DmxP512(this, universeSize, false);
  dmx.setupDmxPro(DMXPRO_PORT, DMXPRO_BAUDRATE);
}


void draw() {     
  camera(0, 0, 600, 0, 0, 0, 0, 0, 0);
  //camera(width/2.0, mouseX, mouseY, width/2.0, height/2.0, 0, 0, 1, 0);

  if (millis() - lastMillis > delay) {
    shiftArr();
    fft1.analyze(spectrumArray[0]);
    lastMillis = millis();
  }

  background(0);
  fill(255);
  translate(width/2, height/2);
  rectMode(CENTER);
  rotateX(PI/2.5);
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
updateDMX(red,blue,white,0.4);
//println(frameRate);
}

float getEnergy(float frequency1, float frequency2, boolean rangeYesOrNo) {
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

float mapf(float x, float in_min, float in_max, float out_min, float out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

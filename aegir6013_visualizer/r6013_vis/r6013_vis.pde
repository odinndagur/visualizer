import processing.sound.*;

String[] textOut = {""};
String[] textOut2 = {""};

int mode = 0;

//separate canvases for each channel
PGraphics v1;
//define our ffts
FFT fft1;
//define our audio inputs
AudioIn in1;
int bands = 256; //define how many bands for fft
int spectrumCount = 20;

float[][] spectrumArray = new float[spectrumCount][bands];
float[][] bufferArray = new float[spectrumCount][bands];

int planeW = 800;
int planeH = 1600;

int delay = 0;
float lastMillis = 0;
int current = 0;

void setup() {
  //initialize the sound thingy and attach it
  Sound s = new Sound(this);
  //set input device (can use Sound.list() to find which one it is, can also find by name)
  s.inputDevice(1);
  //size(1920,1080);
  fullScreen(P3D);

  //create separate canvases for each channel
  v1 = createGraphics(displayWidth, displayHeight);
  //declare the actual ffts for the audio channels
  fft1 = new FFT(this, bands);

  in1 = new AudioIn(this, 0);  //declare the actual channel for each audio input
  in1.play();  //start playing the audio in the sketch
  //attach the ffts to each input
  fft1.input(in1);
}


void draw() {     
  camera(width/2.0, mouseX, mouseY, width/2.0, height/2.0, 0, 0, 1, 0);

  if (millis() - lastMillis > delay) {
    shiftArr();
    fft1.analyze(spectrumArray[0]);
    lastMillis = millis();
  }

  background(255);
  fill(255);
  translate(width/2, height/2);
  rectMode(CENTER);
  rotateX(PI/2.5);
  stroke(255, 0, 0);
  noFill();

circularVis();
gatesPartingVis();
}

/* Function to shift all elements of the array to move it on the time axis */

void shiftArr() {
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

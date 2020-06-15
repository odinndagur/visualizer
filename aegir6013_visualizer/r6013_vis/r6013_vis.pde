import processing.sound.*;

String[] textOut = {""};

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

int delay = 50;
float lastMillis = 0;

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
  if(millis() - lastMillis > delay){
    for(int i = 0; i < 10; i++){
      fft1.analyze(spectrumArray[0]);
      shiftArr();
    }
  lastMillis = millis();
  }
  
  //if(millis() > 9000){
  //  sendText();
  //}

  background(105);
  fill(255);
  translate(width/2, height/2);
  rectMode(CENTER);
  rotateX(PI/2.5);
  stroke(0);
  rect(0, 0, planeW, planeH);
  stroke(255, 0, 0);
  noFill();

  for(int i = 0; i < spectrumArray.length; i++){
      beginShape();

    for(int j = 0; j < spectrumArray[0].length; j++){
      stroke(255,0,0,map(i,0,spectrumArray.length,0,255));
      strokeWeight(map(i,0,spectrumArray.length,0,4));
      vertex(
      map(j,0,spectrumArray[0].length,-planeW/2,planeW/2),
      map(i,0,spectrumArray.length,-planeH/2,planeH/2),
      spectrumArray[i][j]*1000);
    }
          endShape(OPEN);

  }

  //for (int i = 0; i< bands/2; i++) {
  //  float x = map(i, 0, bands/2, 0, displayWidth/2);
  //  float y = map(spectrum1[i], 0, 255, 0, displayHeight)*5000;

  //  beginShape();
  //  vertex(map(i,0,bands/2,0,displayWidth),map(spectrum1[i],0,255,0,displayHeight*5000),0);
  //  vertex(map(i,0,bands/2,0,displayWidth),map(spectrum1[i],0,255,0,displayHeight*5000), 50);
  //  vertex(map(i,0,bands/2,0,displayWidth),0,50);
  //  vertex(map(i,0,bands/2,0,displayWidth),0,0);
  //  endShape();

  //}
  shiftArr();
}

void shiftArr(){
    for(int x = 0; x < spectrumArray.length-1; x++){
      bufferArray[x+1] = spectrumArray[x]; //move every element over one spot in the buffer
    }
          spectrumArray = bufferArray; //set the original array to the values of the buffer array

}

void sendText(){
  for(int i = 0; i < spectrumArray[0].length; i++){
    textOut[0] = textOut[0] + spectrumArray[0][i];
  }
    saveStrings( "output.txt", textOut);
    exit();
}

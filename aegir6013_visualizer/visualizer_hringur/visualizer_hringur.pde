import processing.sound.*;

String[] textOut = {""};
String[] textOut2 = {""};

//separate canvases for each channel
PGraphics v1;
//define our ffts
FFT fft1;
//define our audio inputs
AudioIn in1;
int bands = 512; //define how many bands for fft
int spectrumCount = 40;

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
  rotateX(PI/6);
  rotateZ(PI/2);
  //float z = frameCount;
  //z = z/100;
  //rotateZ(PI/3);
  //rotateY(PI/3);
  stroke(0);
  //fill(255,0,100,100);
  //rect(0, 0, planeW, planeH);
  stroke(255, 0, 0);
  noFill();
  
  float f = frameCount;
  f = f/100;
circularVisualizer();
//for(int i = 0; i < spectrumArray.length; i++){
//  float r = map(i,0,spectrumArray.length,200,1200);
//  strokeWeight(map(i,0,spectrumArray.length,4,0));
//  beginShape();
//    for (int j = 0; j < spectrumArray[0].length/4; j++) {
//      float a = map(j, 0, spectrumArray[0].length/4, 0, TWO_PI);
//      float x = r * cos(a);
//      float y = r * sin(a);
//      float z = spectrumArray[i][j] * 1000;
      
//      vertex(x,y,z);
//  }
//  endShape(CLOSE);  
//}


//for(int i = 0; i < spectrumArray.length; i++){
//  float r = map(i,0,spectrumArray.length,50,600);
//  strokeWeight(map(i,0,spectrumArray.length,4,0));
//  beginShape();
//    for (int j = 0; j < spectrumArray[0].length; j++) {
//      float a = map(j, 0, spectrumArray[0].length, 0, TWO_PI);
//      float x = r * cos(a);
//      float y = r * sin(a);
//      float z = 400-(spectrumArray[i][j] * 1000);
      
//      vertex(x,y,z);
//  }
//  endShape(CLOSE);
  
//}

//  //HALF SPECTRUM STARTS IN CENTER
//  for (int i = 0; i < spectrumArray.length; i++) {
//    beginShape();
//    for (int j = 0; j < spectrumArray[0].length; j++) {
//      stroke(0, map(i, 0, spectrumArray.length, 255, 0));
//      //stroke(255); //HENDA
//      strokeWeight(map(i, 0, spectrumArray.length, 4, 0));
//      vertex(
//        map(j, 0, spectrumArray[0].length, 50, planeW/2), 
//        map(i, 0, spectrumArray.length, planeH/2, -planeH/2), 
//        spectrumArray[i][j]*1000);
//    }
//    endShape(OPEN);
//  }

//  //OTHER HALF
//  for (int i = 0; i < spectrumArray.length; i++) {
//    beginShape();
//    for (int j = 0; j < spectrumArray[0].length; j++) {
//      stroke(0, map(i, 0, spectrumArray.length, 255, 0));
//      //stroke(255); //HENDA
//      strokeWeight(map(i, 0, spectrumArray.length, 4, 0));
//      vertex(
//        map(j, 0, spectrumArray[0].length, -50, -planeW/2), 
//        map(i, 0, spectrumArray.length, planeH/2, -planeH/2), 
//        spectrumArray[i][j]*1000);
//    }
//    endShape(OPEN);
//  }
}

/* Function to shift all elements of the array to move it on the time axis */

void shiftArr() {
  for (int i = 0; i < spectrumArray.length-1; i++) {
    for (int j = 0; j < spectrumArray[0].length; j++) {
      bufferArray[i+1][j] = spectrumArray[i][j]; //move 0 in spectrum to 1 in buffer and so on
    }
  }

  for (int i = 0; i < spectrumArray.length; i++) {
    for (int j = 0; j < spectrumArray[0].length; j++) {
      spectrumArray[i][j] = bufferArray[i][j]; //set spectrum to buffer array values
    }
  }
}


void circularVisualizer(){
  for(int i = 0; i < spectrumArray.length; i++){
  float r = map(i,0,spectrumArray.length,200,1200);
  strokeWeight(map(i,0,spectrumArray.length,4,0));
  beginShape();
    for (int j = 0; j < spectrumArray[0].length/4; j++) {
      float a = map(j, 0, spectrumArray[0].length/4, 0, TWO_PI);
      float x = r * cos(a);
      float y = r * sin(a);
      float z = spectrumArray[i][j] * 1000;
      
      vertex(x,y,z);
  }
  endShape(CLOSE);  
}
}

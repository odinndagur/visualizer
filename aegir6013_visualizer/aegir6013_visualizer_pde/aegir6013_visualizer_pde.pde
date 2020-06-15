import processing.sound.*;
//separate canvases for each channel
PGraphics v1;
PGraphics v2;

//define our ffts
FFT fft1;
FFT fft2;
//define our audio inputs
AudioIn in1;
AudioIn in2;
int bands = 1024; //define how many bands for fft
//arrays of floats to keep the values from the ffts, one for each channel
float[] spectrum1 = new float[bands];
float[] spectrum2 = new float[bands];


void setup() {
  //initialize the sound thingy and attach it
  Sound s = new Sound(this);
  //set input device (can use Sound.list() to find which one it is, can also find by name)
  s.inputDevice(1);
  //size(1920,1080);
  fullScreen();

  //create separate canvases for each channel
  v1 = createGraphics(displayWidth, displayHeight);
  v2 = createGraphics(displayWidth, displayHeight);
  //declare the actual ffts for the audio channels
  fft1 = new FFT(this, bands);
  fft2 = new FFT(this, bands);
  
  in1 = new AudioIn(this, 0);  //declare the actual channel for each audio input
  in1.play();  //start playing the audio in the sketch
  in2 = new AudioIn(this, 1); //same for the other audio input
  in2.play(); //same as in1
  //attach the ffts to each input
  fft1.input(in1);
  fft2.input(in2);
}

void draw() {

  background(0); //reset canvas to black all over
  
  //grab a frame and analyze the fft for each channel, add the values to the spectrums
  fft1.analyze(spectrum1);
  fft2.analyze(spectrum2);

  
  stroke(255, 0, 0);




  //v1 - red from top
  v1.beginDraw();
  v1.clear();
  v1.pushMatrix();
  //v1.strokeWeight(3);
  v1.stroke(255, 0, 0);
  for (int i = 0; i< bands/2; i++) {
    float x = map(i, 0, bands/2, 0, displayWidth/2);
    float y = map(spectrum1[i], 0, 255, 0, displayHeight)*5000;
    //vertex(x,y);
    //v1.line(x+displayWidth/2,y,x+displayWidth/2,-y);
    //v1.line(displayWidth/2-x,y,displayWidth/2-x,-y);

    v1.line(x+displayWidth/2, y/2, x+displayWidth/2, -y/2);
    v1.line(displayWidth/2-x, y/2, displayWidth/2-x, -y/2);
  }
  v1.popMatrix();
  v1.endDraw();

  image(v1, 0, 0);

  //v2 - white from bottom

  v2.beginDraw();
  v2.clear();
  v2.pushMatrix();
  //v2.strokeWeight(3);
  v2.stroke(255);
  for (int i = 0; i< bands/2; i++) {
    float x = map(i, 0, bands/2, 0, displayWidth/2);
    float y = map(spectrum2[i], 0, 255, 0, 1080)*5000;
    //vertex(x,y);
    v2.line(x+displayWidth/2, displayHeight+y/2, x+displayWidth/2, displayHeight-y/2);
    v2.line(displayWidth/2-x, displayHeight+y/2, displayWidth/2-x, displayHeight-y/2);


    // MIÐJAÐ
    //    v2.line(x+displayWidth/2,displayHeight/2+y/2,x+displayWidth/2,displayHeight/2-y/2);
    //v2.line(displayWidth/2-x,displayHeight/2+y/2,displayWidth/2-x,displayHeight/2-y/2);
  }
  v2.popMatrix();
  v2.endDraw();

  image(v2, 0, 0);
}

//// fade sound if mouse is over canvas
//void togglePlay() {
//  if (sound.isPlaying()) {
//    sound.pause();
//  } else {
//    sound.loop();
//  }
//}

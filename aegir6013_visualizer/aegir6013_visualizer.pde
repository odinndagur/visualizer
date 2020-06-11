import processing.sound.*;

PGraphics v1;
PGraphics v2;

FFT fft1;
FFT fft2;
AudioIn in1;
AudioIn in2;
int bands = 1024;
float[] spectrum1 = new float[bands];
float[] spectrum2 = new float[bands];


void setup() {
    Sound s = new Sound(this);
  s.inputDevice(1);
  //size(1920,1080);
  fullScreen();

  v1 = createGraphics(displayWidth, displayHeight);
  v2 = createGraphics(displayWidth, displayHeight);
  v1.strokeWeight(2);
  v2.strokeWeight(2);
  fft1 = new FFT(this, bands);
  fft2 = new FFT(this, bands);
  in1 = new AudioIn(this, 0);
  in1.play();
  in2 = new AudioIn(this, 1);
  in2.play();
  fft1.input(in1);
  fft2.input(in2);
}

void draw() {

  background(0);
  fft1.analyze(spectrum1);
  fft2.analyze(spectrum2);

  stroke(255, 0, 0);




  //v1 - red from top
  v1.beginDraw();
  v1.clear();
  v1.pushMatrix();
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

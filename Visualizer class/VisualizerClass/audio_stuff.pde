import processing.sound.*;

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

void setup() {
  vis = new Visualizer(bands, spectrumCount, spectrumArray);
  file = new SoundFile(this, "VANO 3000 - Running Away [adult swim].wav");
  file.play();

  fft1 = new FFT(this, bands);

  fft1.input(file);
}

void draw() {

  if (millis() - lastMillis > delay) {
    shiftArr();
    fft1.analyze(spectrumArray[0]);
    lastMillis = millis();
  }
  vis.display();
}

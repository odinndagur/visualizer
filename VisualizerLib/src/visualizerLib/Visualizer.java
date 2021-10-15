package visualizerLib;

import processing.core.*;
import processing.sound_modified.*;

public class Visualizer extends PApplet {
    int _bands;
    int _spectrumCount;

    public int specCount;
    public int bandCount;

    float angleMin = 0;
    float angleIterator = (float) 0.005;
    public float[][] _spectrumArray;

    int xCenter = width/2;
    int yCenter = height/2;

    int planeW = 800;
    int planeH = 1600;

    int CIRCULAR = 0;
    int GATESPARTING = 1;
    int displayMode = CIRCULAR;

    public int fgR;
    public int fgG;
    public int fgB;
    public int fgA;

    int index = 0;

    PApplet p;

    FFT fft;
    AudioIn in;
    boolean ourFFT = false;

    boolean running = false;

    public int fgColor;
    public int bgColor;

    public Visualizer(PApplet parent){
        parent.registerMethod("draw",this);
        ourFFT = true;
        this._bands = 512;
        this.specCount = 30;
        this.bandCount = this._bands;
        this._spectrumCount = 30;
        this._spectrumArray = new float[this._spectrumCount][this._bands];
        fft = new FFT(parent,_bands);
        in = new AudioIn(parent,0);
        fft.input(in);
    }

    public Visualizer(int bands, int spectrumCount, float[][] spectrumArray, PApplet parent) {
        parent.registerMethod("draw",this);
        this._bands = bands;
        this.specCount = spectrumCount;
        this.bandCount = bands;
        this._spectrumCount = spectrumCount;
        this._spectrumArray = spectrumArray;
        this.p = parent;
        this.fgColor = p.color(255,0,0,255);
        this.bgColor = p.color(0);
    }

    public void start(){
        this.running = true;
    }

    public void stop(){
        this.running = false;
    }

    public void draw(){
        if(this.running) {
            this.display();
        }
        println("lollolololklo1j2l3123");
    }

    public void addSpectrum(){
        if(specCount < _spectrumCount){
            specCount++;
        }
    }

    public void removeSpectrum(){
        if(specCount > 0){
            specCount--;
        }
    }

    public void addBand(){
        if(bandCount < _bands){
            bandCount++;
        }
    }

    public void removeBand(){
        if(bandCount > 0){
            bandCount--;
        }
    }

    public void display() {

        if(ourFFT){
            fft.analyze(_spectrumArray[0]);
            shiftArr(_spectrumArray, new float[_spectrumCount][_bands]);
        }
        p.pushMatrix();
        p.translate(p.width/2, p.height/2);
        p.rectMode(CENTER);
        //rotateX(PI/2.5);
        p.background(bgColor);
        //p.stroke(this.fgR,this.fgG,this.fgB,this.fgA);
        p.stroke(fgColor);
        p.noFill();

        if (displayMode == CIRCULAR) {
            circularVis(_spectrumArray);
        }
        p.popMatrix();
    }

    public void setFgColor(int c){
        fgColor = c;
    }

    public void setBgColor(int c){
        bgColor = c;
    }


    public void circularVis(float[][] spectrum) {
        for (int layer = 0; layer < specCount; layer++) {
            float r = p.map(layer, 0, spectrum.length, 200, 1000);
            p.strokeWeight(p.map(layer, 0, spectrum.length, 2, 0.5F));
            p.beginShape();
            for (int i = 0; i < bandCount; i++) {
                float r2 = r + log(spectrum[layer][i])*15;
                float a = map(i, 0, bandCount, angleMin, angleMin+TWO_PI);
                float x = r2 * cos(a);
                float y = r2 * sin(a);
                p.vertex(x, y);
                // The result of the FFT is normalized
                // draw the line for frequency band i scaling it up by 5 to get more amplitude.
                //fill(0);
                //line(i,height,i,height+log(spectrum[i])*10);
                //ellipse((float)i, (float)height/2, log(spectrum[i])*10, log(spectrum[i])*10);
            }
            p.endShape(CLOSE);
        }
        angleMin+=angleIterator;
    }

    public void circularVis2(float[][] spectrum) {
        for (int layer = this.index; layer < specCount+this.index; layer++) {
            int temp = layer;
            layer = layer % specCount;
            float r = p.map(layer, 0, spectrum.length, 200, 1000);
            p.strokeWeight(p.map(layer, 0, spectrum.length, 2, 0.5F));
            p.beginShape();
            for (int i = 0; i < bandCount; i++) {
                float r2 = r + log(spectrum[layer][i])*15;
                float a = map(i, 0, bandCount, angleMin, angleMin+TWO_PI);
                float x = r2 * cos(a);
                float y = r2 * sin(a);
                p.vertex(x, y);
                // The result of the FFT is normalized
                // draw the line for frequency band i scaling it up by 5 to get more amplitude.
                //fill(0);
                //line(i,height,i,height+log(spectrum[i])*10);
                //ellipse((float)i, (float)height/2, log(spectrum[i])*10, log(spectrum[i])*10);
            }
            p.endShape(CLOSE);
            layer = temp;
        }
        angleMin+=angleIterator;
        this.index++;
    }

    //function to shift all elements over by one
    public static void shiftArr(float[][] spectrumArray, float[][] bufferArray) {
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
}
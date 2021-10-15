import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound_modified.*; 
import visualizerLib.*; 
import com.jsyn.devices.AudioDeviceManager; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class visualizerpaelingar extends PApplet {






    FFT fft1;
    SoundFile file;
    Visualizer v;

    int bands = 512; //hversu margir punktar per linu, veldi af 2 (512, 256, 128, 64, 32, 16, 8)
    int spectrumCount = 15; //hversu margar linur
    float[][] spectrumArray = new float[spectrumCount][bands];
    float[][] bufferArray = new float[spectrumCount][bands];

    float lastMillis = 0;

    Sound s;
    AudioIn in1;
    AudioInOut[] audioDevices;
    
public void setup(){
        audioDevices = soundList();
        //size(960,400);
        s = new Sound(this);
        println(s);
        in1 = new AudioIn(this,0);
        in1.play();

        
        v = new Visualizer(bands,spectrumCount,spectrumArray,this);
        file = new SoundFile(this, "VANO 3000 - Running Away [adult swim].wav");
        file.play();

        fft1 = new FFT(this, bands);
        fft1.input(file);
        
        for(AudioInOut d : audioDevices){
          print(d.deviceName);
          print(d.maxInputs);
          println(d.maxOutputs);
        }

    }

    
    public void draw(){
        //group("devices");
        //for(int i = 0; i < audioDevices.length; i++){
        //    if(button(audioDevices[i].deviceName + " " + audioDevices[i].maxInputs + "i" + audioDevices[i].maxOutputs + "o")){
        //        s.inputDevice(i);
        //        fft1.input(in1);
        //        if(file.isPlaying()){
        //            file.pause();
        //        }
        //    }
        //}

        //if(button("file")){
        //    s.inputDevice(0);
        //    fft1.input(file);
        //    if(!file.isPlaying()) {
        //        file.play();
        //    }
        //}
        //group("rest");
        background(0);
        //if (millis() - lastMillis > delay) {
            v.shiftArr(spectrumArray,bufferArray);
            fft1.analyze(spectrumArray[0]);
            lastMillis = millis();
        //}
        stroke(0);

       //background(255);
        //group("visualizer");

        //if(toggle("display",true)){
            v.display();
        //}



        //group("audio");
        //if (button("hello world")) {
        //    background(random(255));
        //}

        //float sc = sliderInt("spectrum count",spectrumCount);
        //if(sc >= 0 && sc <= 15) {
        //    v.specCount = (int) sc;
        //}

        //int bc = sliderInt("band count",bands);
        //if(bc >= 0 && bc <= bands){
        //    v.bandCount = bc;
        //}
        //gui();
    }
public class AudioInOut {
    public int index;
    public String deviceName;
    public int maxInputs;
    public int maxOutputs;

    public AudioInOut(){
        this.index = -1;
        this.deviceName = "empty string for device name nog af plassi";
        this.maxInputs = -1;
        this.maxOutputs = -1;
    }
}

public AudioInOut[] soundList() {
        AudioDeviceManager audioManager = Engine.getAudioManager();
        int numDevices = audioManager.getDeviceCount();
        AudioInOut [] tempDevices = new AudioInOut[numDevices];
        for(int i = 0; i < tempDevices.length; i++){
            tempDevices[i] = new AudioInOut();
        }
        //String[] devices = new String[numDevices];
        for (int i = 0; i < numDevices; i++) {
            String deviceName = audioManager.getDeviceName(i);
            //devices[i] = audioManager.getDeviceName(i) + audioManager.getMaxInputChannels(i) + " inputs " + audioManager.getMaxOutputChannels(i) + " outputs";
            int maxInputs = audioManager.getMaxInputChannels(i);
            int maxOutputs = audioManager.getMaxOutputChannels(i);
            //boolean isDefaultInput = (i == audioManager.getDefaultInputDeviceID());
            //boolean isDefaultOutput = (i == audioManager.getDefaultOutputDeviceID());
            //System.out.println("device id " + i + ": " + deviceName);
            //System.out.println("  max inputs : " + maxInputs + (isDefaultInput ? "   (default)" : ""));
            //System.out.println("  max outputs: " + maxOutputs + (isDefaultOutput ? "   (default)" : ""));
            tempDevices[i].deviceName = deviceName;
            tempDevices[i].index = i;
            tempDevices[i].maxInputs = maxInputs;
            tempDevices[i].maxOutputs = maxOutputs;
        }
        return tempDevices;
    }
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--hide-stop", "visualizerpaelingar" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

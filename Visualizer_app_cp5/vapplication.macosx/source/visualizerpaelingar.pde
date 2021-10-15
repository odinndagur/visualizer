import processing.sound_modified.*;
import visualizerLib.*;
import com.jsyn.devices.AudioDeviceManager;


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
    
void setup(){
        audioDevices = soundList();
        //size(960,400);
        s = new Sound(this);
        println(s);
        in1 = new AudioIn(this,0);
        in1.play();

        fullScreen();
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

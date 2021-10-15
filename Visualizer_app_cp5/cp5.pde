import controlP5.*;

ControlP5 cp5;
RadioButton fgColor;
RadioButton bgColor;
RadioButton audioInput;
RadioButton audioOutput;
RadioButton channels;
Group channel;
boolean showMenu = true;

int specCount = spectrumCount;
int bandCount = bands;

Slider specSlider;
Slider bandSlider;

Button addSpec;
Button addBand;
Button removeSpec;
Button removeBand;

Tab Color;

ColorPicker fgColorPicker;
ColorPicker bgColorPicker;


void checkSliders() {
  if (specCount != v.specCount) {
    v.setSpecCount(specCount);
  }
  if (bandCount != v.bandCount) {
    v.setBandCount(bandCount);
  }
}

void resetChannels() {
  for (controlP5.Toggle item : audioOutput.getItems()) {
    item.remove();
  }
  audioOutput.update();
  audioOutput = cp5.addRadioButton("audioOutput")
    .setPosition(10, 10)
    .setSize(30, 30)
    .setGroup(channel)
    ;
  int channelCount = getInputChannels();
  Sound.list();
  for (int i = 0; i < channelCount; i++) {
    audioOutput.addItem(Integer.toString(i), i);
  }
  channel.setBackgroundHeight((channelCount+1)*30);
}

void cp5init() {
  cp5 = new ControlP5(this);

  Color = cp5.addTab("Color")
    .setColorBackground(color(0, 160, 100))
    .setColorLabel(color(255))
    .setColorActive(color(255, 128, 0))
    .activateEvent(true)
    ;
    
  
  
  Group fg = cp5.addGroup("fg")
    .setPosition(250, 100)
    .setWidth(100)
    .activateEvent(true)
    .setBackgroundColor(color(255, 80))
    .setBackgroundHeight(180)
    .setLabel("Foreground")
    .moveTo("Color")
    ;

  fgColor = cp5.addRadioButton("fgRadio")
    .setPosition(10, 10)
    .setSize(30, 30)
    .addItem("black", 0)
    .addItem("red", 1)
    .addItem("green", 2)
    .addItem("blue", 3)
    .addItem("grey", 4)
    .setGroup(fg)
    ;

  fgColorPicker = cp5.addColorPicker("fgColorPicker")
    .setPosition(60, 400)
    .setColorValue(v.fgColor)
    .setWidth(10)
    .setGroup(fg)
    ;


  for (int i = 0; i < fgColors.length; i++) {
    if (v.fgColor == fgColors[0]) {
      fgColor.activate(i);
    }
  }

  Group bg = cp5.addGroup("bg")
    .setPosition(360, 100)
    .setWidth(100)
    .activateEvent(true)
    .setBackgroundColor(color(255, 80))
    .setBackgroundHeight(180)
    .setLabel("Background")
    .moveTo("Color")
    ;

  bgColor = cp5.addRadioButton("bgRadio")
    .setPosition(10, 10)
    .setSize(30, 30)
    .addItem("black ", 0)
    .addItem("red ", 1)
    .addItem("green ", 2)
    .addItem("blue ", 3)
    .addItem("grey ", 4)
    .setGroup(bg)
    ;

  bgColorPicker = cp5.addColorPicker("bgColorPicker")
    .setPosition(60, 500)
    .setColorValue(v.bgColor)
    .setWidth(10)
    .setGroup(bg)
    ;

  Group audio = cp5.addGroup("audio")
    .setPosition(480, 100)
    .setWidth(500)
    .activateEvent(true)
    .setBackgroundColor(color(255, 80))
    .setBackgroundHeight(400)
    .setLabel("Audio")
    .moveTo("Audio");
  ;

  Group audioin = cp5.addGroup("audioin")
    .setPosition(20, 20)
    .setWidth(180)
    .activateEvent(true)
    .setBackgroundColor(color(255, 80))
    .setBackgroundHeight(180)
    .setLabel("Audio Input")
    .setGroup(audio)
    ;

  audioInput = cp5.addRadioButton("audioInRadio")
    .setPosition(10, 10)
    .setSize(30, 30)
    .setGroup(audioin)
    ;    

  Group audioout = cp5.addGroup("audioout")
    .setPosition(220, 20)
    .setWidth(180)
    .activateEvent(true)
    .setBackgroundColor(color(255, 80))
    .setBackgroundHeight(180)
    .setLabel("Audio Output")
    .setGroup(audio)
    ;

  audioOutput = cp5.addRadioButton("audioOutRadio")
    .setPosition(10, 10)
    .setSize(30, 30)
    .setGroup(audioout)
    ;

  audioInput.addItem("File", 0);


  int audioInIndex = 1;
  int audioInSize = 0;
  int currentInputIndex = -1;
  int audioOutIndex = 0;
  int audioOutSize = 0;
  int currentOutputIndex = -1;
  for (AudioInOut in : audioDevices) {
    //java.util.List<controlP5.Toggle> list = audioInput.getItems();
    String name = in.deviceName;
    //name += ' ';
    //name += in.maxInputs;
    //name += 'i';
    //name += in.maxOutputs;
    //name += 'o';
    if (in.deviceName == getInputDevice()) {
      currentInputIndex = audioInIndex;
      //println(in.deviceName + "" + getInputDevice());
    }
    if (in.deviceName == getOutputDevice()) {
      currentOutputIndex = audioOutIndex;
    }
    if (in.maxInputs > 0) {
      audioDevices[in.index].cp5InIndex = audioInIndex;
      audioInput.addItem(name + " in", audioInIndex++);
    }
    if (in.maxOutputs > 0) {
      audioDevices[in.index].cp5OutIndex = audioOutIndex;
      audioOutput.addItem(name + " out", audioOutIndex++);
    }


    audioInSize = (audioInIndex) * 36;
    audioOutSize = (audioOutIndex) * 36;
  }
  audioin.setBackgroundHeight(audioInSize);
  audioout.setBackgroundHeight(audioOutSize);
  audioInput.activate(currentInputIndex);
  audioOutput.activate(currentOutputIndex);

  channel = cp5.addGroup("channel")
    .setPosition(20, audioin.getBackgroundHeight() + 40)
    .setWidth(180)
    .activateEvent(true)
    .setBackgroundColor(color(255, 80))
    .setBackgroundHeight(180)
    .setLabel("Channel")
    .setGroup("audio");
  ;

  audioOutput = cp5.addRadioButton("audioOutput")
    .setPosition(10, 10)
    .setSize(30, 30)
    .setGroup(audio)
    ;

  resetChannels();

  //protected static String getSelectedInputDeviceName() {
  //  return Engine.getAudioManager().getDeviceName(Engine.singleton.inputDevice);
  //}

  //protected static String getSelectedOutputDeviceName() {
  //  return Engine.getAudioManager().getDeviceName(Engine.singleton.outputDevice);
  //}

  //myTextlabelA = cp5.addTextlabel("label")
  //              .setText("A single ControlP5 textlabel, in yellow.")
  //              .setPosition(100,50)
  //              .setColorValue(0xffffff00)
  //              .setFont(createFont("Georgia",20))
  //              ;
  Group spectrum = cp5.addGroup("spectrum")
    .setPosition(100, 100)
    .setWidth(140)
    .activateEvent(true)
    .setBackgroundColor(color(255, 80))
    .setBackgroundHeight(260)
    .setLabel("Spectrum/band count")
    ;

  specSlider = cp5.addSlider("specCount")
    .setPosition(20, 40)
    .setSize(20, 100)
    .setRange(0, spectrumCount)
    .setNumberOfTickMarks(spectrumCount+1)
    .setGroup(spectrum);
  ;


  bandSlider = cp5.addSlider("bandCount")
    .setPosition(80, 40)
    .setSize(20, 100)
    .setRange(0, bands)
    .setValue(bands)
    .setGroup(spectrum);




  addSpec = cp5.addButton("addSpectrum")
    .setValue(0)
    .setPosition(20, 10)
    .setSize(20, 20)
    .setGroup(spectrum)
    .setLabel("+");

  addSpec.onRelease(new CallbackListener() { // add the Callback Listener to the button 
    public void controlEvent(CallbackEvent theEvent) {
      // specify whatever you want to happen here
      v.addSpectrum();
      specSlider.setValue(v.specCount);
    }
  }
  );

  removeSpec = cp5.addButton("removeSpectrum")
    .setValue(0)
    .setPosition(20, 160)
    .setSize(20, 20)
    .setGroup(spectrum)
    .setLabel("-");

  removeSpec.onRelease(new CallbackListener() { // add the Callback Listener to the button 
    public void controlEvent(CallbackEvent theEvent) {
      // specify whatever you want to happen here
      v.removeSpectrum();
      specSlider.setValue(v.specCount);
    }
  }
  );

  addBand = cp5.addButton("addBand")
    .setValue(0)
    .setPosition(80, 10)
    .setSize(20, 20)
    .setGroup(spectrum)
    .setLabel("+");
  ;

  addBand.onRelease(new CallbackListener() { // add the Callback Listener to the button 
    public void controlEvent(CallbackEvent theEvent) {
      // specify whatever you want to happen here
      v.addBand();
      bandSlider.setValue(v.bandCount);
    }
  }
  );

  removeBand = cp5.addButton("removeBand")
    .setValue(0)
    .setPosition(80, 160)
    .setSize(20, 20)
    .setGroup(spectrum)
    .setLabel("-");

  removeBand.onRelease(new CallbackListener() { // add the Callback Listener to the button 
    public void controlEvent(CallbackEvent theEvent) {
      // specify whatever you want to happen here
      v.removeBand();
      bandSlider.setValue(v.bandCount);
    }
  }
  );

  Button relativeBands = cp5.addButton("relativeBands")
    .setValue(0)
    .setPosition(35, 200)
    .setSize(80, 40)
    .setLabel("relativeBands")
    .setGroup(spectrum);

  relativeBands.onRelease(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      v.relativeBands = !v.relativeBands;
      //println("v.relativeBands is: " + v.relativeBands);
      //relativeBands.setLabel("not relativeBands");
      //if(v.relativeBands){
      //  relativeBands.setLabel("relativeBands");
      //}
    }
  }
  );

  Button fadeOut = cp5.addButton("fadeOut")
    .setValue(0)
    .setPosition(35, height-100)
    .setSize(80, 40)
    .setLabel("Fade Out")
    .moveTo("global")
    ;
  //.setGroup(spectrum);

  fadeOut.onRelease(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      v.fadeOut();
    }
  }
  );
}


void controlEvent(ControlEvent theEvent) {    
  if (theEvent.isFrom(fgColorPicker)) {
    int r = int(theEvent.getArrayValue(0));
    int g = int(theEvent.getArrayValue(1));
    int b = int(theEvent.getArrayValue(2));
    int a = int(theEvent.getArrayValue(3));
    color col = color(r, g, b, a);
    v.setFgColor(col);
  }
  if (theEvent.isFrom(bgColorPicker)) {
    int r = int(theEvent.getArrayValue(0));
    int g = int(theEvent.getArrayValue(1));
    int b = int(theEvent.getArrayValue(2));
    int a = int(theEvent.getArrayValue(3));
    color col = color(r, g, b);
    v.setBgColor(col);
  }
  if (theEvent.isFrom(fgColor)) {
    v.setFgColor(fgColors[(int)theEvent.getValue()]);
  }

  if (theEvent.isFrom(bgColor)) {
    v.setBgColor(bgColors[(int)theEvent.getValue()]);
  }

  if (theEvent.isFrom(audioInput)) {
    for (AudioInOut in : audioDevices) {
      if (in.cp5InIndex == (int)theEvent.getValue()) {
        if (getInputDevice() != in.deviceName) {
          println(in.deviceName + "in");
          //if(file.isPlaying()){
          //  file.pause();
          //}
          s.inputDevice(in.index);
          in1 = new AudioIn(this, 0);
          in1.play();
          fft1.input(in1);
          //println(getInputDevice());
          resetChannels();
        }
      }
    }
    if ((int)theEvent.getValue() == 0) {
      //if(getInputDevice() != "Default Audio Device"){
      //  println(getInputDevice() + " get input device");
      ////s = new Sound(this);
      //println("error her?");
      //setInputDevice("Default Audio Device");
      //in1 = new AudioIn(this,0);
      //in1.play();
      ////file = new SoundFile(this,fileName);
      //fft1.input(file);
      if (audioInput.getState(0)) {
        file.play();
        fft1.input(file);
      }
      if (!audioInput.getState(0)) {
        file.stop();
      }
      //if(!file.isPlaying()){
      //  file.play();
      //  fft1.input(file);
      //}
      //if(file.isPlaying()){
      //  file.stop();
      //}
      //}
    }
  }
}

color[] fgColors = {color(0), color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(80)};
color[] bgColors = {color(0), color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(80)};

void radioButton(int a) {
  println("a radio Button event: "+a);
}

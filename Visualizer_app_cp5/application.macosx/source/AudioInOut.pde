public class AudioInOut {
    public int index;
    public String deviceName;
    public int maxInputs;
    public int maxOutputs;
    public int cp5InIndex;
    public int cp5OutIndex;

    public AudioInOut(){
        this.index = -1;
        this.deviceName = "empty string for device name nog af plassi";
        this.maxInputs = -1;
        this.maxOutputs = -1;
        this.cp5InIndex = -1;
        this.cp5OutIndex = -1;
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
            //System.out.//println("device id " + i + ": " + deviceName);
            //System.out.//println("  max inputs : " + maxInputs + (isDefaultInput ? "   (default)" : ""));
            //System.out.//println("  max outputs: " + maxOutputs + (isDefaultOutput ? "   (default)" : ""));
            tempDevices[i].deviceName = deviceName;
            tempDevices[i].index = i;
            tempDevices[i].maxInputs = maxInputs;
            tempDevices[i].maxOutputs = maxOutputs;
            ////println(deviceName);
        }
        return tempDevices;
    }

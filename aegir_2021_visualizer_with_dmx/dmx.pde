import dmxP512.*;
import processing.serial.*;

DmxP512 dmx;
int universeSize = 128;
String DMXPRO_PORT="/dev/tty.usbserial-EN283370";
int DMXPRO_BAUDRATE=115200;
int channel = 1;

void updateDMX(float r, float b, float w, float scaler){
    dmx.set(1+channel-1,(int)(map(r,0,scaler,0,255)));
    dmx.set(3+channel-1,(int)(map(b,0,scaler,0,255)));
    dmx.set(4+channel-1,(int)(map(w,0,scaler,0,255)));
}

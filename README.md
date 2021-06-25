# visualizer
 
Visualizer + light controller for music

Leiðbeiningar:

1) til að setja rétta hljóðkortið!

Gera nýjan processing fæl með þessum kóða:
    import processing.sound.*;
    void setup(){
       Sound.list();
    }
Og gera cmd r til að runna hann. Færð lista yfir hljóðkort. 
Setja númerið frá rétta hljóðkortinu í s.inputDevice() í aðalfælnum.

2) til að tengjast pottþétt enttec ljósagaurnum!

Opna Terminal forritið. Skrifa "ls /dev" og ýta á enter. Finna línuna sem
heitir líklegast "tty.usbserial-EN283370", inniheldur a.m.k. EN283370.
Setja það í String DMXPRO_PORT="/dev/tty.usbserial-EN283370"; í dmx fælnum.
EKKI gleyma "/dev/" á undan tty.

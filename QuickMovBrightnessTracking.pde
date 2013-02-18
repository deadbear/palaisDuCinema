
/**
 * Built from Speed. 
 *
666
 * 
 */

import processing.video.*;
import processing.serial.*;
import dmxP512.*;

////////////////SET ME!!!!!!!!!!!!!!!??????????????????????????????////////////////
Boolean NIX = true;
Boolean MAC = false;
Boolean WINDOWS = false;

String MOVIENAME = "lba.avi";
//////////////////////////////////////////////////////////////////////////////////


Movie mov;

DmxP512 dmxOutput;
int universeSize = 32;
String DMXPRO_PORT = "";  
int DMXPRO_BAUDRATE = 115200;

void setup() {
  size(1080, 768);
  background(0);
  
  mov = new Movie(this, MOVIENAME);     //change this!
  mov.loop();
  
  if (NIX) {
    DMXPRO_PORT = "/dev/ttyACM0";//case matters ! on windows port must be upper cased.
  } else if (MAC) {
    DMXPRO_PORT = "/dev/usbserial-????????";//case matters ! on windows port must be upper cased.
  } else if (WINDOWS) {
    DMXPRO_PORT = "COM4";//case matters ! on windows port must be upper cased
  } else {
      println("!!!!!!!!Set operating system in QuickMovBrightnessTracking.pde!!!!!!!!!");
      exit();
  }
  dmxOutput = new DmxP512(this,universeSize,false); //last parameter is t/f buffered output
  dmxOutput.setupDmxPro(DMXPRO_PORT,DMXPRO_BAUDRATE);
}

void movieEvent(Movie movie) {
  mov.read();  
}

void draw() {    
  image(mov, 0, 0);
  int wScreen = 3;
  int hScreen = 3;
  int numScreens = wScreen * hScreen;
  int[] brightestX = new int[numScreens]; // X-coordinate of the brightest video pixel
  int[] brightestY = new int[numScreens]; // Y-coordinate of the brightest video pixel
  float[] brightestValue = new float[numScreens]; // Brightness of the brightest video pixel
  int[] p = new int[numScreens];
  int[] brightnessAvg = new int[numScreens];
//  float newSpeed = map(mouseX, 0, width, 0.1, 5);
//  mov.speed(newSpeed);
  mov.loadPixels();
  int subMovW = mov.width / wScreen;
  int subMovH = mov.height / hScreen;
  
  int index = 0;
  int i = 0, j = 0, k = 0;
    for (int y = 0; y < mov.height; y++) {
        for (int x = 0; x < mov.width; x++) {
          i =  (x / subMovW) + (hScreen * (y / subMovH));
          // Get the color stored in the pixel
          int pixelValue = mov.pixels[index];
          // Determine the brightness of the pixel
          float pixelBrightness = brightness(pixelValue);
          // If that value is brighter than any previous, then store the
          // brightness of that pixel, as well as its (x,y) location ((index % mov.width) / subMovW) + 
//          print(i);
          if (i < numScreens) {
            if (pixelBrightness > brightestValue[i]) {
              brightestValue[i] = pixelBrightness;
              brightestY[i] = y;
              brightestX[i] = x;
          }
          brightnessAvg[i] = brightnessAvg[i] + (int) pixelBrightness;
          brightestY[i] = y;
          brightestX[i] = x;
          }
          index++;
        }
      }
  fill(255);
//  text(nfc(newSpeed, 2) + "X", 10, 30); 
      // Draw a large, yellow circle at the brightest pixel
  for ( i = 0; i < numScreens; i++){
    fill(0, 64, 0, 64);
    ellipse(brightestX[i], brightestY[i], 10, 10);
    fill(255);
    p[i] = (brightnessAvg[i]/(subMovW * subMovH))/2 + 83;
    Integer fucker = p[i];
    text(fucker.toString(), brightestX[i] - 30, brightestY[i] - 10);
  }    
  dmxOutput.set(1, p);
}  


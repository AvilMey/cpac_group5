import oscP5.*;
import netP5.*;
import processing.video.*;

OscP5 oscP5;
NetAddress myRemoteLocation;



Capture cam;
int index_cam=0;



int pc=0;
float inten=0, dur=0, centerX, centerY, stretchX=0, stretchY=0, k=0, j=0, s=0, c=0, t=0, freq=0, amp=0;
int[][] note2color = { {255,0,0}, {144,0,255}, {255,255,0}, {183,70,139}, {195,242,255}, {171,0,52}, {127,139,253}, {255,127,0}, {187,117,252}, {51,204,51}, {169,103,124}, {142,201,255}}; 
float[] note2hue = {0,29.88,60,120,193,208.67,234.29,273.88,271.11,323.36,340.91,341.75};
int[] pixtwo = new int [width*height];
float[][] note2angle = { {cos(PI/2),sin(PI/2),PI/2}, {cos(4*PI/3),sin(4*PI/3),4*PI/3}, {cos(PI/6),sin(PI/6),PI/6}, {cos(PI),sin(PI),PI}, {cos(11*PI/6),sin(11*PI/6),11*PI/6}, {cos(2*PI/3),sin(2*PI/3),2*PI/3}, {cos(3*PI/2),sin(3*PI/2),3*PI/2}, {cos(PI/3),sin(PI/3),PI/3}, {cos(7*PI/6),sin(7*PI/6),7*PI/6}, {cos(0),sin(0),0}, {cos(5*PI/6),sin(5*PI/6),5*PI/6}, {cos(5*PI/3),sin(5*PI/3),5*PI/3} }; 
boolean runonce = true;



void setup() {
  size(640, 480);

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i, cameras[i]);
    }
    
    cam = new Capture(this, cameras[index_cam]);
    cam.start();
    
  }
  
  frameRate(60);
  centerX=width/2;
  centerY=height/2;
  //stroke(0);
  //strokeWeight(1);
  oscP5 = new OscP5(this,12000);
  //open flow with "other pc"
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
  
}

void copy2img(Capture camera, PImage img) {
  img.loadPixels();
      for (int i=0; i<camera.width*camera.height; i++) {
        img.pixels[i]=camera.pixels[i];
      }
  img.updatePixels();
}

void changeColors(PImage img){
  img.loadPixels();
  colorMode(HSB, 360);
  for(int loc=0; loc<img.width*img.height; loc++){
      img.pixels[loc]=color(note2hue[pc], inten, brightness(img.pixels[loc])
      );      
  }
  img.updatePixels();  
}

void draw() {
  
  t=t+0.002;
  c = cos(TWO_PI*t+note2angle[pc][2])*100*t;
  s = sin(TWO_PI*t+note2angle[pc][2])*100*t;
  
   if (runonce) {
    colorMode(HSB, 360);
    //fill(1, 1, 1);
    //println(note2color[pc][]);
    //ellipse(centerX+note2angle[pc][0]*100*t, centerY-note2angle[pc][1]*100*t, dur, dur);
    //ellipse(centerX+c, centerY-s, dur, dur);  
    runonce=false;
    //loadPixels();
    //arrayCopy(pixtwo, pixels);
    }
  
  
  
  if (! cam.available()) {return;}
  cam.read();
  PImage img=createImage(cam.width,cam.height,RGB);
  
  copy2img(cam, img);
  
  changeColors(img);
  

  if(img.width>0){
    image(img, 0, 0);
  }

}


void oscEvent(OscMessage theOscMessage) {
  inten = theOscMessage.get(0).floatValue();
  pc = theOscMessage.get(1).intValue();
  dur = theOscMessage.get(2).floatValue();
  runonce = true;
  println(inten, " ", pc, " ", dur);
}

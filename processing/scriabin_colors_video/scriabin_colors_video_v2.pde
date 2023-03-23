import oscP5.*;
import netP5.*;
import processing.video.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

Dot d;
Dot[] notes = new Dot[128];
IntList index = new IntList();


Capture cam;
int index_cam=0;

int y = 0;

int dur,pc=0;
float inten=0, centerX, centerY, stretchX=0, stretchY=0, k=0, j=0, s=0, c=0, t=0, freq=0, amp=0;

int[] pixtwo = new int [width*height];
float[] note2hue = {0,29.88,60,120,193,208.67,234.29,273.88,271.11,323.36,340.91,341.75};
float[][] note2angle = { {cos(PI/2),sin(PI/2),PI/2}, {cos(4*PI/3),sin(4*PI/3),4*PI/3}, {cos(PI/6),sin(PI/6),PI/6}, {cos(PI),sin(PI),PI}, {cos(11*PI/6),sin(11*PI/6),11*PI/6}, {cos(2*PI/3),sin(2*PI/3),2*PI/3}, {cos(3*PI/2),sin(3*PI/2),3*PI/2}, {cos(PI/3),sin(PI/3),PI/3}, {cos(7*PI/6),sin(7*PI/6),7*PI/6}, {cos(0),sin(0),0}, {cos(5*PI/6),sin(5*PI/6),5*PI/6}, {cos(5*PI/3),sin(5*PI/3),5*PI/3} }; 

boolean runonce = true;




void setup() {
  size(640, 480);
  colorMode(RGB, 255,255,255);
  
  centerX=width/2;
  centerY=height/2;
  
  d = new Dot(centerX,centerY, color(0,0,0),0);
  //notes.add(d);
  //println(notes.size());

  
  
  
  //Camera setup
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



  //OSC setup
  oscP5 = new OscP5(this,12000);
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
      img.pixels[loc]=color(note2hue[pc%12], inten, brightness(img.pixels[loc])
      );      
  }
  img.updatePixels();  
}

void captureEvent(Capture cam){
    if (! cam.available()) {return;}
    cam.read();
}

void draw() {

  //image(cam, 0, 0); 
  background(255);
  
  //PImage img=createImage(cam.width,cam.height,RGB);
  //copy2img(cam, img);
  //changeColors(img);
  //background(img);

  //println(index);
  for (int i = index.size() - 1; i >= 0; i--) { 
    int ix = index.get(i);
    
    float pos_x = d.x+notes[ix].dur/2+notes[ix].dur*note2angle[notes[ix].note%12][0];
    float pos_y = d.y+notes[ix].dur/2+notes[ix].dur*note2angle[notes[ix].note%12][1];
    notes[ix].move(pos_x,pos_y);
    println(pos_x,pos_y);
    notes[ix].plot();
    if (notes[ix].isFinished){
      index.remove(i);
    }
  }
  float range = 0.4;
  d.x += random(-range,range)/2;
  d.y += random(-range,range)/2;
  d.x = constrain(d.x, 0, width);
  d.y = constrain(d.y, 0, height);
  //println(d.x,d.y);
 

}


void oscEvent(OscMessage theOscMessage) {
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
  
  
  
  if (theOscMessage.checkAddrPattern("/on"))
  {
    inten = theOscMessage.get(0).floatValue();
    pc = theOscMessage.get(1).intValue();
    //println(inten, " ", pc, " ");
    index.append(pc);
    notes[pc] = new Dot(centerX,centerY,inten,pc);
  }
  
  if (theOscMessage.checkAddrPattern("/off"))
  {
    pc = theOscMessage.get(0).intValue();
    notes[pc].isFinished=true;
    //println(pc);
    }
  
  
}

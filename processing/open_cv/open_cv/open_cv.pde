import gab.opencv.*;
import processing.video.*;

Capture cam;
int index_cam=0;

OpenCV opencv;
ArrayList<Line> lines;

PImage canny, blurred_in;


void setup() {
  size(640, 480);
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
    cam = new Capture(this,640, 480);
    cam.start();
    }
  

  opencv = new OpenCV(this, 640, 480);
  
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  opencv.findCannyEdges(20, 50);
  canny = opencv.getSnapshot();
  // Find lines with Hough line detection
  // Arguments are: threshold, minLengthLength, maxLineGap
  lines = opencv.findLines(100, 30, 20);
}


void captureEvent(Capture cam){
    if (! cam.available()) {return;}
    cam.read();
}

void draw() {
 
  background(255);
  
  opencv.loadImage(cam);
  opencv.blur(10,10);
  opencv.findCannyEdges(48, 50);
  canny = opencv.getSnapshot();
  image(canny, 0, 0 );
  // Find lines with Hough line detection
  // Arguments are: threshold, minLengthLength, maxLineGap
  lines = opencv.findLines(mouseX, mouseY, 20);
  println("x: ", mouseX, "y: ", mouseY);
 
  
  //image(opencv.getOutput(), 0, 0);
  strokeWeight(3);
  
  for (Line line : lines) {
    // lines include angle in radians, measured in double precision
    // so we can select out vertical and horizontal lines
    // They also include "start" and "end" PVectors with the position
    //if (line.angle >= radians(0) && line.angle < radians(1)) {
    //  stroke(0, 255, 0);
    //  line(line.start.x, line.start.y, line.end.x, line.end.y);
    //}

    //if (line.angle > radians(89) && line.angle < radians(91)) {
    //  stroke(255, 0, 0);
    //  line(line.start.x, line.start.y, line.end.x, line.end.y);
    //}
    stroke(0, 255, 0);
    line(line.start.x, line.start.y, line.end.x, line.end.y);
  }
}

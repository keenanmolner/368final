// Daniel Shiffman
// All features test

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*; //<>//

Kinect2 kinect2;

void setup() {
  size(512, 512, P2D);

  kinect2 = new Kinect2(this);
  //kinect2.initVideo();
  kinect2.initDepth();
  kinect2.initIR();
  kinect2.initRegistered();
  // Start all data
  kinect2.initDevice();
}


int draw_delay = 100;
int frameNum = 0;
void draw() {
  background(0);
  //image(kinect2.getVideoImage(), 0, 0, kinect2.colorWidth*0.267, kinect2.colorHeight*0.267);
  image(kinect2.getDepthImage(),0 , 0);
  frameNum++;
  //image(kinect2.getIrImage(), 0, kinect2.depthHeight);

  //image(kinect2.getRegisteredImage(), kinect2.depthWidth, kinect2.depthHeight);
  //fill(255);
  if(frameNum == 100){
    saveFrame("depth_map.png");
    exit();
  }
}
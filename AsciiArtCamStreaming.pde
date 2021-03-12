import processing.video.*;

final String letterOrders = "$@B%8&WM#ZO0QLCJUYXzcvuxrft/\\|()1{}[]?-_+~<>i!;:,\"^`\'.                       ";
final char[] letters = letterOrders.toCharArray();
final int SIZE = 9;
final float BRIGHTNESS_FILTER = 180;

int cols, rows;
Capture video;


void setup(){
  //fullScreen();
  println(letters.length); 
 
  size(640, 480);
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
 
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    try{
      video = new Capture(this, width, height);
      println("Initialized");
      video.start();
      println("Started");
    } catch(Exception ex){
      println("Error: "+ex.getMessage());
      stop();
      exit();
    }
  } 
  
  
  //video = new Capture(this, width, height);
  //video.start();
  noStroke();
  cols = width/SIZE;
  rows = height/SIZE;
  
  PFont font = createFont("Courier New", SIZE);
  textFont(font);
}



void draw(){ 
  if(!video.available()){return;}
  
  video.read();
  background(255);
  //set(0, 0, video);
  for(int r = 0; r < rows; r++){
    for(int c = 0; c < cols; c++){
      
      color pixel = video.pixels[r*SIZE*video.width + c*SIZE];
      float brightness = brightness(pixel);
      int idx = letters.length-1;
      
      if(brightness < BRIGHTNESS_FILTER){
        idx = int(map(brightness, 255, 0, letters.length-1, 0));
      }
      
      fill(pixel);
      text(letters[idx], c*SIZE, r*SIZE);
    }
  }
}

void keyPressed(){
  if(key == ENTER){
    saveFrame("CoderDojoAscii-#####.png");
  }
}

void stop() {
  println("Stopping video");
  if(video != null && video.isCapturing()){
    video.stop();
  }
} 

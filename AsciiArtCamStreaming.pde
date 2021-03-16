import processing.video.*;
import java.util.function.Consumer;

final String letterOrders = "$@B%8&WM#ZO0QLCJUYXzcvuxrft/\\|()1{}[]?-_+~<>i!;:,\"^`\'. ";
//final String letterOrders = "@B%8W#Z0LCJYXzx\\|(1{]?~>i:,\"^`\'.  ";
final char[] LETTERS = letterOrders.toCharArray();
final int SIZE = 6;
final float BRIGHTNESS_FILTER = 190;

int cols, rows;
float row_factor, col_factor;
Capture video;


void setup(){
  //fullScreen();
  size(1020, 780);
  
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
      video = new Capture(this, "pipeline:autovideosrc"); // new Capture(this, width, height, 0);
      println("Initialized");
      video.start();
      println("Started");
      noStroke();
      rows = int(video.height/SIZE);
      cols = int(video.width/SIZE);
      //print(height+" | "+width);
      
      row_factor = float(height) / video.height;
      col_factor = float(width) / video.width;
      
      PFont font = createFont("Courier New", int(SIZE*row_factor));
      textFont(font);
      
    } catch(Exception ex){
      println("Error: "+ex.getMessage());
      stop();
      exit();
    }
  } //<>//
}


void draw(){ 
  if(!video.available()){return;}
  
  video.read();
  background(255);
  //set(0, 0, video);
  for(int r = 0; r < rows; r++){
    for(int c = 0; c < cols; c++){
      int max_video_idx = video.width*video.height - 1;
      int video_idx = Math.min((r*SIZE*video.width + c*SIZE), max_video_idx);
      color pixel = video.pixels[video_idx];
      float brightness = brightness(pixel);
      int idx = LETTERS.length-1;
      
      if(brightness < BRIGHTNESS_FILTER){
        idx = int(map(brightness, BRIGHTNESS_FILTER, 0, LETTERS.length-1, 0));
      }
      
      fill(pixel);
      text(LETTERS[idx], width - int(c*SIZE*col_factor), int(r*SIZE*row_factor));
    }
  }
}

void keyPressed(){
  if(key == ENTER){
    saveFrame("AsciiArtCam-#####.png");
  }
}

void stop() {
  println("Stopping video");
  if(video != null && video.isCapturing()){
    video.stop();
  }
} 

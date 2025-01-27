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
  }
}

float getAvgBrigtness(Capture video, int r, int c, int size, int radius){
  final int max_video_idx = video.width*video.height - 1;
  final int video_idx = Math.min((r*size*video.width + c*size), max_video_idx);
  int offset = Math.max(0, video_idx-int(radius/2.0)-video.width*int(radius/2.0));
  //print(offset);
  float bright = 0.0;
  int idx = 0;
  for(int col = 0; col < radius; col++){
    for(int row = 0; row < radius; row++){
      idx = Math.min(offset+col+video.width*row, max_video_idx);
      color pixel = video.pixels[idx];
      bright += brightness(pixel);
    }
  }
  return bright/(radius*radius);
}


void draw(){ 
  if(!video.available()){return;}
  
  video.read();
  background(255);
  
  for(int r = 0; r < rows; r++){
    for(int c = 0; c < cols; c++){
      int max_video_idx = video.width*video.height - 1;
      int video_idx = Math.min((r*SIZE*video.width + c*SIZE), max_video_idx);
      
      color pixel = video.pixels[video_idx];
      
      //float brightness = brightness(pixel);
      float brightness = getAvgBrigtness(video, r, c, SIZE, SIZE);
      int idx = LETTERS.length-1;
      
      if(brightness < BRIGHTNESS_FILTER){
        idx = int(map(brightness, BRIGHTNESS_FILTER, 0, LETTERS.length-1, 0));
      }
      
      //fill(pixel);
      fill(0);
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
    video.dispose();
  }
} 

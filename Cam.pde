class Cam {
  int x, y, w, h;
  Cam(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this. h = h;
  }

  void drawRect(int px, int py, int pw, int ph) {
    rect((px-x)*gameZoom, (py-y)*gameZoom, (pw)*gameZoom, (ph)*gameZoom);
  }

  void drawLine(int x1, int y1, int x2, int y2) {
    line(x1-x, y1-y, x2-x, y2-y);
  }

  void update() {
    x = int((player.x + player.w/2) - (width/2)/gameZoom);
    y = int((player.y + player.h/2) - (height/2)/gameZoom);
  }

  void drawImage(PImage img, int x1, int y1, int w1, int h1) {
    image(img, (x1-x)*gameZoom, (y1-y)*gameZoom, w1*gameZoom, h1*gameZoom);
  }

  PVector getInImageCoord(int px, int py) {
    return new PVector((px-x)*gameZoom, (py-y)*gameZoom);
  }
  
  int getInWorldX(int px) {
    return int((px + x)/gameZoom);
  }
  int getInWorldY(int py) {
    return int((py + y)/gameZoom);
  }

  PVector getInWorldCoord(int px, int py) {
    return new PVector(int((px+x)/gameZoom), int((py+y)/gameZoom));
  }
  PVector getInWorldCoord(PVector v) {
    return new PVector(int((v.x+x)/gameZoom), int((v.y+y)/gameZoom));
  }
  
  int getInWorldXbyBlock(int px) {
   return int(getInWorldCoordBlock(int(getInImageCoord(px,0).x),0).x);
  }
  int getInWorldYbyBlock(int py) {
   return int(getInWorldCoordBlock(0,int(getInImageCoord(py,0).x)).y);
  }
  
  int getDisplayCoordX(int px) {
     return px-x;
  }
  int getDisplayCoordY(int py) {
     return py-y;
  }

//Returns the coordinates of the block that is at the specified on-screen-coordinates
  PVector getInWorldCoordBlock(int px, int py) {
    float rx = ((x+(px)/gameZoom)*1f/blockSize);
    float ry = ((y+(py)/gameZoom)*1f/blockSize);
    if (rx<0) {
      rx = -ceil(-rx); //rounds up
    } else {
      rx = int(rx); //rounds down
    }
    if (ry<0) {
      ry = -ceil(-ry);
    } else {
      ry = int(ry);
    }
    return new PVector(rx, ry);
  }
  
  
  //Returns the rotated image (to the left): currently not called / used
  PImage rotateImage(PImage img) {
    PImage img2 = img;
    img = new PImage(img.height, img.width);
    img2.loadPixels();
    img.loadPixels();
    for (int y = 0; y < img2.height; y++) {
      for (int x = 0; x < img2.width; x++) {
        img.pixels[x+img2.width*y] = img2.pixels[(img2.height-y-1)+img2.height*x];
      }
    }
    img.updatePixels();
    return img;
  }
}

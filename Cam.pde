class Cam {
  int x, y, w, h;
  Cam(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this. h = h;
  }

  void drawRect(int px, int py, int pw, int ph) {
    rect(px-x, py-y, pw, ph);
  }

  void drawLine(int x1, int y1, int x2, int y2) {
    line(x1-x, y1-y, x2-x, y2-y);
  }

  void update() {
    x = int(player.x + player.w/2 - width/2);
    y = int(player.y + player.h/2 - height/2);
  }

  void drawImage(PImage img, int x1, int y1, int w1, int h1) {
    image(img, x1-x, y1-y, w1, h1);
  }

  PVector getInImageCoord(int px, int py) {
    return new PVector(px-x, py-y);
  }
  
  int getInWorldX(int px) {
    return px + x;
  }
  int getInWorldY(int py) {
    return py + y;
  }

  PVector getInWorldCoord(int px, int py) {
    return new PVector(px+x, py+y);
  }
  PVector getInWorldCoord(PVector v) {
    return new PVector(v.x+x, v.y+y);
  }

  PVector getInWorldCoordBlock(int px, int py) {
    float rx = ((px+x)*1f/blockSize);
    float ry = ((py+y)*1f/blockSize);
    if (rx<0) {
      rx = -ceil(-rx);
    } else {
      rx = int(rx);
    }
    if (ry<0) {
      ry = -ceil(-ry);
    } else {
      ry = int(ry);
    }
    return new PVector(rx, ry);
  }
  
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

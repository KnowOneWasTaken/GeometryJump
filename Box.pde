class Wall extends Figure {
  int blockX, blockY, blockW, blockH;
  PImage box = wall, glow = wallGlow;
  Wall(int x, int y, int w, int h, int id) {
    super(x*blockSize, y*blockSize, w*blockSize, h*blockSize);
    this.blockX = x;
    this.blockY = y;
    this.blockW = w;
    this.blockH = h;
    this.id = id;
    box = wall;
    glow = wallGlow;
  }

  @Override void show() {
    show(wall);
  }

  @Override void showGlow() {
    showGlow(wallGlow);
  }
  void show(PImage img) {
    for (int i = 0; i < blockW; i++) {
      for (int j = 0; j < blockH; j++) {
        cam.drawImage(img, x+i*blockSize, y+j*blockSize, blockSize, blockSize);
      }
    }
  }
  
  void showGlow(PImage img) {
    for (int i = 0; i < blockW; i++) {
      for (int j = 0; j < blockH; j++) {
        cam.drawImage(img, int(x+i*blockSize-0.5*blockSize), int(y+j*blockSize-0.5*blockSize), blockSize*2, blockSize*2);
      }
    }
  }
}

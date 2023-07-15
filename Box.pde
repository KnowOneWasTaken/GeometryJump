class Box extends Figure {
  int blockX, blockY, blockW, blockH;
  Box(int x, int y, int w, int h, int id) {
    super(x*blockSize, y*blockSize, w*blockSize, h*blockSize);
    this.blockX = x;
    this.blockY = y;
    this.blockW = w;
    this.blockH = h;
    this.id = id;
  }

  @Override void show() {
    for (int i = 0; i < blockW; i++) {
      for (int j = 0; j < blockH; j++) {
        cam.drawImage(wall, x+i*blockSize, y+j*blockSize, blockSize, blockSize);
      }
    }
  }

  @Override void showGlow() {
    for (int i = 0; i < blockW; i++) {
      for (int j = 0; j < blockH; j++) {
        cam.drawImage(wallGlow, int(x+i*blockSize-0.5*blockSize), int(y+j*blockSize-0.5*blockSize), blockSize*2, blockSize*2);
      }
    }
  }
}

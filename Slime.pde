class Slime extends Box {
  Slime(int x, int y, int w, int h, int id) {
    super(x, y, w, h, id);
  }
  Slime() {
    super(0, 0, 0, 0, -1);
  }

  @Override void show() {
    for (int i = 0; i < blockW; i++) {
      for (int j = 0; j < blockH; j++) {
        cam.drawImage(slime, x+i*blockSize, y+j*blockSize, blockSize, blockSize);
      }
    }
  }

  @Override void showGlow() {
    for (int i = 0; i < blockW; i++) {
      for (int j = 0; j < blockH; j++) {
        cam.drawImage(slimeGlow, int(x+i*blockSize-0.5*blockSize), int(y+j*blockSize-0.5*blockSize), blockSize*2, blockSize*2);
      }
    }
  }
}

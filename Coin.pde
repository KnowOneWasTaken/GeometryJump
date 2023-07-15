class Coin extends Box {
  float animationState = 0, animationY = 0;
  Coin(int x, int y, int w, int h, int id) {
    super(x, y, w, h, id);
    hitbox.fest = false;
  }
  Coin() {
    super(0, 0, 0, 0, -1);
  }

  @Override void show() {
    animationState += 5f/frameRate;
    animation();
    for (int i = 0; i < blockW; i++) {
      for (int j = 0; j < blockH; j++) {
        cam.drawImage(coin, x+i*blockSize, int(y+j*blockSize+animationY), blockSize, blockSize);
      }
    }
  }

  void animation() {
    animationY = sin(animationState) * blockSize/12f;
  }

  @Override void showGlow() {
    for (int i = 0; i < blockW; i++) {
      for (int j = 0; j < blockH; j++) {
        cam.drawImage(coinGlow, int(x+i*blockSize-0.5*blockSize), int(y+j*blockSize-0.5*blockSize+animationY), blockSize*2, blockSize*2);
      }
    }
  }
}

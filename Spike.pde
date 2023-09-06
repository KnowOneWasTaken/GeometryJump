class Spike extends Wall {
  int rotation = 0;
  Spike(int x, int y, int w, int h, int id) {
    super(x, y, w, h, id);
    hitbox.solid = false;
    hitbox.updateCoord(x*blockSize+blockSize/8, y*blockSize+blockSize/8, w*blockSize-blockSize/4, h*blockSize-blockSize/4);
  }
  Spike(int x, int y, int w, int h, int id, int rotation) {
    super(x, y, w, h, id);
    hitbox.updateCoord(x*blockSize+blockSize/8, y*blockSize+blockSize/8, w*blockSize-blockSize/4, h*blockSize-blockSize/4);
    this.rotation = rotation;
    hitbox.solid = false;
  }
  Spike() {
    super(0, 0, 0, 0, -1);
    hitbox.solid = false;
  }

  @Override void show() {
    //hitbox.show();
    //PImage spikeRotation = spike;
    //switch(rotation) {
    //case 0:
    //  break;
    //case 1:
    //  spikeRotation = cam.rotateImage(spikeRotation);
    //  break;
    //case 2:
    //  spikeRotation = cam.rotateImage(spikeRotation);
    //  spikeRotation = cam.rotateImage(spikeRotation);
    //  break;
    //case 3:
    //  spikeRotation = cam.rotateImage(spikeRotation);
    //  spikeRotation = cam.rotateImage(spikeRotation);
    //  spikeRotation = cam.rotateImage(spikeRotation);
    //  break;
    //}
    if (editModeOn) {
      hitbox.show();
    }
    for (int i = 0; i < blockW; i++) {
      for (int j = 0; j < blockH; j++) {
        cam.drawImage(spike, x+i*blockSize, y+j*blockSize, blockSize, blockSize);
        break; //nach oben
      }
    }
  }
  @Override void showGlow() {
    for (int i = 0; i < blockW; i++) {
      for (int j = 0; j < blockH; j++) {
        cam.drawImage(spikeGlow, int(x+i*blockSize-0.5*blockSize), int(y+j*blockSize-0.5*blockSize), blockSize*2, blockSize*2);
      }
    }
  }
}

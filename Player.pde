class Player extends Figure {
  boolean grounded;
  float x, y, w, h;
  int blockX, blockY;
  Player(int x, int y, int w, int h) {
    super(x*blockSize, y*blockSize, w, h);
    this.x = x*blockSize;
    this.y = y*blockSize;
    this.w = w;
    this.h = h;
    grounded = false;
  }

  void gravity() {
    if (gravity || editModeOn == false) {
      vy = vy +1;
      if (y>250*blockSize) {
        resetToCheckpoint();
      }
    }
  }

  void resetToCheckpoint() {
    playSound(reset, 0.5, true);
    player.x = 0;
    player.y = -blockSize;
    vx = 0;
    vy = 0;
    println("Player got reset to Checkpoint");
  }

  void jump() {
    if (grounded) {
      if (getFigureAt(int(x+w/15f), int(y-blockSize/2)).hitbox.fest == false && getFigureAt(int(x+w-w/15f), int(y-blockSize/2)).hitbox.fest == false) {
        vy = vy - 18;
        playSound(jump, 0.5, true);
        println("jump");
      }
    }
  }

  void move(float dx, float dy) {
    x = x + dx;
    y = y + dy;

    hitbox.updateCoord(int(x), int(y), int(w), int(h));
  }

  @Override void show() {
    cam.drawImage(play, int(x), int(y), int(w), int(h));
    if (editModeOn) {
      fill(255);
      noStroke();
      text(int(grounded), 10, 10);
      text("vx: "+vx, 10, 22, 10);
      text("vy: "+vy, 10, 34, 10);
      text("x: "+x, 10, 22+24, 10);
      text("y: "+y, 10, 34+24, 10);
      text("mouseX: "+mouseX, 10, 22+24+24, 10);
      text("mouseY: "+mouseY, 10, 34+24+24, 10);
      text("BlockX: "+cam.getInWorldCoordBlock(mouseX, mouseY).x, 10, 22+24+24+24, 10);
      text("BlockY: "+cam.getInWorldCoordBlock(mouseX, mouseY).y, 10, 34+24+24+24, 10);
      text("editModeOn: "+editModeOn, 10, 22+24+24+24+24, 10);
      text("gravity: "+gravity, 10, 34+24+24+24+24, 10);
      text("Coins collected: "+coinsCollected, 10, 34+24+24+24+24+12, 10);
    }
  }

  @Override void update() {
    move(vx/2, vy/2);
    hitbox();
    move(vx/2, vy/2);
    blockX = int(cam.getInWorldCoordBlock(int(x), int(y)).x);
    blockX = int(cam.getInWorldCoordBlock(int(x), int(y)).y);
  }

  void hitbox() {
    grounded = false;
    int delID = -1;
    for (Figure f : worldFigures) {
      if (hitbox.overlap(f.hitbox)) {

        PVector move = f.hitbox.findNearestExit(hitbox);
        if (f.hitbox.fest == false) {
          if (f.getClass() == s.getClass()) {
            //if (sqrt(sq(move.x)+sq(move.y)) > w/8f) {
            if (editModeOn == false) {
              resetToCheckpoint();
            }
            //}
          }
          if (f.getClass() == co.getClass()&& editModeOn == false) {
            playSound(collectCoin, 0.7, true);
            delID = f.id;
            coinsCollected++;
          }
        } else {
          if (move.x != 0) {
            vx = 0;
            vy = vy*0.95;
            if (abs(vy) < 0.00001) {
              vy = 0;
            }
          }

          if (move.y != 0) {
            if (move.y < 0) {
              grounded = true;
            }
            vy = 0;
            vx = vx*0.6;
            if (abs(vx) < 0.00001) {
              vx = 0;
            }
          }
          if (f.getClass() == sl.getClass()) {
            if (grounded) {
              vy = vy -50;
              playSound(jumpSlime, 0.5, true);
              println("Slime jump");
            }
          }
          if (grounded) {
            move.x = 0;
          }
          if (move.x != 0) {
            //println("Player got shifted due to hitbox");
          }
          move(move.x, move.y);
        }
      }
    }
    if (delID!= -1 && editModeOn == false) { //removes a Coin when you are not in editMode
      removeFigure(delID);
    }
  }
}

class Player extends Figure {
  boolean grounded;
  float x, y, w, h;
  int blockX, blockY;
  PVector checkpointBlock = new PVector(0, -1);

  Player(int x, int y, int w, int h) {
    super(x*blockSize, y*blockSize, w, h);
    this.x = x*blockSize;
    this.y = y*blockSize;
    this.w = w;
    this.h = h;
    grounded = false;
    checkpointBlock = new PVector(0, -1);
  }

  void gravity() {
    if (gravity || editModeOn == false) {
      vy = vy +1;
      if (y>250*blockSize) {
        resetToCheckpoint(true);
      }
    }
  }

  void resetToCheckpoint(boolean animation) {
    if (getFigureAt(int(checkpointBlock.x*blockSize+blockSize/2), int(checkpointBlock.y*blockSize+blockSize+blockSize/2)).getClass() == ch.getClass()) {
      if (animation) {
        deathAnimation(int(x+w/2), int(y+h/2));
      }
      player.x = checkpointBlock.x*blockSize;
      player.y = (checkpointBlock.y)*blockSize;
      println("Player: resetToCheckpoint(): Player got reset to Checkpoint");
    } else {
      println("Player: resetToCheckpoint(): Checkpoint not found: Player got reset to default");
      if (animation) {
        deathAnimation(int(x+w/2), int(y+h/2));
      }
      framesSinceStarted = 0;
      player.x = 0;
      player.y = -blockSize;
    }
    if (worldFigures.size() != 0) {
      playSound(reset, 0.5, true);
    }
    vx = 0;
    vy = 0;
  }

  void jump() {
    if (grounded) {
      if (getFigureAt(int(x+w/15f), int(y-blockSize/2)).hitbox.solid == false && getFigureAt(int(x+w-w/15f), int(y-blockSize/2)).hitbox.solid == false) {
        vy = vy - 18;
        playSound(jump, 0.5, true);
        //println("Player: jump");
      }
    }
  }

  void move(float dx, float dy) {
    x = x + dx*(blockSize/60f);
    y = y + dy;

    hitbox.updateCoord(int(x), int(y), int(w), int(h));
  }

  @Override void show() {
    cam.drawImage(play, int(x), int(y), int(w), int(h));

    //displays data on the top left corner
    if (editModeOn) {
      fill(255);
      textSize(10);
      noStroke();
      text(int(grounded), 10, 10);
      text("vx: "+vx, 10, 22, 10);
      text("vy: "+vy, 10, 34, 10);
      text("x: "+x, 10, 22+24, 10);
      text("y: "+y, 10, 34+24, 10);
      text("mouseX: "+cam.getInWorldX(mouseX), 10, 22+24+24, 10);
      text("mouseY: "+cam.getInWorldY(mouseY), 10, 34+24+24, 10);
      text("BlockX: "+cam.getInWorldCoordBlock(mouseX, mouseY).x, 10, 22+24+24+24, 10);
      text("BlockY: "+cam.getInWorldCoordBlock(mouseX, mouseY).y, 10, 34+24+24+24, 10);
      text("editModeOn: "+editModeOn, 10, 22+24+24+24+24, 10);
      text("gravity: "+gravity, 10, 34+24+24+24+24, 10);
      text("Coins collected: "+coinsCollected, 10, 34+24+24+24+24+12, 10);
    }
  }

  @Override void update() {
    gravity();
    move(vx/2, vy*(blockSize/60f)/2);
    hitbox();
    move(vx/2, vy*(blockSize/60f)/2);
    blockX = int(cam.getInWorldCoordBlock(int(x), int(y)).x);
    blockX = int(cam.getInWorldCoordBlock(int(x), int(y)).y);
    hitbox();
    show();
  }

  void hitbox() {
    grounded = false;
    int delID = -1;
    for (Figure f : worldFigures) {
      if (hitbox.overlap(f.hitbox)) {

        PVector move = f.hitbox.findNearestExit(hitbox);
        if (f.hitbox.solid == false) {
          if (f.getClass() == s.getClass()) {
            //if (sqrt(sq(move.x)+sq(move.y)) > w/8f) {
            if (editModeOn == false) {
              resetToCheckpoint(true);
            }
            //}
          }
          if (f.getClass() == co.getClass()&& editModeOn == false) {
            playSound(collectCoin, 0.7, true);
            delID = f.id;
            coinAnimation(int(x+w/2), int(y+h));
            println("Player: hitbox(): Coin collected");
            coinsCollected++;
          }
        } else {
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
          if (move.x != 0) {
            vx = 0;
            vy = vy*0.95;
            if (abs(vy) < 0.00001) {
              vy = 0;
            }
          }

          if (f.getClass() == sl.getClass()) {
            if (grounded) {
              vy = vy - 50;
              playSound(jumpSlime, 0.5, true);
              slimeAnimation(int(x+w/2), int(y+h));
              //println("Player: hitbox(): Slime jump");
            }
          }
          if (f.getClass() == ch.getClass() || f.getClass() == go.getClass()) {
            if (grounded) {
              if (int(checkpointBlock.x) != int(f.x/blockSize) || int(checkpointBlock.y) != int((f.y/blockSize)-1)) {
                if (f.getClass() == go.getClass() && editModeOn == false) {
                  playSound(goalSound);
                  println("Goal reached! Level " + level+" finished. You have collected "+coinsCollected+" Coins and took "+framesSinceStarted+" frames!");
                  fill(255);
                  textSize(50);
                  text("You collected "+coinsCollected +" Coins!", width/2-textWidth("You collected ")/2, height/2);
                  JSONObject levelTimes;
                  try {
                    times = loadJSONArray("times.json");
                    try {
                      levelTimes = times.getJSONObject(level);
                      println("times.json loaded");
                    }
                    catch(Exception e2) {
                      println("Error in: Player: hitbox(): ");
                      println("Exception 2: "+e2);
                      levelTimes = new JSONObject();
                      levelTimes.setInt("frames", 2147483647);
                    }
                    levelTimes.setInt("level", level);
                    int frames = levelTimes.getInt("frames");
                    println("Player: hitbox(): frames Count in times.json found");
                    if (framesSinceStarted < frames) {
                      levelTimes.setInt("frames", framesSinceStarted);
                      times.setJSONObject(level, levelTimes);
                      saveJSONArray(times, "data/times.json");
                      println("Player: hitbox(): JSONArray for Times saved");
                    }
                  }
                  catch(Exception e) {
                    println("Error in: Player: hitbox(): ");
                    println(e);
                    JSONArray times = new JSONArray();
                    levelTimes = new JSONObject();
                    levelTimes.setInt("frames", framesSinceStarted);
                    levelTimes.setInt("level", level);
                    times.setJSONObject(level, levelTimes );
                    saveJSONArray(times, "data/times.json");
                    println("Player: hitbox(): New times.json made");
                  }
                  delay(3000);
                  inGame = false;
                } else {
                  checkpointBlock = new PVector(int(f.x/blockSize), int((f.y/blockSize)-1));
                  println("Player: hitbox(): Checkpoint reached: "+checkpointBlock.x + ", "+checkpointBlock.y+ "; Vector: "+new PVector(int(f.x/blockSize), int((f.y/blockSize)-1)));
                  playSound(collectCoin, 0.5, true);
                }
              }
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

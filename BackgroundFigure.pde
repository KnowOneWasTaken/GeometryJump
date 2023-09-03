class BackgroundFigure extends Figure {
  PImage img, imgGlow;
  float vx, vy;
  float posX, posY;
  float rotation, vRotate;
  BackgroundFigure(int x, int y, int w, int h) {
    super(x, y, w, h);
    this.vx = random(-0.7, 0.7);
    this.vy = random(-0.7, 0.7);
    posX = x;
    posY = y;
    rotation = int(random(0, 360));
    vRotate = int(random(-20, 20));
    switch(round(random(0, 6))) {
    case 0:
      img = play;
      imgGlow = null;
      break;
    case 1:
      img = spike;
      imgGlow = spikeGlow;
      break;
    case 2:
      img = wall;
      imgGlow = wallGlow;
      break;
    case 3:
      img = slime;
      imgGlow = slimeGlow;
      break;
    case 4:
      img = coin;
      imgGlow = coinGlow;
      break;
    case 5:
      img = checkpoint;
      imgGlow = checkpointGlow;
      break;
    case 6:
      img = checkpoint;
      imgGlow = goalGlow;
      break;
    default:
      img = play;
      imgGlow= null;
      break;
    }
  }

  @Override void show() {
    rotation += vRotate/10.0f;

    translate(int(x), int(y));
    rotate(int(rotation)/(20.0*PI));
    if (imgGlow != null) {
      image(imgGlow, -w, -h, w*2, h*2);
    }
    image(img, -w/2, -h/2, w, h);
    rotate(-int(rotation)/(20.0*PI));
    translate(-int(x), -int(y));
  }

  void checkPosition() {
    if (x > width + 3*w) {
      posX = -3*w;
    }
    if (x < -3*w) {
      posX = width + 3*w;
    }
    if (y > height + 3*h) {
      posY = -3*h;
    }
    if (y < -3*h) {
      posY = height + 3*h;
    }
  }

  void move() {
    posX = posX + vx;
    posY = posY + vy;
    x = int(posX);
    y = int(posY);
  }
}

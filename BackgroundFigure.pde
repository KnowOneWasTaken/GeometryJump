class BackgroundFigure extends Figure {
  PImage img, imgGlow;
  float posX, posY;
  float rotation, vRotate;
  BackgroundFigure(int x, int y, int w, int h) {
    super(x, y, w, h);
    super.vx = random(-0.7, 0.7);
    super.vy = random(-0.7, 0.7);
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
    if (x > width + 2*w) {
      posX = -2*w;
    }
    if (x < -2*w) {
      posX = width + 2*w;
    }
    if (y > height + 2*h) {
      posY = -2*h;
    }
    if (y < -2*h) {
      posY = height + 2*h;
    }
  }
  
  void update() {
   if(mousePressed) {
      super.vx = super.vx + (mouseX-posX)*(1f/(dist(mouseX,mouseY,posX,posY)*dist(mouseX,mouseY,posX,posY))); 
      super.vy = super.vy + (mouseY-posY)*(1f/(dist(mouseX,mouseY,posX,posY)*dist(mouseX,mouseY,posX,posY))); 
   }
   for(BackgroundFigure p : bgFigures) {
     super.vx = super.vx + 10*((p.w/70f)*(p.posX-posX)*(1f/(dist(p.posX,p.posY,posX,posY)*dist(p.posX,p.posY,posX,posY)+0.0000000000001)))/w; 
     super.vy = super.vy + 10*((p.w/70f)*(p.posY-posY)*(1f/(dist(p.posX,p.posY,posX,posY)*dist(p.posX,p.posY,posX,posY)+0.0000000000001)))/w; 
   }
  }

  void move() {
    posX = posX + super.vx;
    posY = posY + super.vy;
    x = int(posX);
    y = int(posY);
  }
}

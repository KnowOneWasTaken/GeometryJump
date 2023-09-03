class Particle {
  int x, y, size;
  float vx, vy;
  boolean gravity;
  float opacity;
  float time;
  float rotation, vRotate;
  PImage img;
  int maxTime;
  Particle(int x, int y, PImage img) {
    this.x = x;
    this.y = y;
    this.img = img;
    vx = random(-5, 5);
    vy = random(-20, -5);
    maxTime = int(random(40, 80));
    time = 0;
    rotation = random(0, 360);
    vRotate = vx*3+random(-0.7,0.7);
    opacity = 255;
    gravity = true;
    size = 20;
  }

  void show() {
    rotation += round(vRotate/10.0);
    translate(x, y);
    rotate(rotation/(2.0*PI));
    tint(255, opacity);
    cam.drawImage(img, -size/2, -size/2, size, size);
    rotate(-rotation/(2.0*PI));
    translate(-x, -y);
    tint(255, 255);
  }



  void update() {
    move(int(vx), int(vy));
    time++;
    opacity = 255 * ((maxTime-time)/maxTime);
    if (gravity) {
      vy = vy + 0.7;
    }

    if (time > maxTime) {
      opacity = 0;
      particles.remove(this);
    }
    show();
  }

  void move(int dx, int dy) {
    x = x + dx;
    y = y + dy;
  }
}

class Figure {
  int x, y, w, h;
  float vx;
  float vy;
  int id = 0;
  Hitbox hitbox;
  Figure(int x, int y, int w, int h, int id) {
    this.x = x;
    this.y = y;
    this.w = w;
    this. h = h;
    this.id = id;
    vx = 0;
    vy = 0;
    hitbox = new Hitbox(x, y, w, h);
  }
  Figure(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this. h = h;
    this.id = -1;
    vx = 0;
    vy = 0;
    hitbox = new Hitbox(x, y, w, h);
  }
  Figure() {
    x = 0;
    y = 0;
    w = -1;
    h = -1;
    id = -1;
    hitbox = new Hitbox(x, y, w, h);
    hitbox.fest = false;
  }

  void show() {
    fill(255);
    stroke(255, 0, 0);
    strokeWeight(2);
    cam.drawRect(x, y, w, h);
    //hitbox.show();
  }



  void update() {
    move(int(vx), int(vy));
  }

  void move(int dx, int dy) {
    x = x + dx;
    y = y + dy;
    hitbox.updateCoord(x, y, w, h);
  }

  void showGlow() {
  }
}
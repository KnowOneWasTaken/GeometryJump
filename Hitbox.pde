class Hitbox {
  int x1, y1, x2, y2, x3, y3, x4, y4, w, h;
  boolean solid = true;

  Hitbox(int x, int y, int w, int h) {
    this.x1 = x; //top left corner
    this.y1 = y;
    this.x2 = x + w; //top right corner
    this.y2 = y;
    this.x3 = x + w; //bottom right corner
    this.y3 = y+h;
    this.x4 = x; //bottom left corner
    this.y4 = y + h;
    this.w = w;
    this.h = h;
  }

  void updateCoord(int x, int y, int w, int h) {
    this.x1 = x; //top left corner
    this.y1 = y;
    this.x2 = x + w; //top right corner
    this.y2 = y;
    this.x3 = x + w; //bottom right corner
    this.y3 = y+h;
    this.x4 = x; //bottom left corner
    this.y4 = y + h;
    this.w = w;
    this.h = h;
  }

  void show() {
    fill(0, 0, 0, 0);
    stroke(0, 255, 0);
    strokeWeight(1);
    cam.drawRect(x1, y1, w, h);
    strokeWeight(2);
  }

//returns true, if the specified hitbox is within the hitbox of itself
  boolean overlap(Hitbox h) {
    if (h.x2 > x1 && h.x1 < x2) {
      if (h.y3 > y1 && h.y1 < y3) {
        return true;
      }
    }
    return false;
  }



  PVector findNearestExit(Hitbox h) {
    if (overlap(h)) {
      //boolean[] corners = findCornerInHitbox(h);

      int oben = h.y1 - y1;
      int unten = y3 - h.y3;
      int rechts = x2 - h.x2;
      int links = h.x1 - x1;
      int[] dist = new int[4];
      dist[0] = oben;
      dist[1] = unten;
      dist[2] = rechts;
      dist[3] = links;
      int[] richtung = new int[4];
      richtung[0] = 0;
      richtung[1] = 1;
      richtung[2] = 2;
      richtung[3] = 3;
      for (int i = 0; i < dist.length; i++) {
        for (int j = 0; j < dist.length-1; j++) {
          if (dist[j] < dist[j+1]) {
            int temp = dist[j];
            int tempS = richtung[j];
            dist[j] = dist[j+1];
            dist[j+1] = temp;
            richtung[j] = richtung[j+1];
            richtung[j+1] = tempS;
          }
        }
      }
      int distanz = dist[3];
      int r = richtung[3];
      ;
      for (int i = 2; i <= 0; i--) {
        if (dist[i] < dist[i+1] && dist[i] > 0) {
          distanz = dist[i];
          r = richtung[i];
        }
      }
      switch(r) {
      case 0:
        return new PVector(0, -distanz-h.h);
      case 1:
        return new PVector(0, distanz+h.h);
      case 2:
        return new PVector(distanz+h.w, 0);
      case 3:
        return new PVector(-distanz-h.w, 0);
      }

      return null;
    } else {
      return null;
    }
  }

  boolean[] findCornerInHitbox(Hitbox h) {
    boolean[] corners = new boolean[4];
    for (boolean b : corners) {
      b = false;
    }
    if (pointInHitbox(h.x1, h.y1)) {
      corners[0] = true;
    }
    if (pointInHitbox(h.x2, h.y2)) {
      corners[1] = true;
    }
    if (pointInHitbox(h.x3, h.y3)) {
      corners[2] = true;
    }
    if (pointInHitbox(h.x4, h.y4)) {
      corners[3] = true;
    }
    return corners;
  }

  boolean pointInHitbox(int x, int y) {
    return x > x1 && x < x2 && y > y1 && y < y3;
  }

  boolean pointInHitbox(PVector v) {
    return pointInHitbox(int(v.x), int(v.y));
  }
}

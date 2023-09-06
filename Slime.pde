class Slime extends Wall {
  PImage box = slime, glow = slimeGlow;
  Slime(int x, int y, int w, int h, int id) {
    super(x, y, w, h, id);
    box = slime;
    glow = slimeGlow;
  }
  Slime() {
    super(0, 0, 0, 0, -1);
    box = slime;
    glow = slimeGlow;
  }

  @Override void show() {
    show(slime);
  }
  @Override void showGlow() {
    showGlow(slimeGlow);
  }
}

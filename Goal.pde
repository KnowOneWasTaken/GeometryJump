class Goal extends Checkpoint {
  Goal(int x, int y, int w, int h, int id) {
    super(x, y, w, h, id);
    glow = goalGlow;
  }
  Goal() {
    super();
  }
  @Override void showGlow() {
    showGlow(goalGlow);
  }
}

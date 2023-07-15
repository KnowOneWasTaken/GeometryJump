import processing.sound.*;
SoundFile click, background1, reset, jump, jumpSlime, collectCoin;

Figure ground;
PImage spike, wall, play, spikeGlow, slime, slimeGlow, wallGlow, remove, coin, coinGlow;
ArrayList<Figure> worldFigures = new ArrayList<Figure>();
Player player;
Cam cam;
int blockSize = 60;
boolean[] keysPressed = new boolean[65536];
JSONArray world;
String editMode = "wall";
boolean editModeOn = false;
boolean gravity = true;

Spike s; //Spike just to getClass()
Slime sl; //Slime just to getClass()
Coin co;

void setup() {
  fullScreen(P3D);
  frameRate(50);
  //size(1920, 1080, P2D);
  world = new JSONArray();
  try {
    reloadFigures();
    updateIDs();
    println(worldFigures);
  }
  catch(Exception e) {
    println("No world map found");
    world = new JSONArray();
    addFigure("wall", 0, 0, 1, 1);
  }
  s = new Spike();
  sl = new Slime();
  co = new Coin();
  player = new Player(0, -1, 60, 60);
  cam = new Cam(0, 0, 540, 540);

  loadImages();
  thread("loadSounds");
}

void draw() {

  background(0);
  stroke(40);
  //int quadrat = blockSize*2;
  cam.update();
  //for (int i = 0; i <= width+ quadrat; i = i+quadrat) {
  //  cam.drawLine(int(cam.x/quadrat)*quadrat+i, cam.y, int(cam.x/quadrat)*quadrat+i, cam.y + height);
  //}
  //for (int i = 0; i <= height +quadrat; i = i+quadrat) {
  //  cam.drawLine(cam.x, int(cam.y/quadrat)*quadrat+i, cam.x + width, int(cam.y/quadrat)*quadrat+i);
  //}
  keyListener();
  for (Figure f : worldFigures) {
    f.show();
  }
  for (Figure f : worldFigures) {
    f.showGlow();
  }
  player.gravity();
  player.update();
  player.hitbox();
  player.show();
  showEditMode();
  playSound(background1, 0.2);
}

void showEditMode() {
  if (editModeOn) {
    PImage img, imgGlow;
    switch(editMode) {
    case "wall":
      img = wall;
      imgGlow = wallGlow;
      break;
    case "spike":
      img = spike;
      imgGlow = spikeGlow;
      break;
    case "slime":
      img = slime;
      imgGlow = slimeGlow;
      break;
    case "remove":
      img = remove;
      imgGlow = remove;
      break;
    case "coin":
      img = coin;
      imgGlow = coinGlow;
      break;
    default:
      img = wall;
      imgGlow = wallGlow;
      break;
    }
    image(img, blockSize/2, height - blockSize, blockSize/2, blockSize/2);
    image(imgGlow, blockSize/4, height - blockSize-blockSize/4, blockSize, blockSize);
  }
}

Figure createFigure(String ObjectClass, int x, int y, int w, int h, int id) {
  switch(ObjectClass) {
  case "wall":
    return new Box(x, y, w, h, id);
  case "spike":
    return new Spike(x, y, w, h, id);
  case "slime":
    return new Slime(x, y, w, h, id);
  case "coin":
    return new Coin(x, y, w, h, id);
  default:
    println("Error in Main createFigure(), createFigure(): ObjectClass coujld'nt be resolved");
    return new Figure(0, 0, 0, 0, -1);
  }
}

void addFigure(String ObjectClass, int x, int y, int w, int h) {
  JSONObject figure = new JSONObject();
  int id;
  if (world != null) {
    id = world.size();
  } else {
    id = 0;
  }
  figure.setInt("id", id);
  figure.setString("class", ObjectClass);
  figure.setInt("x", x);
  figure.setInt("y", y);
  switch(editMode) {
  case "wall":
    worldFigures.add(new Box(x, y, w, h, id));
    break;
  case "spike":
    worldFigures.add(new Spike(x, y, w, h, id, 1));
    break;
  case "slime":
    worldFigures.add(new Slime(x, y, w, h, id));
    break;
  }
  world.setJSONObject(id, figure);
  saveJSONArray(world, "data/world.json");
}

void removeFigure(int id) {
  try {
    world.remove(id);
    worldFigures.remove(id);
    saveJSONArray(world, "data/world.json");
    updateIDs();
  }
  catch(Exception e) {
    println("Error while removing a Figure: id: "+id+", worldFigures.size():"+worldFigures.size());
    println("Error catched:");
    println(e);
  }
}

void updateIDs() {
  JSONArray temp = loadJSONArray("world.json");

  for (int i = 0; i < temp.size(); i++) {
    JSONObject jsn = temp.getJSONObject(i);
    jsn.setInt("id", i);
  }
  world = temp;
  reloadFigures();
  saveJSONArray(temp, "data/world.json");
}

void reloadFigures() {
  world = loadJSONArray("world.json");
  worldFigures.clear();
  for (int i = 0; i < world.size(); i++) {
    JSONObject jsn = world.getJSONObject(i);
    worldFigures.add(createFigure(jsn.getString("class"), jsn.getInt("x"), jsn.getInt("y"), 1, 1, jsn.getInt("id")));
  }
}


void mouseReleased() {
  println(getFigureAt(cam.getInWorldCoord(mouseX, mouseY)).getClass());
  if (editModeOn) {
    if (editMode != "remove") {
      addFigure(editMode, int(cam.getInWorldCoordBlock(mouseX, mouseY).x), int(cam.getInWorldCoordBlock(mouseX, mouseY).y), 1, 1);
      updateIDs();
    } else {
      Figure f = getFigureAt(cam.getInWorldCoord(mouseX, mouseY));
      if (f.id != -1) {
        println("Trying to remove Figure, id: "+f.id);
        removeFigure(f.id);
        updateIDs();
        println("Figure removed");
        playSound(click, 0.5, true);
      } else {
        println("MouseReleased: RemoveFigure: No Figure at this position found!");
      }
    }
  }
}

Figure getFigureAt(int x, int y) {
  for (Figure f : worldFigures) {
    if (f.hitbox.pointInHitbox(x, y)) {
      println("Found Figure of class: "+f.getClass() + ", at: "+x+", "+y+"; id: "+f.id);
      return f;
    }
  }
  if (player.hitbox.pointInHitbox(cam.getInWorldCoord(x, y))) {
    println("Found Player Figure at: "+x+", "+y+"; id: "+player.id);
    return player;
  }
  println("No element of Environment on this position found: "+x+", "+y+"; id: "+"-1");
  return new Figure();
}

Figure getFigureAt(PVector v) {
  return getFigureAt(int(v.x), int(v.y));
}

void keyPressed() {
  keysPressed[keyCode] = true;
  keysPressed[key] = true;
}

void keyReleased() {
  keysPressed[keyCode] = false;
  keysPressed[key] = false;
  if (key == 'r') {
    loadImages();
  }
  if (key == 'b') {
    editMode = "wall";
  }
  if (key == 'n') {
    editMode = "spike";
  }
  if (key == 'm') {
    editMode = "slime";
  }
  if (key == ',') {
    editMode = "remove";
  }
  if (key == 'c') {
    editMode = "coin";
  }
  if (key == 'g') {
    gravity = !gravity;
  }
  if (key == 'e') {
    editModeOn = !editModeOn;
  }
}

void loadImages() {
  spike = loadImage("spike.png");
  wall = loadImage("wall.png");
  play = loadImage("player.png");
  spikeGlow = loadImage("spikeGlow.png");
  slime = loadImage("slime.png");
  slimeGlow = loadImage("slimeGlow.png");
  wallGlow = loadImage("wallGlow.png");
  remove = loadImage("remove.png");
  coinGlow = loadImage("coinGlow.png");
  coin = loadImage("coin.png");
}

void loadSounds() {
  click = new SoundFile(this, "click interface.mp3");
  reset = new SoundFile(this, "reset.mp3");
  background1 = new SoundFile(this, "background1.mp3");
  jump = new SoundFile(this, "jump.mp3");
  jumpSlime = new SoundFile(this, "jumpSlime.mp3");
  collectCoin = new SoundFile(this,"collectCoin.mp3");
}

void playSound(SoundFile sound) {
  playSound(sound, 1, false);
}

void playSound(SoundFile sound, float amp) {
  playSound(sound, amp, false);
}

void playSound(SoundFile sound, float amp, boolean multiple) {
  if (sound != null) {
    if (sound.isPlaying() == false || multiple) {
      sound.play();
      sound.amp(amp);
    }
  }
}

void keyListener() {
  int speed = 2;
  int maxSpeed = 12;

  if (editModeOn) {
    if (keysPressed['w']) {
      if (player.vy >-maxSpeed) {
        player.vy -= speed;
      }
    }
    // Check if 's' key is pressed
    if (keysPressed['s']) {
      if (player.vy < maxSpeed) {
        player.vy += speed;
      }
    }
  }


  // Check if 'a' key is pressed
  if (keysPressed['a']) {
    if (player.vx >-maxSpeed) {
      player.vx -= speed;
    }
  }



  //  // Check if 'd' key is pressed
  if (keysPressed['d']) {
    if (player.vx < maxSpeed) {
      player.vx += speed;
    }
  }

  //  // Check if spacebar (' ') is pressed
  if (keysPressed[' ']) {
    player.jump();
  }
}

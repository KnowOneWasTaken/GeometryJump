//This section imports the necessary sound libraries used in the program.
import processing.sound.*;
SoundFile click, background1, reset, jump, jumpSlime, collectCoin;

//These are variable declarations used throughout the program. They include objects such as figures, images, player, camera, and various flags and settings.
PImage spike, wall, play, spikeGlow, slime, slimeGlow, wallGlow, remove, coin, coinGlow, checkpoint, checkpointGlow, BEditModeOn, BEditModeOff;

Button Edit;

ArrayList<Figure> worldFigures = new ArrayList<Figure>();
Player player;
Cam cam;
int blockSize = 60;
boolean[] keysPressed = new boolean[65536];
JSONArray world;
String editMode = "wall";
boolean editModeOn = false;
boolean gravity = true;
int coinsCollected = 0;

Spike s; //Spike just to getClass()
Slime sl; //Slime just to getClass()
Coin co;
Checkpoint ch;
boolean inGame = false;
int level = 0;

//called once at launch
void setup() {
  fullScreen(P3D);
  frameRate(50);

  loadImages();
  thread("loadSounds");

  //size(1920, 1080, P2D);
  world = new JSONArray();

  try { // trys to load the world.json file
    reloadFigures();
    updateIDs();
    println(worldFigures);
  }
  catch(Exception e) { //if the file could'nt be loaded: adds one block beneath the player
    println("No world map found");
    world = new JSONArray();
    addFigure("wall", 0, 0, 1, 1);
  }

  s = new Spike();
  sl = new Slime();
  co = new Coin();
  ch = new Checkpoint();
  player = new Player(0, -1, 60, 60);
  cam = new Cam(0, 0, 540, 540);

  Edit = new Button(true, BEditModeOff, BEditModeOn, false, width-180, 20, 160, 80);
}

//called in loop: It is responsible for continuously updating and rendering the graphics and animations of the program.
void draw() {

  background(0);
  stroke(40);
  //int quadrat = blockSize*2;
  //for (int i = 0; i <= width+ quadrat; i = i+quadrat) {
  //  cam.drawLine(int(cam.x/quadrat)*quadrat+i, cam.y, int(cam.x/quadrat)*quadrat+i, cam.y + height);
  //}
  //for (int i = 0; i <= height +quadrat; i = i+quadrat) {
  //  cam.drawLine(cam.x, int(cam.y/quadrat)*quadrat+i, cam.x + width, int(cam.y/quadrat)*quadrat+i);
  //}
  cam.update();
  keyListener();

  //Calls show() and showGlow() for every Figure of the worldFigures
  for (Figure f : worldFigures) {
    f.show();
  }
  for (Figure f : worldFigures) {
    f.showGlow();
  }

  //updates the player: adds Gravity to speed, moves the player while checking the hitboxes and displaying it when position is calculated
  player.update();

  //displays the block, which is currently selected for edit,if you are in editModeOn
  showEditMode();

  //plays the background1 sound in a loop when it's loaded
  playSound(background1, 0.2);

  Edit.show();
}

//This function is responsible for displaying the current edit mode on the screen. It uses different images based on the selected edit mode.
//It is called in draw()
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
      img = null;
      imgGlow = remove;
      break;
    case "coin":
      img = coin;
      imgGlow = coinGlow;
      break;
    case "checkpoint":
      img = checkpoint;
      imgGlow = checkpointGlow;
      break;
    default:
      img = wall;
      imgGlow = wallGlow;
      break;
    }
    if (img != null) {
      image(img, blockSize/2, height - blockSize, blockSize/2, blockSize/2);
    }
    image(imgGlow, blockSize/4, height - blockSize-blockSize/4, blockSize, blockSize);
  }
}

//This function creates a new instance of a Figure object based on the given parameters. The object's class is determined by the ObjectClass parameter.
//If an error occured, a Figure with id = -1 gets returned
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
  case "checkpoint":
    return new Checkpoint(x, y, w, h, id);
  default:
    println("Error in Main createFigure(), createFigure(): ObjectClass coujld'nt be resolved");
    return new Figure(0, 0, 0, 0, -1);
  }
}


/* This function adds a new figure to the world. It creates a JSON object representing the figure and adds it to the world JSONArray.
 The figure is also added to the worldFigures ArrayList. */
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
  case "coin":
    worldFigures.add(new Coin(x, y, w, h, id));
    break;
  case "checkpoint":
    worldFigures.add(new Checkpoint(x, y, w, h, id));
    break;
  }
  world.setJSONObject(id, figure);
  saveJSONArray(world, "data/world.json");
  println("Added Figure of class: "+ObjectClass);
}


//This function removes a figure from the world based on its ID. It removes the corresponding JSON object from the world JSONArray and removes the figure from the worldFigures ArrayList.
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
    updateIDs();
  }
}


//This function updates the IDs of the figures in the world JSONArray. It is called after a figure is removed to ensure the IDs remain sequential.
void updateIDs() {
  JSONArray temp = loadJSONArray("world.json");

  for (int i = 0; i < temp.size(); i++) {
    JSONObject jsn = temp.getJSONObject(i);
    jsn.setInt("id", i);
  }
  world = temp;
  saveJSONArray(temp, "data/world.json");
  reloadFigures();
}


//This function reloads the figures from the world.json file into the worldFigures ArrayList. It is called at the start of the program and after updating the IDs.
void reloadFigures() {
  world = loadJSONArray("world.json");
  worldFigures.clear();
  for (int i = 0; i < world.size(); i++) {
    JSONObject jsn = world.getJSONObject(i);
    worldFigures.add(createFigure(jsn.getString("class"), jsn.getInt("x"), jsn.getInt("y"), 1, 1, jsn.getInt("id")));
  }
}


//This function is called when the mouse button is released. It determines the action based on the current edit mode and mouse position.
void mouseReleased() {
  println(getFigureAt(cam.getInWorldCoord(mouseX, mouseY)).getClass());
  if (editModeOn && Edit.touch() == false) {
    if (editMode != "remove") {
      addFigure(editMode, int(cam.getInWorldCoordBlock(mouseX, mouseY).x), int(cam.getInWorldCoordBlock(mouseX, mouseY).y), 1, 1);
      playSound(click, 0.5, true);
      //updateIDs();
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
  if (Edit.touch()&&mouseButton==LEFT) {
    editModeOn = !editModeOn;
    Edit.pictureChange();
  }
}


//This function returns the figure at the given coordinates (x, y) in the world. It searches through the worldFigures ArrayList and checks if the player figure is present at the given coordinates as well.
Figure getFigureAt(int x, int y) {
  for (Figure f : worldFigures) {
    if (f.hitbox.pointInHitbox(x, y)) {
      println("Found Figure of class: "+f.getClass() + ", at: "+x+", "+y+"; id: "+f.id);
      return f;
    }
  }
  if (player.hitbox.pointInHitbox(x, y)) { //Edit: if (player.hitbox.pointInHitbox(cam.getInWorldCoord(x, y))) {
    println("Found Player Figure at: "+x+", "+y+"; id: "+player.id);
    return player;
  }
  println("No element of Environment on this position found: "+x+", "+y+"; id: "+"-1");
  return new Figure();
}

//This function returns the Figure at a given Position (in PVector)
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
  if (key == 'v') {
    editMode = "checkpoint";
  }
  if (key == 'g') {
    gravity = !gravity;
  }
  if (key == 'e') {
    editModeOn = !editModeOn;
    Edit.pictureChange();
  }
}


//This function loads the necessary images used in the program.
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
  checkpointGlow = loadImage("checkpointGlow.png");
  checkpoint = loadImage("checkpoint.png");
  BEditModeOff = loadImage("BEditModeOff.png");
  BEditModeOn = loadImage("BEditModeOn.png");
}


//This function loads the necessary sound files used in the program.
void loadSounds() {
  click = new SoundFile(this, "click interface.mp3");
  reset = new SoundFile(this, "reset.mp3");
  background1 = new SoundFile(this, "background1.mp3");
  jump = new SoundFile(this, "jump.mp3");
  jumpSlime = new SoundFile(this, "jumpSlime.mp3");
  collectCoin = new SoundFile(this, "collectCoin.mp3");
}

void playSound(SoundFile sound) {
  playSound(sound, 1, false);
}

void playSound(SoundFile sound, float amp) {
  playSound(sound, amp, false);
}


//This plays a SoundFile with specified volume ('amp'). If 'multiple' is true, it plays the sound again, even when this sound is already playing (multiple times at the same time)
void playSound(SoundFile sound, float amp, boolean multiple) {
  if (sound != null) {
    if (sound.isPlaying() == false || multiple) {
      sound.play();
      sound.amp(amp);
    }
  }
}


//This function handles the key inputs for movement and other actions in the game.
void keyListener() {
  int speed = 2;
  int maxSpeed = 12;

  if (editModeOn) {
    // Check if 'w' key is pressed
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



  // Check if 'd' key is pressed
  if (keysPressed['d']) {
    if (player.vx < maxSpeed) {
      player.vx += speed;
    }
  }

  // Check if spacebar (' ') is pressed
  if (keysPressed[' ']) {
    player.jump();
  }
}

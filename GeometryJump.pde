//This section imports the necessary sound library and declares the SoundFiles used in the program.
import processing.sound.*;
SoundFile click, background1, reset, jump, jumpSlime, collectCoin, goalSound, tabChange;

//These are variable declarations used throughout the program. They include objects such as figures, images, player, camera, and various flags and settings.
PImage spike, wall, play, spikeGlow, slime, slimeGlow, wallGlow, remove, coin, coinGlow, checkpoint, checkpointGlow, BEditModeOn, BEditModeOff, BLevel1, BLevel1Glow, BLevel2, right, rightGlow, left, leftGlow, BLevelX, goalGlow, particleStar,
  particleWall, clear, ButtonEXIT, particleSlime;

Button Edit, Level1, Level2, SkipRight, SkipLeft, LevelX, Exit;

ArrayList<Particle> particles = new ArrayList<Particle>();

ArrayList<Figure> worldFigures = new ArrayList<Figure>();
Player player;
Cam cam;
int blockSize = 60; //indicates how many pixels a block is large
boolean[] keysPressed = new boolean[65536]; //used to check if a key is pressed or not
JSONArray world; //The json-Array that contains the figures of the environment
JSONArray times; //contains the times (frame-Counts) in which the player has completed the levels (best scores)
String editMode = "wall"; //default for the world-edit mode: selects box/walls as the default to add to your world in editModeOn
boolean editModeOn = false; //idicates if the editMode is on or off
boolean gravity = true; //indicates if gravity is in editModeOn active or not
int coinsCollected = 0; //indicates how many coins the player has collected in a level
float gameZoom = 1.8; //makes the gameplay bigger (zooms in), when you are on a smartphone

//objects just to get their .getClass()
Spike s;
Slime sl;
Coin co;
Checkpoint ch;
Goal go;

boolean inGame = false; //indicates if the game is running (true) or if the player is in the menue (false)
int level = 1; //selects level 1 as default
int levelAmount = 8; //indicates how many levels there are which should not be altered by in Game editing
int levelAmountButtons = 0; //indicates how many button-images/ buttons there are for the level-selection
int framesSinceStarted = 0; //counts the frames, since the player has started a level (reset by death)

BackgroundFigure[] bgFigures = new BackgroundFigure[15]; //Figures floating in Menue
boolean everythingLoaded = false;

//called once at launch
void setup() {
  fullScreen(P2D);
  //size(480, 300);

  frameRate(50);

  loadImages();
  thread("loadSounds");

  s = new Spike();
  sl = new Slime();
  co = new Coin();
  ch = new Checkpoint();
  go = new Goal();

  cam = new Cam(0, 0, 1920, 1080);

  Edit = new Button(true, BEditModeOff, BEditModeOn, false, int(width-180*(width/1920f)), int(20*(height/1080f)), int(160*(width/1920f)), int(80*(height/1080f)));
  Exit = new Button(true, ButtonEXIT, ButtonEXIT, false, int(width-180*(width/1920f)), int(105*(height/1080f)), int(160*(width/1920f)), int(80*(height/1080f)));
  Level1 = new Button(true, BLevel1, BLevel1Glow, false, width/2-int(320*(width/1920f)), height/2-int(220*(height/1080f)), int(640*(width/1920f)), int(440*(height/1080f)), 1, false, true);
  Level2 = new Button(true, BLevel2, BLevel1Glow, false, int(width/2-320*(width/1920f)), int(height/2-220*(height/1080f)), int(640*(width/1920f)), int(440*(height/1080f)), 1, false, true);
  LevelX = new Button(true, BLevelX, BLevel1Glow, false, int(width/2-320*(width/1920f)), int(height/2-220*(height/1080f)), int(640*(width/1920f)), int(440*(height/1080f)), 1, false, true);
  SkipRight = new Button(true, right, rightGlow, false, int(width/2+(320+50)*(width/1920f)), int(height/2-75*(height/1080f)), int(100*(width/1920f)), int(150*(height/1080f)), 1, false, true);
  SkipLeft = new Button(true, left, leftGlow, false, int(width/2+(-320-50-100)*(width/1920f)), int(height/2-75*(height/1080f)), int(100*(width/1920f)), int(150*(height/1080f)), 1, false, true);

  if (height > width) {
    SkipRight = new Button(true, right, rightGlow, false, int(width/2+(550+40)*(width/1920f)), int(height/2-75*(height/1080f)), int(200*(width/1920f)), int(150*(height/1080f)), 1, false, true);
    SkipLeft = new Button(true, left, leftGlow, false, int(width/2-(550+40+200)*(width/1920f)), int(height/2-75*(height/1080f)), int(200*(width/1920f)), int(150*(height/1080f)), 1, false, true);
    Level1 = new Button(true, BLevel1, BLevel1Glow, false, int(width/2-(550)*(width/1920f)), height/2-int(110*(height/1080f)), int((1100)*(width/1920f)), int(220*(height/1080f)), 1, false, true);
    Level2 = new Button(true, BLevel2, BLevel1Glow, false, int(width/2-(550)*(width/1920f)), int(height/2-110*(height/1080f)), int((1100)*(width/1920f)), int(220*(height/1080f)), 1, false, true);
    LevelX = new Button(true, BLevelX, BLevel1Glow, false, int(width/2-(550)*(width/1920f)), int(height/2-110*(height/1080f)), int((1100)*(width/1920f)), int(220*(height/1080f)), 1, false, true);
    Edit = new Button(true, BEditModeOff, BEditModeOn, false, int(width-410*(width/1920f)), int(20*(height/1080f)), int(400*(width/1920f)), int(60*(height/1080f)));
    Exit = new Button(true, ButtonEXIT, ButtonEXIT, false, int(width-410*(width/1920f)), int(85*(height/1080f)), int(400*(width/1920f)), int(60*(height/1080f)));
  }

  setupBGAnimation();
  player = new Player(0, -1, blockSize, blockSize);
}

//called in loop: It is responsible for continuously updating and rendering the graphics and animations of the program.
void draw() {

  if (inGame) {
    framesSinceStarted++;
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
      f.showGlow();
    }
    for (Figure f : worldFigures) {
      f.show();
    }

    //updates the player: adds Gravity to speed, moves the player while checking the hitboxes and displaying it when position is calculated
    player.update();

    //displays the block, which is currently selected for edit,if you are in editModeOn
    showEditMode();

    //plays the background1 sound in a loop when it's loaded
    playSound(background1, 0.2);
    Edit.show();
    Exit.show();
  } else {
    background(0);

    if (everythingLoaded) {
      playSound(background1, 0.2);
      switch(level) {
      case 1:
        Level1.show();
        break;
      case 2:
        Level2.show();
        break;
      default:
        LevelX.show();
        fill(255);
        if (LevelX.touch()) {
          fill(150, 150, 200);
        } else {
          fill(255);
        }
        if (width> height) {
          textSize(170*(width/1920f));
          text(level, 1180*(width/1920f), 590*(height/1080f));
        } else {
          textSize(175*(width/1080f));
          text(level, 735*(width/1080f), (height/2f)+50);
        }
      }
      SkipRight.show();
      SkipLeft.show();
    }
    backgroundAnimation();
  }
  for (int i = 0; i < particles.size(); i++) {
    particles.get(i).update();
  }
}

void backgroundAnimation() {
  for (int i = 0; i < bgFigures.length; i++) {
    bgFigures[i].move();
    bgFigures[i].checkPosition();
    bgFigures[i].show();
  }
}

void setupBGAnimation() {
  for (int i = 0; i < bgFigures.length; i++) {
    int size = int(random(20, 70));
    bgFigures[i] = new BackgroundFigure(int(random(0, width)), int(random(0, height)), size, size);
  }
}

void startLevel(int lvl) {
  world = new JSONArray();
  worldFigures.clear();
  coinsCollected = 0;
  println("startLevel(): world and worldFigures cleared");
  player.checkpointBlock = new PVector(0, -1);
  player.resetToCheckpoint(false);
  try { // trys to load the world.json file
    String fileName = "";
    switch (lvl) {
    case 0:
      fileName = "world";
      break;
    case 1:
      fileName = "level1";
      break;
    case 2:
      fileName = "level2";
      break;
    default:
      fileName = "level"+level;
      break;
    }
    println("startLevel(): Try to load "+fileName);
    reloadFigures(fileName);
    updateIDs();
  }
  catch(Exception e) { //if the file could'nt be loaded: adds one block beneath the player
    println("startLevel(): No world map found");
    world = new JSONArray();
    addFigure("wall", 0, 0, 1, 1);
    saveJSONArray(world, "data/level"+lvl+".json");
  }
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
    case "goal":
      img = checkpoint;
      imgGlow = goalGlow;
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
    return new Wall(x, y, w, h, id);
  case "spike":
    return new Spike(x, y, w, h, id);
  case "slime":
    return new Slime(x, y, w, h, id);
  case "coin":
    return new Coin(x, y, w, h, id);
  case "checkpoint":
    return new Checkpoint(x, y, w, h, id);
  case "goal":
    return new Goal(x, y, w, h, id);
  default:
    println("createFigure(): Error: ObjectClass coujld'nt be resolved");
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
  //switch(editMode) {
  //case "wall":
  //  worldFigures.add(new Box(x, y, w, h, id));
  //  break;
  //case "spike":
  //  worldFigures.add(new Spike(x, y, w, h, id, 1));
  //  break;
  //case "slime":
  //  worldFigures.add(new Slime(x, y, w, h, id));
  //  break;
  //case "coin":
  //  worldFigures.add(new Coin(x, y, w, h, id));
  //  break;
  //case "checkpoint":
  //  worldFigures.add(new Checkpoint(x, y, w, h, id));
  //  break;
  //case "goal":
  //  worldFigures.add(new Goal(x, y, w, h, id));
  //  break;
  //}
  worldFigures.add(createFigure(ObjectClass, x, y, w, h, id));
  world.setJSONObject(id, figure);


  if (level > levelAmount) {
    try {
      saveJSONArray(world, "data/level"+level+".json");
    }
    catch(Exception e) {
      println("Error in addFigure() while saving world into "+level+".json");
      println(e);
      delay(500);
      try {
        saveJSONArray(world, "data/level"+level+".json");
      }
      catch(Exception e2) {
        println("Couldn't save world after delay loading time");
        println(e2);
      }
    }
  }
  println("addFigure(): Added Figure of class: "+ObjectClass);
  println("addFigure(): New Figure saved in worldFigures, world and world.json: id: "+id);
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
    println("removeFigure(): Error while removing a Figure: id: "+id+", worldFigures.size():"+worldFigures.size());
    println("removeFigure(): Error catched:");
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
  try {
    saveJSONArray(temp, "data/world.json");
  }
  catch(Exception e) {
    println("Error in updateIDs(): could'nt save temp into world.json");
    println(e);
    println("After a delay, it will try again");
    delay(500);
    try {
      saveJSONArray(temp, "data/world.json");
    }
    catch(Exception e2) {
      println("Error in updateIDs(): could'nt save temp into world.json after delay");
      println(e2);
    }
  }
  println("updateIDs(): updated IDs into world and world.json");
  reloadFigures("world");
}


//This function reloads the figures from the world.json file into the worldFigures ArrayList. It is called at the start of the program and after updating the IDs.
void reloadFigures(String fileName) {
  try {
    world = new JSONArray();
    world = loadJSONArray(fileName+".json");
    println("reloadFigures(): world cleared and then loaded "+fileName+" into world");
  }
  catch(Exception e) {
    println("reloadFigures(): World-File not found: "+fileName);
    println("Exception: "+e);
    world = new JSONArray();
    worldFigures.clear();
    addFigure("wall", 0, 0, 1, 1);
  }
  try {
    saveJSONArray(world, "data/world.json");
  }
  catch(Exception e) {
    println("Error in reloadFigures() while saving world into data/world.json");
    println(e);
    delay(500);
    try {
      saveJSONArray(world, "world.json");
    }
    catch(Exception e2) {
      println("Couldn't save world after delay loading time");
      println(e2);
    }
  }
  println("reloadFigures(): world saved as world.json");
  worldFigures.clear();
  println("reloadFigures(): worldFigures cleard");
  for (int i = 0; i < world.size(); i++) {
    JSONObject jsn = world.getJSONObject(i);
    worldFigures.add(createFigure(jsn.getString("class"), jsn.getInt("x"), jsn.getInt("y"), 1, 1, jsn.getInt("id")));
  }
  println("reloadFigures(): worldFigures from world added; level: "+level);
  //println("Reloaded Figures of level: "+fileName);
  //println(level);
}

//This function is called when the mouse button is released. It determines the action based on the current edit mode and mouse position.
void mouseReleased() {
 if (inGame) {
    if (editModeOn && Edit.touch() == false && Exit.touch() == false) {
      if (editMode != "remove") {
        addFigure(editMode, int(cam.getInWorldCoordBlock(mouseX, mouseY).x), int(cam.getInWorldCoordBlock(mouseX, mouseY).y), 1, 1);
        playSound(click, 0.5, true);
        //updateIDs();
      } else {
        Figure f = getFigureAt(cam.getInWorldCoord(mouseX, mouseY));
        if (f.id != -1) {
          println("mouseReleased(): Trying to remove Figure, id: "+f.id);
          removeFigure(f.id);
          updateIDs();
          println("mouseReleased(): Figure removed");
          playSound(click, 0.5, true);
        } else {
          println("mouseReleased(): RemoveFigure: No Figure at this position found!");
        }
      }
    }
    if (Edit.touch() && mouseButton==LEFT) {
      editModeOn = !editModeOn;
      Edit.pictureChange();
      playSound(click, 0.7, true);
    }
    if (Exit.touch() && mouseButton==LEFT) {
      inGame = false;
      cam.x = 0;
      cam.y = 0;
      println("mouseReleased(): Left Game, level: "+level);
      playSound(tabChange, 0.7, true);
    }
  } else if (everythingLoaded) {
    if (Level1.touch() && mouseButton==LEFT && level == 1) {
      println("mouseReleased(): Button pressed: Start Level 1");
      level = 1;
      particles.clear();
      inGame = true;
      startLevel(level);
      playSound(tabChange, 0.7, true);
    }
    if (Level2.touch() && mouseButton==LEFT&& level == 2) {
      println("mouseReleased(): Button pressed: Start Level 2");
      level = 2;
      particles.clear();
      inGame = true;
      startLevel(level);
      playSound(tabChange, 0.7, true);
    }
    if (LevelX.touch() && mouseButton==LEFT && level > levelAmountButtons) {
      println("mouseReleased(): Button pressed: Start Level "+level);
      inGame = true;
      particles.clear();
      startLevel(level);
      playSound(tabChange, 0.7, true);
    }
    if (SkipRight.touch() && mouseButton==LEFT) {
      println("mouseReleased(): Button pressed: SkipRight: "+level);
      level++;
      playSound(click, 0.7, true);
    }
    if (SkipLeft.touch() && mouseButton==LEFT) {
      if (level > 1) {
        level--;
        println("mouseReleased(): Button pressed: SkipLeft: "+level);
      }
      playSound(click, 0.7, true);
    }
    coinAnimation(mouseX, mouseY);
  } else {
    coinAnimation(mouseX, mouseY);
  }
}


//This function returns the figure at the given coordinates (x, y) in the world. It searches through the worldFigures ArrayList and checks if the player figure is present at the given coordinates as well.
Figure getFigureAt(int x, int y) {
  for (Figure f : worldFigures) {
    if (f.hitbox.pointInHitbox(x, y)) {
      //println("Found Figure of class: "+f.getClass() + ", at: "+x+", "+y+"; id: "+f.id);
      return f;
    }
  }
  if (player.hitbox.pointInHitbox(x, y)) { //Edit: if (player.hitbox.pointInHitbox(cam.getInWorldCoord(x, y))) {
    //println("Found Player Figure at: "+x+", "+y+"; id: "+player.id);
    return player;
  }
  //println("No element of Environment on this position found: "+x+", "+y+"; id: "+"-1");
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
  if (key == 'h') {
    editMode = "goal";
  }
  if (key == 'g') {
    gravity = !gravity;
  }
  if (key == 'e') {
    editModeOn = !editModeOn;
    Edit.pictureChange();
  }
  if (key == ENTER) {
    if (inGame) {
      inGame = false;
      cam.x = 0;
      cam.y = 0;
      println("keyReleased(): Left Game, level: "+level);
    }
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
  BLevel1 = loadImage("BLevel1.png");
  BLevel2 = loadImage("BLevel2.png");
  BLevelX = loadImage("BLevelX.png");
  BLevel1Glow = loadImage("BLevel1Glow.png");
  right = loadImage("right.png");
  rightGlow = loadImage("rightGlow.png");
  left = loadImage("left.png");
  leftGlow = loadImage("leftGlow.png");
  goalGlow = loadImage("goalGlow.png");
  particleStar = loadImage("particleStar.png");
  particleWall = loadImage("particleWall.png");
  clear = loadImage("clear.png");
  ButtonEXIT = loadImage("ButtonEXIT.png");
  particleSlime = loadImage("particleSlime.png");
  println("loadImages(): all images loaded");
}


//This function loads the necessary sound files used in the program.
void loadSounds() {
  click = new SoundFile(this, "click interface.mp3");
  reset = new SoundFile(this, "reset.mp3");
  background1 = new SoundFile(this, "background1.mp3");
  jump = new SoundFile(this, "jump.mp3");
  jumpSlime = new SoundFile(this, "jumpSlime.mp3");
  collectCoin = new SoundFile(this, "collectCoin.mp3");
  goalSound = new SoundFile(this, "goal.mp3");
  tabChange = new SoundFile(this, "tabChange.mp3");
  println("loadSounds(): all sounds loaded");
  everythingLoaded = true;
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
  float speed = 2;
  float maxSpeed = 12;

  if (editModeOn) {
    // Check if 'w' key is pressed
    if (keysPressed['w']) {
      if (player.vy >-maxSpeed) {
        //player.vy -= speed;
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

void coinAnimation(int x, int y) {
  particleAnimation(x, y, particleStar);
}

void particleAnimation(int x, int y, PImage img, int count, int size) {
  for (int i = 0; i < count; i++) {
    particles.add(new Particle(x+int(random(-8, 8)), y+int(random(-8, 8)), img, size));
  }
}

void particleAnimation(int x, int y, PImage img, int count) {
  particleAnimation(x, y, img, count, 20);
}
void particleAnimation(int x, int y, PImage img) {
  particleAnimation(x, y, img, 10);
}

void deathAnimation(int x, int y) {
  particleAnimation(x, y, play, 20);
}

void slimeAnimation(int x, int y) {
  particleAnimation(x, y, particleSlime, 7, 35);
}

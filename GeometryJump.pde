//This section imports the necessary sound library and declares the SoundFiles used in the program.
import processing.sound.*;
SoundFile click, background1, background2, reset, jump, jumpSlime, collectCoin, goalSound, tabChange, loading;

//These are variable declarations used throughout the program. They include objects such as figures, images, player, camera, and various flags and settings.
PImage spike, wall, play, spikeGlow, slime, slimeGlow, wallGlow, remove, coin, coinGlow, checkpoint, checkpointGlow, BEditModeOn, BEditModeOff, BLevel1, BLevel1Glow, BLevel2, right, rightGlow, left, leftGlow, BLevelX, goalGlow, particleStar,
  particleWall, clear, ButtonEXIT, particleSlime, particleCheckpoint, bgSwitch, offSwitch, onSwitch, ButtonSwitch;

Button Edit, SkipRight, SkipLeft, LevelX, Exit, SwitchEdit;
SwitchButton BgMusicSwitch, SoundEffectsSwitch;

ArrayList<Particle> particles = new ArrayList<Particle>();

ArrayList<Figure> worldFigures = new ArrayList<Figure>();
Player player;
Cam cam;
int blockSize = 60; //indicates how many pixels a block is large
boolean[] keysPressed = new boolean[65536]; //used to check if a key is pressed or not
JSONArray world; //The json-Array that contains the figures of the environment
JSONArray times; //contains the times (frame-Counts) in which the player has completed the levels (best scores)
String editMode = "wall"; //default for the world-edit mode: selects box/walls as the default to add to your world in editModeOn
int editModeInt = 1;
boolean editModeOn = false; //idicates if the editMode is on or off
boolean gravity = false; //indicates if gravity is in editModeOn active or not
int coinsCollected = 0; //indicates how many coins the player has collected in a level
float gameZoom = 1.0; //makes the gameplay bigger (zooms in), when you are on a smartphone
float backgroundMusicAmp = 1;

//objects just to get their .getClass()
Spike s;
Slime sl;
Coin co;
Checkpoint ch;
Goal go;

boolean inGame = false; //indicates if the game is running (true) or if the player is in the menue (false)
int level = 1; //selects level 1 as default
int levelAmount = 9; //indicates how many levels there are which should not be altered by in Game editing
int framesSinceStarted = 0; //counts the frames, since the player has started a level (reset by death)

BackgroundFigure[] bgFigures = new BackgroundFigure[20]; //Figures floating in Menue
boolean everythingLoaded = false;
int loaded = 0;

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
  BgMusicSwitch = new SwitchButton(bgSwitch, offSwitch, onSwitch, width-100, 20, 80, 40);
  SoundEffectsSwitch= new SwitchButton(bgSwitch, offSwitch, onSwitch, width-100, 80, 80, 40);
  cam = new Cam(0, 0, 1920, 1080);

  Edit = new Button(true, BEditModeOff, BEditModeOn, false, int(width-180*(width/1920f)), int(20*(height/1080f)), int(160*(width/1920f)), int(80*(height/1080f)));
  Exit = new Button(true, ButtonEXIT, ButtonEXIT, false, int(width-180*(width/1920f)), int(105*(height/1080f)), int(160*(width/1920f)), int(80*(height/1080f)));
  LevelX = new Button(true, BLevelX, BLevel1Glow, false, int(width/2-320*(width/1920f)), int(height/2-220*(height/1080f)), int(640*(width/1920f)), int(440*(height/1080f)), 1, false, true);
  SkipRight = new Button(true, right, rightGlow, false, int(width/2+(320+50)*(width/1920f)), int(height/2-75*(height/1080f)), int(100*(width/1920f)), int(150*(height/1080f)), 1, false, true);
  SkipLeft = new Button(true, left, leftGlow, false, int(width/2+(-320-50-100)*(width/1920f)), int(height/2-75*(height/1080f)), int(100*(width/1920f)), int(150*(height/1080f)), 1, false, true);
  SwitchEdit = new Button(true, ButtonSwitch, ButtonSwitch, false, int(width-180*(width/1920f)), int(height-90*(height/1080f)), int(160*(width/1920f)), int(80*(height/1080f)));

  if (height > width) {
    SkipRight = new Button(true, right, rightGlow, false, int(width/2+(550+40)*(width/1920f)), int(height/2-75*(height/1080f)), int(200*(width/1920f)), int(150*(height/1080f)), 1, false, true);
    SkipLeft = new Button(true, left, leftGlow, false, int(width/2-(550+40+200)*(width/1920f)), int(height/2-75*(height/1080f)), int(200*(width/1920f)), int(150*(height/1080f)), 1, false, true);
    LevelX = new Button(true, BLevelX, BLevel1Glow, false, int(width/2-(550)*(width/1920f)), int(height/2-110*(height/1080f)), int((1100)*(width/1920f)), int(220*(height/1080f)), 1, false, true);
    Edit = new Button(true, BEditModeOff, BEditModeOn, false, int(width-410*(width/1920f)), int(20*(height/1080f)), int(400*(width/1920f)), int(60*(height/1080f)));
    Exit = new Button(true, ButtonEXIT, ButtonEXIT, false, int(width-410*(width/1920f)), int(85*(height/1080f)), int(400*(width/1920f)), int(60*(height/1080f)));
  }

  setupBGAnimation();
  player = new Player(0, -1, blockSize, blockSize);
  LevelX.img = levelXImage(level);
}

//called in loop: It is responsible for continuously updating and rendering the graphics and animations of the program.
void draw() {
  background(0);
  if (inGame) {
    framesSinceStarted++;
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

    if (editModeOn) {
      SwitchEdit.show();
    }

    //plays the background1 sound in a loop when it's loaded
    playBackgroundMusic();
    Edit.show();
    Exit.show();
  } else {
    fill(255);
    textSize(500);
    textSize(30);
    text("Background-Music: ", width-350, 50);
    text("Sound-Effects: ", width-350, 110);
    BgMusicSwitch.show();
    SoundEffectsSwitch.show();
    backgroundMusicAmp = BgMusicSwitch.timer;

    if (everythingLoaded) {
      try {
        try {
          playBackgroundMusic();
        }
        catch(Exception e2) {
          println("Error in Draw() while playing background - music: ");
          println(e2);
        }
        LevelX.show();
        SkipRight.show();
        SkipLeft.show();
      }
      catch(Exception e) {
        println("Error in Draw() while displaying UI and playing background - music: ");
        println(e);
      }
    } else {
      playSound(loading, 0.7*SoundEffectsSwitch.timer);
      fill(255-loaded*2.55, loaded*2.55, 0);
      textSize(200);
      text(loaded+"%", width/2-180, height/2+67);
      stroke(255);
      fill(0, 0, 0, 0);
      rect(width/2-200, height/2+100, 4*100, 50);
      fill(255-loaded*2.55, loaded*2.55, 0);
      rect(width/2-200, height/2+100, 4*loaded, 50);
      //line(width/2,0,width/2,height);
      //line(0,height/2,width,height/2);
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
    bgFigures[i].update();
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
      image(img, blockSize*2, blockSize, blockSize, blockSize);
    }
    image(imgGlow, blockSize*2-blockSize/2, blockSize-blockSize/2, blockSize*2, blockSize*2);
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
  BgMusicSwitch.Released();
  SoundEffectsSwitch.Released();
  if (inGame) {
    if (editModeOn && Edit.touch() == false && Exit.touch() == false && SwitchEdit.touch() == false) {
      if (editMode != "remove") {
        addFigure(editMode, int(cam.getInWorldCoordBlock(mouseX, mouseY).x), int(cam.getInWorldCoordBlock(mouseX, mouseY).y), 1, 1);
        playSound(click, 0.5*SoundEffectsSwitch.timer, true);
        //updateIDs();
      } else {
        Figure f = getFigureAt(cam.getInWorldCoord(mouseX, mouseY));
        if (f.id != -1) {
          println("mouseReleased(): Trying to remove Figure, id: "+f.id);
          removeFigure(f.id);
          updateIDs();
          println("mouseReleased(): Figure removed");
          playSound(click, 0.5*SoundEffectsSwitch.timer, true);
        } else {
          println("mouseReleased(): RemoveFigure: No Figure at this position found!");
        }
      }
    }
    if (Edit.touch() && mouseButton==LEFT) {
      editModeOn = !editModeOn;
      Edit.pictureChange();
      playSound(click, 0.7*SoundEffectsSwitch.timer, true);
    }
    if (SwitchEdit.touch() && mouseButton==LEFT) {
      if (editModeOn) {
        if (editModeInt < 6) {
          editModeInt++;
        } else {
          editModeInt = 0;
        }
        updateEditMode();
      }
    }
    if (Exit.touch() && mouseButton==LEFT) {
      inGame = false;
      BgMusicSwitch.hitbox = true;
      SoundEffectsSwitch.hitbox = true;
      cam.x = 0;
      cam.y = 0;
      println("mouseReleased(): Left Game, level: "+level);
      playSound(tabChange, 0.7*SoundEffectsSwitch.timer, true);
      particles.removeAll(particles);
    }
  } else if (everythingLoaded) {
    coinAnimation(mouseX, mouseY);
    playSound(collectCoin, 0.2*SoundEffectsSwitch.timer, true);
    if (LevelX.touch() && mouseButton==LEFT) {
      println("mouseReleased(): Button pressed: Start Level "+level);
      inGame = true;
      BgMusicSwitch.hitbox = false;
      SoundEffectsSwitch.hitbox = false;
      particles.removeAll(particles);
      startLevel(level);
      playSound(tabChange, 0.7*SoundEffectsSwitch.timer, true);
    }
    if (SkipRight.touch() && mouseButton==LEFT) {
      println("mouseReleased(): Button pressed: SkipRight: "+level);
      level++;
      LevelX.img = levelXImage(level);
      playSound(click, 0.7*SoundEffectsSwitch.timer, true);
    }
    if (SkipLeft.touch() && mouseButton==LEFT) {
      if (level > 1) {
        level--;
        LevelX.img = levelXImage(level);
        println("mouseReleased(): Button pressed: SkipLeft: "+level);
      }
      playSound(click, 0.7*SoundEffectsSwitch.timer, true);
    }
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
  try {
  keysPressed[keyCode] = true;
  keysPressed[key] = true;
  } catch(Exception e) {
    println("Error while checking for keys: keyCode: "+keyCode+"; key: "+key);
    println(e);
  }
}

void keyReleased() {
  keysPressed[keyCode] = false;
  keysPressed[key] = false;
  if (key == 'r') {
    loadImages();
  }
  if (key == 'b' || key == '1') {
    editModeInt = 1;
  }
  if (key == 'n' || key == '2') {
    editModeInt = 2;
  }
  if (key == 'm' || key == '3') {
    editModeInt = 3;
  }
  if (key == ',' || key == '0') {
    editModeInt = 0;
  }
  if (key == 'c' || key == '6') {
    editModeInt = 6;
  }
  if (key == 'v' || key == '5') {
    editModeInt = 5;
  }
  if (key == 'h' || key == '4') {
    editModeInt = 4;
  }
  updateEditMode();
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
      BgMusicSwitch.hitbox = true;
      SoundEffectsSwitch.hitbox = true;
      cam.x = 0;
      cam.y = 0;
      println("keyReleased(): Left Game, level: "+level);
      particles.removeAll(particles);
    } else {
      inGame = true;
      BgMusicSwitch.hitbox = false;
      SoundEffectsSwitch.hitbox = false;
      particles.removeAll(particles);
      startLevel(level);
      playSound(tabChange, 0.7*SoundEffectsSwitch.timer, true);
    }
  }
  if (key == 'u') {
    backgroundMusicAmp = 1-backgroundMusicAmp;
    println("Backgound Music volume set to: "+backgroundMusicAmp*100+"%");
  }
}

void updateEditMode() {
  switch(editModeInt) {
  case 0:
    editMode = "remove";
    break;
  case 1:
    editMode = "wall";
    break;
  case 2:
    editMode = "spike";
    break;
  case 3:
    editMode = "slime";
    break;
  case 4:
    editMode = "goal";
    break;
  case 5:
    editMode = "checkpoint";
    break;
  case 6:
    editMode = "coin";
    break;
  default:
    editMode = "wall";
    break;
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
  loaded = 10;
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
  particleCheckpoint = loadImage("particleCheckpoint.png");
  bgSwitch=loadImage("bg.png");
  offSwitch=loadImage("off.png");
  onSwitch=loadImage("on.png");
  ButtonSwitch=loadImage("ButtonSwitch.png");
  loaded = 20;
  println("loadImages(): all images loaded");
}


//This function loads the necessary sound files used in the program.
void loadSounds() {
  loading = new SoundFile(this, "loading.mp3");
  collectCoin = new SoundFile(this, "collectCoin.mp3");
  loaded = 30;
  background1 = new SoundFile(this, "background1.mp3");
  loaded = 60;
  click = new SoundFile(this, "click interface.mp3");
  reset = new SoundFile(this, "reset.mp3");
  loaded = 70;
  jump = new SoundFile(this, "jump.mp3");
  jumpSlime = new SoundFile(this, "jumpSlime.mp3");
  loaded = 80;
  background2 = new SoundFile(this, "background2.mp3");
  loaded = 90;
  goalSound = new SoundFile(this, "goal.mp3");
  tabChange = new SoundFile(this, "tabChange.mp3");
  loaded = 100;
  println("loadSounds(): all sounds loaded");
  everythingLoaded = true;
  loading.pause();
}

void playSound(SoundFile sound) {
  playSound(sound, 1, false);
}

void playSound(SoundFile sound, float amp) {
  playSound(sound, amp, false);
}

void playSound(SoundFile sound, boolean multiple) {
  playSound(sound, 1, multiple);
}


//This plays a SoundFile with specified volume ('amp'). If 'multiple' is true, it plays the sound again, even when this sound is already playing (multiple times at the same time)
void playSound(SoundFile sound, float amp, boolean multiple) {
  if (sound != null) {
    if (sound.isPlaying() == false || multiple) {
      sound.play();
      sound.amp(amp+0.000000001);
    } else if (sound.isPlaying() == true) {
      sound.amp(amp+0.000000001);
    }
  }
}

void playBackgroundMusic() {
  switch(int(random(0, 2))) {
  case 0:
    if (background2.isPlaying() == false) {
      playSound(background1, 0.4*backgroundMusicAmp);
    }
    break;
  case 1:
    if (background1.isPlaying() == false) {
      playSound(background2, 0.2*backgroundMusicAmp);
    }
    break;
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

void coinAnimation(int x, int y) {
  particleAnimation(x, y, particleStar);
}

void particleAnimation(int x, int y, PImage img, int count, int size) {
  particleAnimation(x, y, img, count, size, 5, -5, -5, -20);
}

void particleAnimation(int x, int y, PImage img, int count, int size, int maxVX, int minVX, int maxVY, int minVY) {
  for (int i = 0; i < count; i++) {
    particles.add(new Particle(x+int(random(-8, 8)), y+int(random(-8, 8)), img, size, maxVX, minVX, maxVY, minVY));
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

void checkpointAnimation(int x, int y) {
  particleAnimation(x, y, particleCheckpoint, 25, 20);
}

void wallAnimation(int x, int y) {
  particleAnimation(x, y, particleWall, 1, 15, 5, -5, -2, -7);
}

PImage levelXImage(int printLevel) {
  PImage vorlage = loadImage("vorlage.png");
  PGraphics pg= createGraphics(640, 440);
  pg.beginDraw();
  pg.image(vorlage, 0, 0);
  pg.fill(255);
  if (printLevel < 10) {
    pg.textSize(200);
  } else if (printLevel < 100) {
    pg.textSize(178);
  } else if (printLevel < 1000) {
    pg.textSize(150);
  } else {
    pg.textSize(135);
  }
  pg.text("Level "+printLevel, 30, 270);
  pg.endDraw();
  return pg;
}

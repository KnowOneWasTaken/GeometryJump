class Button {
  PImage img, img2, img3, img4, storage;
  boolean bigB;
  int picture;
  int x;
  int y;
  int x2;
  int y2;
  int widthB;
  int heightB;
  boolean round;
  boolean help;
  int clicked;
  float groesse = 1;
  float bigTouch = 1.1;
  float bigClick = 0.9;
  float smallTouch=0.95;
  float smallClick=0.85;
  float step = 0.07;
  boolean hitbox = true;
  boolean secondImg = false;
  color c = color(150, 150, 200);
  boolean isHovered = false, isPressed = false, wasReleased = false, wasPressed = false, isMouseRealease = false, isMousePressed = false;
  boolean glow = false;

  void update() {
    boolean wasHovered = isHovered;
    isHovered = touch() && hitbox;
    boolean wasPressed = isPressed;
    isPressed = touch() && mousePressed && hitbox && mouseButton==LEFT;
    boolean wasMousePressed = isMousePressed;
    isMousePressed = mousePressed && mouseButton == LEFT;
    boolean wasMouseRealease = isMouseRealease;
    isMouseRealease = !wasMouseRealease && wasMousePressed && !isMousePressed;
  }
  void show() {
    x = x2;
    y = y2;
    update();
    show2();
  }

  void showMove(int xa, int ya) {
    x = xa;
    y = ya;
    show2();
    if (help) {
      println(bl()+"Button shown on: "+x+", "+y);
    }
  }

  void show2() {
    float Touch, Click;
    int w=widthB;
    int h = heightB;
    PImage pic;
    if (bigB) {
      Touch = bigTouch;
      Click = bigClick;
    } else {
      Touch = smallTouch;
      Click = smallClick;
    }
    switch (picture) {
    case 1:
      pic = img;
      break;
    case 2:
      pic = img2;
      break;
    default:
      pic =img;
      break;
    }
    if (touch()) {
      tint(c);
      if (mousePressed && mouseButton == LEFT) {
        if (groesse<Click) {
          if (groesse+step<Click) {
            groesse+=step;
          } else {
            groesse=Click;
          }
        } else {
          if (groesse>Click) {
            if (groesse-step>Click) {
              groesse-=step;
            } else {
              groesse=Click;
            }
          }
        }
      } else {
        if (groesse<Touch) {
          if (groesse+step<Touch) {
            groesse+=step;
          } else {
            groesse=Touch;
          }
        } else {
          if (groesse>Touch) {
            if (groesse-step>Touch) {
              groesse-=step;
            } else {
              groesse=Touch;
            }
          }
        }
      }
    } else {
      if (groesse<1) {
        if (groesse+step<1) {
          groesse+=step;
        } else {
          groesse=1;
        }
      } else {
        if (groesse>1) {
          if (groesse-step>1) {
            groesse-=step;
          } else {
            groesse=1;
          }
        }
      }
    }
    if (secondImg==false) {
      try {
        if(glow == false) {
        image(pic, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        } else {
          image(img2, (x+w*((1-groesse)/2)) - (w-(1-groesse)*w)/2, (y+(h*(1-groesse)/2)) - (h-(1-groesse)*h)/2, (w-(1-groesse)*w)*2, (h-(1-groesse)*h)*2);
          image(img, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        }
      }
      catch(Exception e) {
        println(e);
      }
    } else {
      if (glow == false) {
        noTint();
        if (picture==1&&mousePressed==false) {
          image(img, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        }
        if (picture==1&&mousePressed==true&&touch()) {
          image(img2, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        }
        if (picture==2&&mousePressed==false) {
          image(img3, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        }
        if (picture==2&&mousePressed==true&&touch()) {
          image(img4, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        }
        if (picture==1&&mousePressed==true&&touch()==false) {
          image(img, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        }
        if (picture==2&&mousePressed==true&&touch()==false) {
          image(img3, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
        }
      } else {
      }
    }
    noTint();
  }


  boolean touch() {
    if (hitbox) {
      boolean roundB = round;
      if (roundB==false) {
        int r = x+widthB;
        int b=y+heightB;
        if (mouseX<r && mouseX>x && mouseY<b&& mouseY>y) {
          return true;
        } else {
          return false;
        }
      } else {
        if (dist(mouseX, mouseY, x+widthB/2, y+heightB/2) < widthB/2) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }

  void setImg(PImage Pimage) {
    img = Pimage;
    if (help) {
      println(bl()+"img set to a new PImage");
    }
  }

  PImage getImg() {
    return img;
  }

  PImage getImg2() {
    return img2;
  }
  void setImg2(PImage Pimage) {
    img2 = Pimage;
    if (help) {
      println(bl()+"img2 set to a new PImage");
    }
  }
  void setImg(PImage Pimage, PImage Pimage2) {
    img = Pimage;
    img2 = Pimage2;
    if (help) {
      println(bl()+"img and img2 set to new PImage(s)");
    }
  }

  void setBig(float c, float t) {
    bigClick=c;
    bigTouch=t;
  }

  void setSmall(float c, float t) {
    smallClick=c;
    smallTouch=t;
  }

  void setStep(float c) {
    step=c;
  }

  void setHitbox(boolean b) {
    hitbox=b;
  }

  void setXY(int xa, int ya) {
    x = xa;
    y = ya;
    x2=xa;
    y2=ya;
    if (help) {
      println(bl()+"x and y set to: "+x+", "+y);
    }
  }

  int getX() {
    return x;
  }

  int getY() {
    return y;
  }

  void setX(int xa) {
    x = xa;
    x2=xa;
    if (help) {
      println(bl()+"x set to: "+x);
    }
  }

  void setY(int ya) {
    y = ya;
    y2=ya;
    if (help) {
      println(bl()+"y set to: "+y);
    }
  }

  void setW(int w) {
    widthB=w;
    if (help) {
      println(bl()+"width set to: "+w);
    }
  }

  int getW() {
    return widthB;
  }
  void setH(int h) {
    heightB=h;
    if (help) {
      println(bl()+"height set to: "+y);
    }
  }
  int getH() {
    return heightB;
  }

  void setWH(int w, int h) {
    widthB = w;
    heightB = h;
    if (help) {
      println(bl()+"width and height set to: "+w+", "+h);
    }
  }

  void pictureChange() {//switches the picture
    if (picture == 1) {
      picture = 2;
    } else {
      picture = 1;
    }
    if (help) {
      println(bl()+"picture set to: "+picture);
    }
  }

  int getPicture() {
    return picture;
  }

  boolean getBig() {
    return bigB;
  }

  void setBig(boolean b) {
    bigB = b;
    if (help) {
      println(bl()+"bigB set to: "+bigB);
    }
  }

  boolean getRound() {//returns round
    return round;
  }

  void setRound(boolean b) {//sets the variable round to true or false
    round = b;
    if (help) {
      println(bl()+"round set to: "+round);
    }
  }

  void setPicture(int i) {//sets the picture to the integer
    if (i==1||i==2) {
      if ((picture == 1 && i == 1) || (picture == 2 && i ==2)) {
        if (help) {
          println(bl()+"picture didn't changed");
        }
      } else {
        picture = i;
        if (help) {
          println(bl()+"picture set to: "+picture);
        }
      }
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+i+ ", it must be 1 or 2");
      }
    }
  }

  void imgChange() {//switches the pictures
    storage = img;
    img = img2;
    img2=storage;
    if (help) {
      println(bl()+"Images switched");
    }
  }
  void clickedReset() {
    clicked = 0;
  }

  void clicked() {
    println(bl()+"Button clicked "+(clicked+1)+" time(s)");
    clicked++;
  }

  void clicked(boolean b) {
    if (b) {
      println(bl()+"Button clicked "+(clicked+1)+" time(s)");
    }
    clicked++;
  }

  int getClicked() {
    return clicked;
  }

  void setClicked(int i) {
    clicked = i;
  }

  String bl() {
    return "[Button-Libary] ";
  }

  void bl(String t) {
    println(bl()+t);
  }

  void help() {
    println("_____________________________________________________________________________________________________________________________________________________________________________________________________");
    println("");
    println("Button-Libary Help");
    println("------------------");
    println("To create a new Button, simply make this:");
    println("Button NAME;");
    println("NAME = new Button(bigB,img,img2,help,x,y,widthB,heightB,picture,round);");
    println("NAME = new Button(boolean,PImage,PImage,boolean,int,int,int,int,int,boolean);");
    println("");
    println("Or if you want to use the standards of this libary, you can just write:");
    println("NAME = new Button(image,x,y);");
    println("NAME = new Button(PImage,int,int);");
    println(" ");
    println("-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
    println(" ");
    println("bigB: boolean, if you touch the button with your mouse, should the button be bigger or smaller than befor? for bigger: true, for smaller: false (standard: true) [you don't have to specify it]");
    println("img: PImage, this should be the standard picture of your button [you have to specify it]");
    println("img2: PImage, if you want to change the picture of the button sometimes, add a second picture (standard: same picture as picture 1) [you don't have to specify it]");
    println("help: if it is true, infos will be displayed in the console [you have to specify it]");
    println("x: int, x-coordinate of the button: top left [you have to specify it]");
    println("y: int, y-coordinate of your button: top left [you have to specify it]");
    println("widthB: int, the width of your button (standard: width of picture 1) [you don't have to specify it]");
    println("heightB: int, the height of your button (standard: height of picture 1) [you don't have to specify it]");
    println("picture: int (1 or 2), if you added a second picture, this shows the program if it should start with the second or with the first picture (standard: 1) [you don't have to specify it]");
    println("round: boolean, if your button is a circle, you should type true, otherwise false. This changes the hitbox of your button (standard: false) [you don't have to specify it]");
    println(" ");
    println("-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
    println(" ");
    println("If you don't want to specify something, simply don't write it in Button().");
    println("Only img,x,y should be in this creation, everything else would be the standard");
    println(" ");
    println("-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
    println(" ");
    println("Important functions:");
    println("show();");
    println("  shows the button and resets the coordinate, if you used showMove(int,int);");
    println("touch();");
    println("  returns a boolean, if the mouse is on the button");
    println("showMove(int,int);");
    println("  shows the button on a different location (x,y), you can use touch() for this location too, if you didn't use show() after showMove() and befor touch()");
    println("  It changes the location temporarily");
    println("show2();");
    println("  shows the Button on the last coordinates, useful if you used showMove(int,int) and don't want to tip the coordinates again");
    println(" ");
    println("-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
    println(" ");
    println("Other functions:");
    println("pictureChange();");
    println("  if you want so switch the picture of the button");
    println("setPicture(int);");
    println("  you can set the picture of the button (1 is the first picture and 2 is the second picture)");
    println("getPicture();");
    println("  this returns the picture of the button (1 is the first picture and 2 is the second picture)");
    println("setWH(int,int);");
    println("  changes the width and the height of your button to these integers");
    println("setXY(int,int);");
    println("  changes the coordinates of the button to the x and y-coordinates (not temporarily)");
    println("setX(int);");
    println("setY(int);");
    println("setW(int);");
    println("setH(int);");
    println("clicked();");
    println("  prints a message in the console");
    println("imgChange();");
    println("  switches the images without changing the picture (switches the first with the second picture)");
    println("setImg(PImage);");
    println("setImg(Pimage, PImage);");
    println("  sets both images (first and second)");
    println("setImg2(PImage);");
    println("getImg()");
    println("getImg2()");
    println("getX()");
    println("getY()");
    println("setBig(boolean);");
    println("getBig()");
    println("setRound();");
    println("getRound();");
    println("clicked();");
    println("clickedReset();");
    println("getClicked();");
    println("setClicked(int);");
    println("setBig(float,float);");
    println("  changes the size of the button, when it is touched or pressed (bigB==true), float 1 for clicked and float 2 for touched (standard: 0.9, 1.1");
    println("setSmall(float,float);");
    println("  changes the size of the button, when it is touched or pressed (bigB==false), float 1 for clicked and float 2 for touched (standard: 0.85, 0.95");
    println("setStep(float);");
    println("  sets the size of a step, the button should grow/shrink per frame (standard: 0.1");
    println("setHitbox(boolean);");
    println("  the hitbox of a button works, even if the button is not shown, if you don't want this, simply call this function with false, if you want that, simply call this function with true (standard: true)s");
    println(" ");
    println("-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
    println(" ");
    println("Every possible choice:");
    println("Button(image1,x,y);");
    println("Button(image1,x,y,width,height);");
    println("Button(image1,image2,x,y);");
    println("Button(image1,image2,x,y,width,height);");
    println("Button(image1,image2,x,y,picture);");
    println("Button(image1,image2,x,y,width,height,picture);");
    println("");
    println("Button(image1,x,y,round);");
    println("Button(image1,x,y,width,height,round);");
    println("Button(image1,image2,x,y,round);");
    println("Button(image1,image2,x,y,width,height,round);");
    println("Button(image1,image2,x,y,picture,round);");
    println("Button(image1,image2,x,y,width,height,picture,round);");
    println("");
    println("Button(big,image1,x,y);");
    println("Button(big,image1,x,y,width,height);");
    println("Button(big,image1,image2,x,y);");
    println("Button(big,image1,image2,x,y,width,height);");
    println("Button(big,image1,image2,x,y,picture);");
    println("Button(big,image1,image2,x,y,width,height,picture);");
    println("");
    println("Button(big,image1,x,y,round);");
    println("Button(big,image1,x,y,width,height,round);");
    println("Button(big,image1,image2,x,y,round);");
    println("Button(big,image1,image2,x,y,width,height,round);");
    println("Button(big,image1,image2,x,y,picture,round);");
    println("Button(big,image1,image2,x,y,width,height,picture,round););");
    println("");
    println("Button(image1,help,x,y);");
    println("Button(image1,help,x,y,width,height);");
    println("Button(image1,image2,help,x,y);");
    println("Button(image1,image2,help,x,y,width,height);");
    println("Button(image1,image2,help,x,y,picture);");
    println("Button(image1,image2,help,x,y,width,height,picture);");
    println("");
    println("Button(image1,help,x,y,round);");
    println("Button(image1,help,x,y,width,height,round);");
    println("Button(image1,image2,help,x,y,round);");
    println("Button(image1,image2,help,x,y,width,height,round);");
    println("Button(image1,image2,help,x,y,picture,round);");
    println("Button(image1,image2,help,x,y,width,height,picture,round);");
    println("");
    println("Button(big,image1,help,x,y);");
    println("Button(big,image1,help,x,y,width,height);");
    println("Button(big,image1,image2,help,x,y);");
    println("Button(big,image1,image2,help,x,y,width,height);");
    println("Button(big,image1,image2,help,x,y,picture);");
    println("Button(big,image1,image2,help,x,y,width,height,picture);");
    println("");
    println("Button(big,image1,help,x,y,round);");
    println("Button(big,image1,help,x,y,width,height,round);");
    println("Button(big,image1,image2,help,x,y,round);");
    println("Button(big,image1,image2,help,x,y,width,height,round);");
    println("Button(big,image1,image2,help,x,y,picture,round);");
    println("Button(big,image1,image2,help,x,y,width,height,picture,round););");
    println("_____________________________________________________________________________________________________________________________________________________________________________________________________");
  }

  void standard() {
    secondImg=false;
    img3=img2;
    img4=img3;
  }

  Button(PImage imgc, PImage img2c, PImage img3c, PImage img4c, int xc, int yc, int widthBc, int heightBc, boolean roundc, boolean secondImg) {// bigB,standard with second image, width, height, picture and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture=1;
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = false;
    this.secondImg=secondImg;
    img3=img3c;
    img4=img4c;
  }

  Button(PImage imgc, int xc, int yc) {//standard
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, int xc, int yc, int widthBc, int heightBc) {//standard with width and hight
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = true;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc) {//standard with second image
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc) {//standard with width, hight and second image
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc, int picturec) {//standard with second image and picture
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help==true) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc, int picturec) {//standard with second image, width, height and picture
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Button(PImage imgc, int xc, int yc, boolean roundc) {//standard with round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//standard with width, hight and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = true;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc, boolean roundc) {//standard with second image and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//standard with width, hight, second image and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc, int picturec, boolean roundc) {//standard with second image, picture and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc, int picturec, boolean roundc) {// standard with second image, width, height, picture and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Button(boolean bigBc, PImage imgc, int xc, int yc) {//bigB,standard
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, int xc, int yc, int widthBc, int heightBc) {//bigB,standard with width and hight
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = bigBc;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc) {//bigB,standard with second image
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc) {//bigB,standard with width, hight and second image
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc, int picturec) {//bigB,standard with second image and picture
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc, int picturec) {//bigB,standard with second image, width, height and picture
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Button(boolean bigBc, PImage imgc, int xc, int yc, boolean roundc) {//bigB,standard with round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//bigB,standard with width, hight and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    img2 = img;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc, boolean roundc) {//bigB,standard with second image and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//bigB,standard with width, hight, second image and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc, int picturec, boolean roundc) {//bigB,standard with second image, picture and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, int xc, int yc, int widthBc, int heightBc, int picturec, boolean roundc) {// bigB,standard with second image, width, height, picture and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    if (picturec==1||picturec==2&&help==true) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    standard();
  }

  Button(PImage imgc, boolean helpc, int xc, int yc) {//standard
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, boolean helpc, int xc, int yc, int widthBc, int heightBc) {//standard with width and hight
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = true;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc) {//standard with second image
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc) {//standard with width, hight and second image
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int picturec) {//standard with second image and picture
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc, int picturec) {//standard with second image, width, height and picture
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Button(PImage imgc, boolean helpc, int xc, int yc, boolean roundc) {//standard with round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, boolean helpc, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//standard with width, hight and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = true;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc, boolean roundc) {//standard with second image and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//standard with width, hight, second image and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int picturec, boolean roundc) {//standard with second image, picture and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc, int picturec, boolean roundc) {// standard with second image, width, height, picture and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = true;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Button(boolean bigBc, PImage imgc, boolean helpc, int xc, int yc) {//bigB,standard
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, boolean helpc, int xc, int yc, int widthBc, int heightBc) {//bigB,standard with width and hight
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = bigBc;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc) {//bigB,standard with second image
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc) {//bigB,standard with width, hight and second image
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    picture = 1;
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int picturec) {//bigB,standard with second image and picture
    img = imgc;
    x = xc;
    y = yc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc, int picturec) {//bigB,standard with second image, width, height and picture
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = false;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Button(boolean bigBc, PImage imgc, boolean helpc, int xc, int yc, boolean roundc) {//bigB,standard with round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, boolean helpc, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//bigB,standard with width, hight and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    img2 = img;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, boolean roundc) {//bigB,standard with second image and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//bigB,standard with width, hight, second image and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int picturec, boolean roundc) {//bigB,standard with second image, picture and round
    img = imgc;
    x = xc;
    y = yc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    widthB = img.width;
    heightB = img.height;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc, int picturec, boolean roundc) {// bigB,standard with second image, width, height, picture and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc, int picturec, boolean roundc, boolean glow) {// bigB,standard with second image, width, height, picture and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
    this.glow = glow;
  }
}

class SwitchButton {
  PImage bg, off, on, storage;
  int x, y, x2, y2, x3, y3;
  int picture = 2;
  int clicked;
  float groesse = 1;
  float bigTouch = 1.1;
  float bigClick = 0.9;
  float smallTouch=0.95;
  float smallClick=0.85;
  float step = 0.07;
  boolean hitbox = true;
  int widthB;
  int heightB;
  boolean help = false;
  boolean bigB = true;
  float timer = 1;
  boolean swap = false;
  SwitchButton(PImage bgc, PImage offc, PImage onc, int xc, int yc, int widthBc, int heightBc) {
    this.bg=bgc;
    this.off=offc;
    this.on=onc;
    this.x=xc;
    this.y=yc;
    this.x2=xc;
    this.y2=yc;
    this.widthB=widthBc;
    this.heightB=heightBc;
  }

  public void show() {
    x = x2;
    y = y2;
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

  private void show2() {
    if (swap) {
      if (picture==2) {
        if (timer<1) {
          timer=timer+0.1;
        } else {
          timer = 1;
          swap=false;
        }
      } else {
        if (timer>0) {
          timer=timer-0.1;
        } else {
          timer = 0;
          swap=false;
        }
      }
    }
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
    pic=bg;
    if (touch()) {
      tint(150, 150, 200);
      if (mousePressed) {
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
    int wid = off.width;
    int heigh =off.height;
    image(pic, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
    image(on, x+w*((1-groesse)/2)+timer*((w-(1-groesse)*w)-(h-(1-groesse)*h)), (y+(h*(1-groesse)/2))-(((h-(1-groesse)*h)*(heigh) / (wid))-(h-(1-groesse)*h))/2, h-(1-groesse)*h, (h-(1-groesse)*h)*(heigh) / (wid));
    tint(255, 255, 255, int(255*(1-timer)));
    image(off, x+w*((1-groesse)/2)+timer*((w-(1-groesse)*w)-(h-(1-groesse)*h)), (y+(h*(1-groesse)/2))-(((h-(1-groesse)*h)*(heigh) / (wid))-(h-(1-groesse)*h))/2, h-(1-groesse)*h, (h-(1-groesse)*h)*(heigh) / (wid));
    tint(255, 255, 255, 255);
    noTint();
  }


  public boolean touch() {
    if (hitbox) {
      int r = x+widthB;
      int b=y+heightB;
      if (mouseX<r && mouseX>x && mouseY<b&& mouseY>y) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  public void setBig(float c, float t) {
    bigClick=c;
    bigTouch=t;
  }

  public void setSmall(float c, float t) {
    smallClick=c;
    smallTouch=t;
  }

  public void setStep(float c) {
    step=c;
  }

  public void setHitbox(boolean b) {
    hitbox=b;
  }

  public void setXY(int xa, int ya) {
    x = xa;
    y = ya;
    x2=xa;
    y2=ya;
    if (help) {
      println(bl()+"x and y set to: "+x+", "+y);
    }
  }

  public int getX() {
    return x;
  }

  public int getY() {
    return y;
  }

  public void setX(int xa) {
    x = xa;
    x2=xa;
    if (help) {
      println(bl()+"x set to: "+x);
    }
  }

  public void setY(int ya) {
    y = ya;
    y2=ya;
    if (help) {
      println(bl()+"y set to: "+y);
    }
  }

  public void setW(int w) {
    widthB=w;
    if (help) {
      println(bl()+"width set to: "+w);
    }
  }

  public int getW() {
    return widthB;
  }
  public void setH(int h) {
    heightB=h;
    if (help) {
      println(bl()+"height set to: "+y);
    }
  }
  public int getH() {
    return heightB;
  }

  public void setWH(int w, int h) {
    widthB = w;
    heightB = h;
    if (help) {
      println(bl()+"width and height set to: "+w+", "+h);
    }
  }

  public void pictureChange() {//switches the picture
    if (picture == 1) {
      picture = 2;
      timer = 0;
      swap=true;
    } else {
      picture = 1;
      timer = 1;
      swap=true;
    }
      playSound(click, 0.5*SoundEffectsSwitch.timer, true);
  }

  public int getStatus() {
    return picture;
  }

  public boolean getBig() {
    return bigB;
  }

  public void setBig(boolean b) {
    bigB = b;
    if (help) {
      println(bl()+"bigB set to: "+bigB);
    }
  }

  public void setPicture(int i) {//sets the picture to the integer
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

  public void clickedReset() {
    clicked = 0;
  }

  private void clicked() {
    println(bl()+"Button clicked "+(clicked+1)+" time(s)");
    clicked++;
  }

  private void clicked(boolean b) {
    if (b) {
      println(bl()+"Button clicked "+(clicked+1)+" time(s)");
    }
    clicked++;
  }

  public int getClicked() {
    return clicked;
  }

  public void setClicked(int i) {
    clicked = i;
  }

  private String bl() {
    return "[Button-Libary] ";
  }

  private void bl(String t) {
    println(bl()+t);
  }

  public void Released() {
    if (touch()&&mouseButton==LEFT) {
      pictureChange();
    }
  }

  public float getTimer() {
    return  timer;
  }
}

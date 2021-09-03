// ALL CODE WRITTEN BY ISAAC GILES and NATHAN REINERT
// This File Combines All Classes And Functions In A Logical Way To Clearly Organise The Game

import java.awt.AWTException;
import java.awt.Robot;
Robot MouseMover;

int currentOffset = 0;
int offsetIncr = 4;
boolean positiveOffset, negativeOffset;
int screenX = 2000;
int screenY = 1600;
int startX = 600;
int startY = 400;


boolean gamequit = false;
boolean gameplay = false;
boolean saving = false;
boolean load = false;
String endtext;
int levelnum;
String levelname;

int time;
int timeSinceGo;
int temp_score;
int score;
String[] strscore = new String[1];
String[] highscore = new String[1];


int l = 1;

int gameState = 0; // 0 = start, 1 = construction, 2 = playing, 3 = end, 4 = loading


// Setup Function
public void setup() {
  time = millis();
  highscore = loadStrings("saving/scores.txt");
  //////////////////////////////////////////////////Player Setup
  background(255, 255, 255);
  noFill();
  front1 = loadImage("images/FrontFacingPlayer.png");
  front2 = loadImage("images/FrontFacingPlayer(2).png");
  right1 = loadImage("images/RightFacingPlayer1.png");
  right2 = loadImage("images/RightFacingPlayer2.png");
  right3 = loadImage("images/RightFacingPlayer3.png");
  right4 = loadImage("images/RightFacingPlayer4.png");
  left1 = loadImage("images/LeftFacingPlayer1.png");
  left2 = loadImage("images/LeftFacingPlayer2.png");
  left3 = loadImage("images/LeftFacingPlayer3.png");
  left4 = loadImage("images/LeftFacingPlayer4.png");
  jump1 = loadImage("images/PlayerJump1.png");
  jump2 = loadImage("images/PlayerJump2.png");

  rightsequence[0] = right1;
  rightsequence[1] = right2;
  rightsequence[2] = right3;
  rightsequence[3] = right4;

  leftsequence[0] = left1;
  leftsequence[1] = left2;
  leftsequence[2] = left3;
  leftsequence[3] = left4;

  player.Pos = new PVector(startX, startY);
  player.Vel = new PVector(0, 0);
  player.Acc = new PVector(0, 0);

  player.Acc.set(0, 0.5);

  for (int i = 0; i < 4; i++) {
    rightsequence[i].resize(59, 75);
    leftsequence[i].resize(59, 75);
  }

  jump1.resize(59, 67);
  jump2.resize(59, 75);


  //////////////////basic setup//////////////////////////////////
  fullScreen(P2D);
  frameRate(60);

  // setup variables

  // load images
  loadMaterials();
  loadScreens();
  loadFireworks();
  loadOther();
  // setup mouse mover
  try {
    MouseMover = new Robot();
  } 
  catch (AWTException e) {
    println("Robot Class Not Supported");
    exit();
  }
}


// function for applying offset when user pans left and right
void applyOffset() {

  if (positiveOffset) {
    currentOffset += offsetIncr;
  }
  if (negativeOffset) {
    currentOffset -= offsetIncr;
  }

  pushMatrix();
  translate(currentOffset, 0);
}

// Draw Function
public void draw() {
  //println(gameState);
  background(250);
  applyOffset();
  displayScreen();
  popMatrix();
}

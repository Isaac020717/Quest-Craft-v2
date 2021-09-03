// This File Contains All Classes and Functions That Are Related To The Character
PImage front1, front2, right1, right2, right3, right4, left1, left2, left3, left4, jump1, jump2;

PImage[] rightsequence = new PImage[4];
PImage[] leftsequence = new PImage[4];

Character player = new Character();



class Character {


  PVector Pos, Vel, Acc;

  int rcount = 0;
  int lcount = 0;
  int jcount = 0;
  int ione = 0;
  int bcount = 0;

  boolean movingRight = false;
  boolean movingLeft = false;
  boolean jumping = false;
  boolean rscoll = false;
  boolean lscoll = false;
  boolean topcoll = false;
  boolean botcoll = false;
  boolean dead = false;

  Character() {
  }
  void drawHitbox() {

    stroke(0, 125, 0);
    strokeWeight(5);
    fill(125, 125, 125);
    line(Pos.x, Pos.y, Pos.x + 59, Pos.y);
    line(Pos.x + 59, Pos.y, Pos.x + 59, Pos.y + 75);
    line(Pos.x + 59, Pos.y + 75, Pos.x, Pos.y + 75);
    line(Pos.x, Pos.y + 75, Pos.x, Pos.y);
    strokeWeight(1);
  }

  void pan() {
    if (abs((0 - currentOffset) - Pos.x) < 150) {
      positiveOffset = true;
    } else {
      positiveOffset = false;
    }
    if (abs((width - currentOffset) - Pos.x) < 200) {
      negativeOffset = true;
    } else {
      negativeOffset = false;
    }
  }

  void bouncePlayer() {
    imageMode(CORNERS);
    bcount += 1;
    if (bcount <= 15) {
      image(front1, Pos.x, Pos.y);
    }

    if (bcount <= 30 && bcount > 15) {

      image(front2, Pos.x - 1, Pos.y+5);
    }

    if (bcount >= 30) {
      bcount = 0;
    }
  }


  void moveLeft() {
    imageMode(CORNERS);
    if (!movingRight) {
      Vel.x = -4;
      lcount ++;
      image(leftsequence[ione], Pos.x, Pos.y);
      if (lcount == 5) {
        ione++;
        lcount = 0;
      }
      if (ione == 3) {
        ione = 0;
      }
    }
  }

  void moveRight() {
    imageMode(CORNERS);
    //if (!movingLeft) {
    Vel.x = 4;
    rcount ++;
    image(rightsequence[ione], Pos.x, Pos.y);
    if (rcount == 5) {
      ione++;
      rcount = 0;
    }
    if (ione == 3) {
      ione = 0;
    }
    //}
  }

  void jump() {
    imageMode(CORNERS);
    if (!movingLeft && !movingRight) {
      if (Vel.y < 0) {
        image(jump1, Pos.x, Pos.y);
      }
      if (Vel.y == 0) {
        image(jump1, Pos.x, Pos.y);
      }
    }
  }

  void collisionDetection() {
    botcoll = false;

    for (int i = 0; i < TerrainBlocks.length; i++) {
      if (!(TerrainBlocks[i] == null)) {


        //Bottom Collisions
        if (Pos.y + 76 > TerrainBlocks[i].corners[2][1] && Pos.y + 75 < TerrainBlocks[i].corners[2][1] + 15 && Pos.y < TerrainBlocks[i].corners[2][1] && Pos.x < TerrainBlocks[i].corners[1][0] - 5 && Pos.x + 59 > TerrainBlocks[i].corners[0][0] + 5) { //if bottom of character is in block       

          botcoll = true;
          //println("botcoll");
          Pos.y = TerrainBlocks[i].corners[2][1] - 75;
          Vel.y = 0;
          if (TerrainBlocks[i].type == "lava") {
            dead = true; 
            endtext = "died";
          }
        } 

        //Top collisions
        if (Pos.y > TerrainBlocks[i].corners[2][1] && Pos.y < TerrainBlocks[i].corners[1][1] && Pos.y > TerrainBlocks[i].corners[1][1] - 10 && Pos.x < TerrainBlocks[i].corners[1][0] && Pos.x + 59 > TerrainBlocks[i].corners[0][0]) {
          Pos.y = TerrainBlocks[i].corners[1][1];
          Vel.y = 0;
          if (TerrainBlocks[i].type == "lava") {
            dead = true; 
            endtext = "died";
          }
        }

        //Left Side Collisions
        if (Pos.x < TerrainBlocks[i].corners[1][0] && Pos.x + 59 > TerrainBlocks[i].corners[1][0] && Pos.y + 75 > TerrainBlocks[i].corners[0][1] - TerrainBlocks[i].ySize && Pos.y < TerrainBlocks[i].corners[0][1]) {

          //println("Left Collision"); 
          lscoll = true;
          Pos.x = TerrainBlocks[i].corners[1][0];
          if (TerrainBlocks[i].type == "lava") {
            dead = true; 
            endtext = "died";
          }

          //Right Side Collision
        } else {
          lscoll = false;
        }
        if (Pos.x + 59 > TerrainBlocks[i].corners[0][0] && Pos.x < TerrainBlocks[i].corners[0][0] && Pos.y + 75 > TerrainBlocks[i].corners[0][1] - TerrainBlocks[i].ySize && Pos.y < TerrainBlocks[i].corners[0][1]) {
          //println("Right Collision");
          rscoll = true;
          Pos.x = TerrainBlocks[i].corners[0][0] - 59;
          if (TerrainBlocks[i].type == "lava") {
            dead = true; 
            endtext = "died";
          }
        } else {
          rscoll = false;
        }
      }
    }
    if (!botcoll) {
      Vel.add(Acc);
    }
  }

  void flagCollision() {
    for (int i = 0; i < Flags.length; i++) {
      if (Flags[i] != null) {
        if (Flags[i].placed) {
          if (Flags[i].type == "end") {
            if ((Pos.x < Flags[i].xPos + 15 && Pos.x > Flags[i].xPos - 15) || (Pos.x + 59 > Flags[i].xPos - 15 && Pos.x + 59 < Flags[i].xPos + 15) ) {
              if(Flags[i].yPos >= Pos.y && Flags[i].yPos <= Pos.y + 75){
              dead = true; 
              endtext = "won";
              timeSinceGo = millis() - time;
              }
            }
          }
        }
      }
    }
  }
}

/*
1. add velocity to position
 2. if player is on the ground, y velocity = 0, and they are not jumping
 3. of the player isn't movin to the left or right, x velocity = 0
 4. if the player is not moving up or down, do the idle animation
 5. if the player is jumping, run the jump function
 6. IF A KEY IS PRESSED
 7. if its right arrow key, move right
 8. if its left arrow key move left
 9. if its space, jump
 10. reset
 */


void playerMovement() {
  //player.drawHitbox();
  player.Pos.add(player.Vel);
  if (player.Vel.y == gridSpacing - 1) {
    player.Vel.y = gridSpacing - 2;
  }

  if (player.Pos.y > height - 77) {
    //player.Vel.y = 0;
    //player.jumping = false;
    //player.Pos.y = height - 77;

    player.dead = true;
    endtext = "died";
  }

  if (player.Vel.y > 0) {
    if (!player.movingLeft && !player.movingRight) {
      imageMode(CORNERS);
      image(front1, player.Pos.x, player.Pos.y);
    }
  }

  if (player.botcoll) {
    player.jumping = false;
  }

  if (player.movingRight) {
    player.moveRight();
    //println("MOVING RIGHT");
  }
  if (player.movingLeft) {
    player.moveLeft();
    //println("MOVING LEFT");
  }  

  if (player.jumping) {
    player.jump();
  }

  if (!player.movingLeft && !player.movingRight) { 
    /*
    if (player.Pos.y == height - 77) {
     player.Vel.x = 0;
     player.bouncePlayer();
     //println("NOT MOVING");
     }
     */
    if (player.botcoll) {
      player.bouncePlayer();
    }

    if (player.rscoll || player.lscoll) {
      if (player.Vel.y > 0 && player.Vel.x == 0) {
        imageMode(CORNERS);
        image(front1, player.Pos.x, player.Pos.y);
      }
    }
  }
}

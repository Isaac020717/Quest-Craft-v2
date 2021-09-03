PImage startS;
PImage endS;

PImage quitB, playB, createB, end1, resetB, PAB, loadB, loadBP, saveB;
int backgroundChosen;

Fireworks fw1 = new Fireworks();


public void loadScreens() {
  startS = loadImage("images/startScreenNoButtons.png");
  endS = loadImage("images/gameScreen3(1).png");
  quitB = loadImage("images/quitbutton.png");
  quitB.resize(143, 52);
  playB = loadImage("images/playbutton.png");
  playB.resize(143, 52);
  loadBP = loadImage("images/loadButtonPlaying.png");
  loadBP.resize(143, 52);
  saveB = loadImage("images/saveButton.png");
  saveB.resize(143, 52);
  createB = loadImage("images/createButton.png");
  createB.resize(200, 85);
  loadB = loadImage("images/loadButton.png");
  loadB.resize(200, 85);
  end1 = loadImage("images/end1.png");
  resetB = loadImage("images/resetButton.png");
  PAB = loadImage("images/playAgain.png");
}
public void displayScreen() {

  if (player.dead) {
    gameState = 3;
    player.dead = false;
  }

  if (gameState == 0) {
    currentOffset = 0;
    imageMode(CENTER);
    image(startS, width/2, height/2);
    image(createB, width/2, 400);

    if (mouseX > width/2 - 100 && mouseX < width/2 + 100) {
      if (mouseY > 360 && mouseY < 440) {
        image(createB, width/2, 400, 230, 100);
      }
    }
  }





  if (gameState == 1) {

    if (load) {
      textSize(64);
      fill(142, 154, 255);
      text("Choose Level 1-6 With Your Keyboard", width/2 - 550, height/2);
      if (keyPressed) {
        if (key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6') {
          levelnum = int(key) - 48;
          levelname = "saving/" + levelnum + ".txt";
          //println(levelname);
          gameState = 1;
          load();
        }
      }
    }
    if (saving) {
      textSize(32);
      fill(0, 0, 0);
      text("Press 1-6 On Your Keyboard To Save Level", width-900, 140);
      if (keyPressed) {
        if (key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6') {
          levelnum = int(key) - 48;
          levelname = "saving/" + levelnum + ".txt";
          savelevel();
          saving = false;
        }
      }
    }

    for (int i = 0; i < Flags.length; i++) {
      if (Flags[i] != null) {
        if (Flags[i].placed) {
          if (Flags[i].type == "start") {
            player.Pos.x = Flags[i].xPos - 30;
            player.Pos.y = Flags[i].yPos - 90;
          }
        }
      }
    }

    temp_score = 0;
    if (constructionMode) {
      //drawBackground();
      drawGrid();
      displayTerrain();      
      displayFlags();
      displayConstructionUI();
      highlights();

      if (!blockPlacingMode) {
        imageMode(CENTER);
        image(playB, 91 - currentOffset, 46);
        image(loadBP, (width - 160) - currentOffset, 80);
        image(saveB, (width - 160) - currentOffset, 180);
        if (mouseX > 20 && mouseX < 163) {
          if (mouseY > 20 && mouseY < 78) {
            //quitB.resize(154, 56);
            image(playB, 91 - currentOffset, 46, 154, 56);
          }
        }
        if(mouseX > width - 230 && mouseX < width - 90 ){
         if(mouseY > 58 && mouseY < 108){
          image(loadBP, (width - 160) - currentOffset, 80, 154, 56);
         }
        }
        
        if(mouseX > width - 230 && mouseX < width - 90){
          if(mouseY > 130 && mouseY < 210){
           image(saveB, (width - 160) - currentOffset, 180, 154, 56); 
          }
        }
        
      }
      if (keyPressed) {
        if (key == 'p') {
          gameState = 2;
        }
      }
      if (gameplay) {
        gameState = 2;
        gameplay = false;
      }
    }

    ///////////////////////////////////////////////to start press p
    if (blockPlacingMode) {
      if (keyPressed) {
        if (key == 'p') {
          blockPlacingMode = false; 
          gameState = 2;
        }
      }
    }
  }






  if (gameState == 2) {

    temp_score = 0;
    //text(player.Pos.x, player.Pos.x, 30);
    //text(currentOffset, player.Pos.x, 60);
    //drawGrid();
    displayTerrain();
    displayFlags();

    temp_score = millis() - timeSinceGo;



    imageMode(CENTER);
    image(quitB, 91 - currentOffset, 46);
    if (mouseX > 20 && mouseX < 163) {
      if (mouseY > 20 && mouseY < 78) {
        //quitB.resize(154, 56);
        image(quitB, 91 - currentOffset, 46, 154, 56);
      }
    }  

    player.collisionDetection();
    player.flagCollision();
    playerMovement();
    player.pan();
    if (keyPressed) {
      if (key == 'q') {
        gameState = 1;
        gamequit = false;
      }
    }
    if (gamequit) {
      gameState = 1;
      gamequit = false;
    }
  } 


  if (gameState == 3) {
    currentOffset = 0;
    if (l == 1) {
      l=2;
      score = temp_score;
      strscore[0] = "" + temp_score;
      if (int(strscore[0]) < int(highscore[0])) {
        saveStrings("saving/scores.txt", strscore);
      }
    }

    imageMode(CENTER);
    image(end1, width/2, height/2);
    image(resetB, width/2, 400);
    if (mouseX > width/2 - 182 && mouseX < width/2 + 182) {
      if (mouseY > 400 - 80 && mouseY < 400 + 80) {
        image(resetB, width/2, 400, 385, 179);
      }
    }
    image(PAB, width/2, 750);
    if (mouseX > width/2 - 182 && mouseX < width/2 + 182) {
      if (mouseY > 750 - 80 && mouseY < 750 + 80) {
        image(PAB, width/2, 750, 385, 179);
      }
    }
    constructionMode = false;
    textSize(64);
    fill(142, 154, 255);
    text("you " + endtext, width/2 - 130, 230);
    negativeOffset = false;
    positiveOffset = false;

    //fireworks
    fw1.shoot();
  }

  if (gameState == 4) {
    background(122, 255, 231);
  }
}

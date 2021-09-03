// This File Contains All Functions That Are Shared Between All Files

boolean keyrel = false;


// Mouse Pressed Function
public void mousePressed() {

  // check if user is clicking a button
  boolean clickingButton = false;
  for (Button b : ConstructionButtons) {
    if ( mouseX > ((b.buttonX + currentOffset) - (b.buttonXS/2)) && mouseX < ((b.buttonX + currentOffset) + (b.buttonXS/2)) ) {
      if ( mouseY > (b.buttonY - (b.buttonYS/2)) && mouseY < (b.buttonY + (b.buttonYS/2)) ) {
        if (!b.selected && b.active) {
          b.Click();
          clickingButton = true;
          break;
        } else if (b.active) {
          b.UnClick();
          clickingButton = true;
          break;
        }
      }
    }
  }

  if (blockPlacingMode && !placingBlock) { // BLOCK PLACING MODE (start)

    // if user is not clicking on a button, then draw terrain
    if (!clickingButton) {
      if (checkTerrainCollisions(int(mouseX), int(mouseY)) == "none") {
        placingBlock = true;
        for (int i = 0; i < TerrainBlocks.length; i++) {
          if (TerrainBlocks[i] == null) {
            snapMouseToGrid(false);
            TerrainBlocks[i] = new TerrainBlock(mouseX, mouseY, selectedTexture);
            blockBeingPlaced = i;
            break;
          }
        }
      }
    }
  } else if (blockPlacingMode) { // BLOCK PLACING MODE (end)

    snapMouseToGrid(false);
    TerrainBlocks[blockBeingPlaced].CalculateTempPosSize();
    if (TerrainBlocks[blockBeingPlaced].xSize > 0 && TerrainBlocks[blockBeingPlaced].ySize > 0) {
      if (!TerrainBlocks[blockBeingPlaced].CheckPlacementCollisions(false)) {
        placingBlock = false;
        TerrainBlocks[blockBeingPlaced].place = true;
      }
    }
  } else if (flagPlacingMode && !clickingButton) { // FLAG PLACING MODE

    // if there are no collisions then place the flag
    snapMouseToGrid(false);
    Flags[flagBeingPlaced].CalculatePosition();
    if (!Flags[flagBeingPlaced].CheckPlacementCollisions(false)) {
      placingFlag = false;
      Flags[flagBeingPlaced].place = true;
      flagPlacingMode = false;
      placingFlag = false;
      for (Button b : ConstructionButtons) {
        if (b.selected == true) {
          b.UnClick();
        }
      }
    }
  } else if (blockMovingMode) { // BLOCK MOVING MODE

    if (!clickingButton && !movingBlock && !movingFlag) {
      blockBeingPlaced = checkTerrainSelection( int(mouseX), int(mouseY) );
      if (blockBeingPlaced != 1000) {
        TerrainBlocks[blockBeingPlaced].moving = true;
        TerrainBlocks[blockBeingPlaced].placed = false;
        movingBlock = true;
      }
      flagBeingPlaced = checkOtherSelection( int(mouseX), int(mouseY) );
      if (flagBeingPlaced != 1000) {
        Flags[flagBeingPlaced].moving = true;
        Flags[flagBeingPlaced].placed = false;
        movingFlag = true;
      }
    } else if (!clickingButton && (movingBlock || movingFlag)) {

      if (movingBlock) {
        snapMouseToGrid(true);
        if (!TerrainBlocks[blockBeingPlaced].CheckPlacementCollisions(true)) {
          TerrainBlocks[blockBeingPlaced].place = true;
          movingBlock = false;
        }
      } else if (movingFlag) {
        snapMouseToGrid(false);
        if (!Flags[flagBeingPlaced].CheckPlacementCollisions(true)) {
          Flags[flagBeingPlaced].place = true;
          movingFlag = false;
        }
      }
    }
  } else if (blockDeletingMode) { // BLOCK DELETING MODE

    if (!clickingButton) {
      int blockToDelete = checkTerrainSelection( int(mouseX), int(mouseY) );
      if (blockToDelete != 1000) {
        TerrainBlocks[blockToDelete] = null;
      } else {
        blockToDelete = checkOtherSelection( int(mouseX), int(mouseY) );
        if (blockToDelete != 1000) {
          for (Button b : ConstructionButtons) {
            if ( (b.ButtonName == "EndFlag" && Flags[blockToDelete].type == "end") || (b.ButtonName == "StartFlag" && Flags[blockToDelete].type == "start") ) {
              b.fade = false;
            }
          }
          Flags[blockToDelete] = null;
        }
      }
    }
  }


  //quit
  if (gameState == 2) {
    if (mouseX > 20 && mouseX < 163) {
      if (mouseY > 20 && mouseY < 78) {
        gamequit = true;
      }
    }
  }

  //play
  if (gameState == 1) {
    
    if(mouseX > width - 230 && mouseX < width - 90 ){
         if(mouseY > 58 && mouseY < 108){
          load = true;
         }
        }
        
        if(mouseX > width - 230 && mouseX < width - 90){
          if(mouseY > 130 && mouseY < 210){
           saving = true;
          }
        }
    if (mouseX > 20 && mouseX < 163) {
      if (mouseY > 20 && mouseY < 78) {

        for (int i = 0; i < Flags.length; i++) {
          if (Flags[i] != null) {
            if (Flags[i].placed) {
              if (Flags[i].type == "start") {
                if (Flags[i].xPos < width/2) {
                  currentOffset = Flags[i].xPos;
                } else {
                  currentOffset = -1 * Flags[i].xPos;
                }
                gameplay = true;
                timeSinceGo = millis();
                timeSinceGo -= time;
              }
            }
          }
        }
      }
    }
  }


  //////game state buttons

  if (gameState == 0) {

    if (mouseX > width/2 - 100 && mouseX < width/2 + 100) {
      if (mouseY > 315 && mouseY < 485) {
        currentOffset = 0;
        gameState = 1;
      }
    }
    
  }

  if (gameState == 1) {
  }

  if (gameState == 3) {
    l = 1;
    if (mouseX > width/2 - 182 && mouseX < width/2 + 182) {////////////////////play again
      if (mouseY > 750 - 80 && mouseY < 750 + 80) {
        gameState = 2;
        player.Vel.y = 0;
        constructionMode = true;
        blockPlacingMode = false;


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
      }
    }

    if (mouseX > width/2 - 182 && mouseX < width/2 + 182) {/////////////////////reset
      if (mouseY > 400 - 80 && mouseY < 400 + 80) {

        currentOffset = 0;
        for (int i = 0; i < TerrainBlocks.length; i ++) {
          TerrainBlocks[i] = null;
        }

        for (int i = 0; i < Flags.length; i++) {
          Flags[i] = null;
        }
        gameState = 0;
        player.Pos.x = startX;
        player.Pos.y = startY;
        player.Vel.y = 0;
        constructionMode = true;
        blockPlacingMode = false;
      }
    }
  }
}


// Mouse Released Function
public void mouseReleased() {
}


// Mouse Moved Function
public void mouseMoved() {
}


public void keyPressed() {

  if (gameState == 1) {
  }

  if (key == 'p') {
    gameState = 1;
  }

  if (key == ' ' && !player.jumping) {

    player.jumping = true;
    player.Vel.y = -10;
    player.Pos.y -= 1;
  } 
  if (key == 'd') {
    player.movingRight = true;
  }
  if (key == 'a') {
    player.movingLeft = true;
  }



  if (key == CODED) {

    if (keyCode == RIGHT && !placingBlock) {

      if (constructionMode) {
        negativeOffset = true;
      }
    }
    if (keyCode == LEFT && !placingBlock) {

      if (constructionMode) {
        positiveOffset = true;
      }
    }
    if (keyCode == SHIFT) {
      for (Button b : ConstructionButtons) {
        if (b.selected == true) {
          b.UnClick();
        }
      }
    }
  } else if (key == ENTER) {

    for (Button b : ConstructionButtons) {
      if (b.selected == true) {
        b.UnClick();
      }
    }
  }
}

void keyReleased() {
  //println("KEY RELEASED");
  if (key == 'a') {
    player.movingLeft = false; 
    player.Vel.x = 0;
  }

  if (key == 'd') {
    player.movingRight = false; 
    player.Vel.x = 0;
  }  
  if (key == CODED) {

    if (keyCode == RIGHT) {

      if (constructionMode) {
        negativeOffset = false;
      }
    }
    if (keyCode == LEFT) {

      if (constructionMode) {
        positiveOffset = false;
      }
    }
  }
}

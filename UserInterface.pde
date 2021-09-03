PImage TerrainButton, FlagButton, MoveTerrainButton, DeleteTerrainButton, ReturnToBuildMenu, DirtIcon, GrassIcon, LavaIcon, StartFlagIcon, FadedStartFlagIcon, EndFlagIcon, FadedEndFlagIcon;
boolean showReturnToBuildMenu = false;


// Button Class
class Button {
  
  String ButtonName;
  
  int standardX, buttonX, buttonY, buttonXS, buttonYS;
  String ClickFunction, UnClickFunction;
  PImage buttonImg, fadedImg;
  
  boolean active, hover, selected, hide, fade;
  int hoverSizeX, hoverSizeY;
  
  // Class Declaration
  Button(int x, int y, int xs, int ys, boolean act, String cf, String uf, PImage img, String bname) {
    standardX = x;
    buttonX = x;
    buttonY = y;
    buttonXS = xs;
    hoverSizeX = buttonXS + 10;
    buttonYS = ys;
    hoverSizeY = buttonYS + 10;
    active = act;
    ClickFunction = cf;
    UnClickFunction = uf;
    buttonImg = img;
    ButtonName = bname;
  }
  Button(int x, int y, int xs, int ys, boolean act, String cf, String uf, PImage img, PImage faded, String bname) {
    standardX = x;
    buttonX = x;
    buttonY = y;
    buttonXS = xs;
    hoverSizeX = buttonXS + 10;
    buttonYS = ys;
    hoverSizeY = buttonYS + 10;
    active = act;
    ClickFunction = cf;
    UnClickFunction = uf;
    buttonImg = img;
    fadedImg = faded;
    ButtonName = bname;
  }
  
  
  // function for displaying the button
  void Display() {
    
    // change position of button based on camera offset
    buttonX = standardX - currentOffset;
    
    // check to see if mouse is over the button
    if ( mouseX > ((buttonX + currentOffset) - (buttonXS/2)) && mouseX < ((buttonX+currentOffset) + (buttonXS/2)) ) {
      if ( mouseY > (buttonY - (buttonYS/2)) && mouseY < (buttonY + (buttonYS/2)) ) {
        hover = true;
      } else {
        hover = false;
      }
    } else {
      hover = false;
    }
    
    // draw button
    imageMode(CENTER);
    if (!hover && !hide) {
      if (fade) {
        image(fadedImg, buttonX, buttonY);
      } else {
        image(buttonImg, buttonX, buttonY);
      }
    } else if (!hide) {
      if (fade) {
        image(fadedImg, buttonX, buttonY, hoverSizeX, hoverSizeY);
      } else {
        image(buttonImg, buttonX, buttonY, hoverSizeX, hoverSizeY);
      }
    }
    
    // show this label if a button is in use
    if (selected) {
      method(ClickFunction);
    }
    
  }
  
  // function for when user is clicking button
  void Click() {
    selected = true;
    method(ClickFunction);
  }
  // function for when user is clicking button
  void UnClick() {
    selected = false;
    method(UnClickFunction);
  }
  
}




// BUTTON FUNCTIONS //

// Terrain Button Functions
public void TerrainButtonClick() {
  for (Button b : ConstructionButtons) {
    if (b.ButtonName == "Dirt" || b.ButtonName == "Grass" || b.ButtonName == "Lava") {
      b.active = true;
      b.hide = false;
    }
  }
}
public void TerrainButtonUnClick() {
  for (Button b : ConstructionButtons) {
    if (b.ButtonName == "Dirt" || b.ButtonName == "Grass" || b.ButtonName == "Lava") {
      b.active = false;
      b.hide = true;
    }
  }
}

// Flag Button Functions
public void FlagButtonClick() {
  for (Button b : ConstructionButtons) {
    if (b.ButtonName == "StartFlag" || b.ButtonName == "EndFlag") {
      b.active = true;
      b.hide = false;
    }
  }
}
public void FlagButtonUnClick() {
  for (Button b : ConstructionButtons) {
    if (b.ButtonName == "StartFlag" || b.ButtonName == "EndFlag") {
      b.active = false;
      b.hide = true;
    }
  }
}

// Move Terrain Button Functions
public void MoveTerrainButtonClick() {
  blockMovingMode = true;
  for (Button b : ConstructionButtons) {
      b.active = false;
      b.hide = true;
  }
  showReturnToBuildMenu = true;
}
public void MoveTerrainButtonUnClick() {
  blockMovingMode = false;
  for (Button b : ConstructionButtons) {
    if (b.ButtonName == "MoveTerrain" || b.ButtonName == "DeleteTerrain" || b.ButtonName == "Terrain" || b.ButtonName == "Flags") {
      b.active = true;
      b.hide = false;
    }
  }
  showReturnToBuildMenu = false;
}

// Delete Terrain Button Functions
public void DeleteTerrainButtonClick() {
  blockDeletingMode = true;
  for (Button b : ConstructionButtons) {
      b.active = false;
      b.hide = true;
  }
  showReturnToBuildMenu = true;
}
public void DeleteTerrainButtonUnClick() {
  blockDeletingMode = false;
  for (Button b : ConstructionButtons) {
    if (b.ButtonName == "MoveTerrain" || b.ButtonName == "DeleteTerrain" || b.ButtonName == "Terrain" || b.ButtonName == "Flags") {
      b.active = true;
      b.hide = false;
    }
  }
  showReturnToBuildMenu = false;
}

// Dirt Button Functions
public void DirtIconClick() {
  blockPlacingMode = true;
  selectedTexture = "dirt";
  for (Button b : ConstructionButtons) {
      b.active = false;
      b.hide = true;
  }
  showReturnToBuildMenu = true;
}
public void DirtIconUnClick() {
  blockPlacingMode = false;
  for (Button b : ConstructionButtons) {
    if (b.ButtonName == "Terrain" || b.ButtonName == "MoveTerrain" || b.ButtonName == "DeleteTerrain" || b.ButtonName == "Flags") {
      b.active = true;
      b.hide = false;
    }
  }
  showReturnToBuildMenu = false;
}

// Grass Button Functions
public void GrassIconClick() {
  blockPlacingMode = true;
  selectedTexture = "grass";
  for (Button b : ConstructionButtons) {
      b.active = false;
      b.hide = true;
  }
  showReturnToBuildMenu = true;
}
public void GrassIconUnClick() {
  blockPlacingMode = false;
  for (Button b : ConstructionButtons) {
    if (b.ButtonName == "Terrain" || b.ButtonName == "MoveTerrain" || b.ButtonName == "DeleteTerrain" || b.ButtonName == "Flags") {
      b.active = true;
      b.hide = false;
    }
  }
  showReturnToBuildMenu = false;
}

// Lava Button Functions
public void LavaIconClick() {
  blockPlacingMode = true;
  selectedTexture = "lava";
  for (Button b : ConstructionButtons) {
      b.active = false;
      b.hide = true;
  }
  showReturnToBuildMenu = true;
}
public void LavaIconUnClick() {
  blockPlacingMode = false;
  for (Button b : ConstructionButtons) {
    if (b.ButtonName == "Terrain" || b.ButtonName == "MoveTerrain" || b.ButtonName == "DeleteTerrain" || b.ButtonName == "Flags") {
      b.active = true;
      b.hide = false;
    }
  }
  showReturnToBuildMenu = false;
}

// Start Flag Button Functions
public void StartFlagIconClick() {
  
  boolean canClick = true;
  for (int i = 0; i < Flags.length; i++) {
    if (Flags[i] != null) {
      if (Flags[i].type == "start") {
        canClick = false;
        break;
      }
    }
  }
  if (canClick) {
    for (int i = 0; i < Flags.length; i++) {
      if (Flags[i] == null) {
        Flags[i] = new Flag(mouseX, mouseY, "start");
        flagBeingPlaced = i;
        break;
      }
    }
    for (Button b : ConstructionButtons) {
        b.active = false;
        b.hide = true;
    }
    flagPlacingMode = true;
    placingFlag = true;
    showReturnToBuildMenu = true;
  }
  
}
public void StartFlagIconUnClick() {
  flagPlacingMode = false;
  placingFlag = false;
  for (Button b : ConstructionButtons) {
    if (b.ButtonName == "Flags" || b.ButtonName == "Terrain" || b.ButtonName == "MoveTerrain" || b.ButtonName == "DeleteTerrain") {
      b.active = true;
      b.hide = false;
    }
  }
  showReturnToBuildMenu = false;
}

// End Flag Button Functions
public void EndFlagIconClick() {
  
  boolean canClick = true;
  for (int i = 0; i < Flags.length; i++) {
    if (Flags[i] != null) {
      if (Flags[i].type == "end") {
        canClick = false;
        break;
      }
    }
  }
  if (canClick) {
    for (int i = 0; i < Flags.length; i++) {
      if (Flags[i] == null) {
        Flags[i] = new Flag(mouseX, mouseY, "end");
        flagBeingPlaced = i;
        break;
      }
    }
    for (Button b : ConstructionButtons) {
        b.active = false;
        b.hide = true;
    }
    flagPlacingMode = true;
    placingFlag = true;
    showReturnToBuildMenu = true;
  }
  
}
public void EndFlagIconUnClick() {
  flagPlacingMode = false;
  placingFlag = false;
  for (Button b : ConstructionButtons) {
    if (b.ButtonName == "Flags" || b.ButtonName == "Terrain" || b.ButtonName == "MoveTerrain" || b.ButtonName == "DeleteTerrain") {
      b.active = true;
      b.hide = false;
    }
  }
  showReturnToBuildMenu = false;
}




// FUNCTIONS FOR SWITCHING BETWEEN SCREENS //

// Function For Displaying All UI For Construction
public void displayConstructionUI() {
  
  // instantiating UI classes, and loading images
  if (!ConstructionButtonsInstantiated) {
    ReturnToBuildMenu = loadImage("images/ReturnToBuildMenu.png");
    
    // Main Buttons
    TerrainButton = loadImage("images/PlaceTerrain.png");
    ConstructionButtons.add( new Button(75, (height-75), 100, 100, true, "TerrainButtonClick", "TerrainButtonUnClick", TerrainButton, "Terrain") );
    
    FlagButton = loadImage("images/RFlagButton(2).png");
    ConstructionButtons.add( new Button(200, (height-75), 100, 100, true, "FlagButtonClick", "FlagButtonUnClick", FlagButton, "Flags") );
    
    MoveTerrainButton = loadImage("images/MoveTerrain.png");
    ConstructionButtons.add( new Button(width-200, (height-75), 100, 100, true, "MoveTerrainButtonClick", "MoveTerrainButtonUnClick", MoveTerrainButton, "MoveTerrain") );
    
    DeleteTerrainButton = loadImage("images/DeleteTerrain.png");
    ConstructionButtons.add( new Button(width-75, (height-75), 100, 100, true, "DeleteTerrainButtonClick", "DeleteTerrainButtonUnClick", DeleteTerrainButton, "DeleteTerrain") );
    
    // Terrain Button Pop Ups
    DirtIcon = loadImage("images/DirtIcon.png");
    ConstructionButtons.add( new Button(75, (height-200), 70, 70, false, "DirtIconClick", "DirtIconUnClick", DirtIcon, "Dirt") );
    
    GrassIcon = loadImage("images/GrassIcon.png");
    ConstructionButtons.add( new Button(75, (height-300), 70, 70, false, "GrassIconClick", "GrassIconUnClick", GrassIcon, "Grass") );
    
    LavaIcon = loadImage("images/LavaIcon.png");
    ConstructionButtons.add( new Button(75, (height-400), 70, 70, false, "LavaIconClick", "LavaIconUnClick", LavaIcon, "Lava") );
    
    // Flag Button Pop Ups
    StartFlagIcon = loadImage("images/GFlag(2).png");
    FadedStartFlagIcon = loadImage("images/GFlag(2)Faded.png");
    ConstructionButtons.add( new Button(200, (height-200), 70, 70, false, "StartFlagIconClick", "StartFlagIconUnClick", StartFlagIcon, FadedStartFlagIcon, "StartFlag") );
    
    EndFlagIcon = loadImage("images/RFlag(2).png");
    FadedEndFlagIcon = loadImage("images/RFlag(2)Faded.png");
    ConstructionButtons.add( new Button(200, (height-300), 70, 70, false, "EndFlagIconClick", "EndFlagIconUnClick", EndFlagIcon, FadedEndFlagIcon, "EndFlag") );
    
    ConstructionButtonsInstantiated = true;
  }
  
  // displaying active buttons
  for (Button b : ConstructionButtons) {
    if (b.active) {
      b.Display();
    }
  }
  
  // displaying non class based UI
  if (showReturnToBuildMenu) {
    imageMode(CENTER);
    image(ReturnToBuildMenu, width/2-currentOffset, height-70);
  }
  
}


// Function For Applying A Red Border To Objects That Are Selected To Be Deleted
public void highlights() {
  
  if (blockDeletingMode) {
    int blockSelection = checkTerrainSelection( int(mouseX), int(mouseY) );
    if (blockSelection != 1000) {
      rectMode(CENTER); noFill(); stroke(#D12828); strokeWeight(10);
      rect(TerrainBlocks[blockSelection].xPos, TerrainBlocks[blockSelection].yPos, TerrainBlocks[blockSelection].xSize+10, TerrainBlocks[blockSelection].ySize+10);
    } else {
      int otherSelection = checkOtherSelection( int(mouseX), int(mouseY) );
      if (otherSelection != 1000) {
        rectMode(CENTER); noFill(); stroke(#D12828); strokeWeight(10);
        rect(Flags[otherSelection].xPos, Flags[otherSelection].yPos, Flags[otherSelection].xSize+10, Flags[otherSelection].ySize+10);
      }
    }
  }
  
}

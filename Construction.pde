// This File Contains All Classes, Functions And Variables That Are Related To Terrain And Construction

// VARIABLES //
TerrainBlock[] TerrainBlocks = new TerrainBlock[100];
Flag[] Flags = new Flag[2];

// Global Terrain Variables
boolean constructionMode = true; // Only true for now!! Change Later!
  boolean blockPlacingMode = false;
    boolean placingBlock = false;
  boolean blockMovingMode = false;
    boolean movingBlock = false;
  boolean blockDeletingMode = false;
int blockBeingPlaced = 0;
String selectedTexture;

// Terrain Buttons
ArrayList<Button> ConstructionButtons = new ArrayList<Button>();
boolean ConstructionButtonsInstantiated = false;

// Materials
PImage dirtTexture, grassTexture, lavaTexture;

// Grid Variables
int gridSpacing = 20;
int[] gridLinesX;
int[] gridLinesY;



// CLASSES //
class TerrainBlock {
  
  int xPos;
  int yPos;
  int xSize;
  int ySize;
  
  int cols = 4; int rows = 2;
  int[][] corners = new int[cols][rows];
  
  int[] interiorGridX  = new int[0];
  int[] interiorGridY  = new int[0];
  
  boolean placing = true;
  boolean place = false;
  boolean placed = false;
  boolean moving = false;
  
  String type;
  PImage texture;
  
  
  TerrainBlock(int cornerX, int cornerY, String t) {
    corners[0][0] = cornerX-currentOffset;
    corners[0][1] = cornerY;
    type = t;
  }
  TerrainBlock(int x, int y, int xs, int ys, String t) {
    xPos = x;
    yPos = y;
    xSize = xs;
    ySize = ys;
    type = t;
    CalculateCornersWithPosSize();
    CalculateInteriorGrid();
    placed = true;
    placing = false;
  }
  
  
  // Block Placing Function
  void placeBlock() {
    
    if (place) {
      
      place = false;
      placing = false;
      placed = true;
      
      if (!moving) {
        
        // calculate the corner positions
        CalculateCorners();
        // make border for collisions
        CalculateInteriorGrid();
        // calculate position and size of block
        CalculatePosSize();
        
      } else {
        
        // Calculate Position and Size of Block
        CalculateMovementPosSize();
        
        // Calculate Interior Grid Of The Terrain Block
        ReCalculateInteriorGrid();
        
        // reset variable
        moving = false;
        
      }
      
    }
    
    fill(6, 223, 240);
    noStroke();
    
    if (placing) {
      rectMode(CORNERS);
      rect(corners[0][0], corners[0][1], mouseX-currentOffset, mouseY, 3);
    } else if (moving) {
      rectMode(CENTER);
      rect(mouseX-currentOffset, mouseY, xSize, ySize, 3);
    }
    
    //this draws the texture
    if (!moving && placed) {
      for (int i = 0; i < interiorGridX.length; i++) {
        imageMode(CENTER);
        if (type == "dirt") {
          image(dirtTexture, interiorGridX[i], interiorGridY[i]);
        } else if (type == "grass") {
          image(grassTexture, interiorGridX[i], interiorGridY[i]);
        } else if (type == "lava") {
          image(lavaTexture, interiorGridX[i], interiorGridY[i]);
        }
      }
    }
    
  }
  
  
  // Function To Check For Collisions Between Block And Other Blocks
  boolean CheckPlacementCollisions(boolean adjust) {
    
    boolean returnValue = false;
    
    if (!adjust) {
      CalculateTempPosSize();
    } else {
      CalculateMovementPosSize();
    }
    
    for (int i = 0; i < TerrainBlocks.length; i++) {
      if (TerrainBlocks[i] != this && TerrainBlocks[i] != null) {
        if ( (abs(TerrainBlocks[i].xPos - xPos) < ((TerrainBlocks[i].xSize/2) + (xSize/2)) ) && (abs(TerrainBlocks[i].yPos - yPos) < ((TerrainBlocks[i].ySize/2) + (ySize/2)) ) ) {
          returnValue = true;
        }
      }
    }
    
    return returnValue;
    
  }
  
  
  // Function For Calculating The Size and Position of A Terrain Block
  void CalculateTempPosSize() {
    xSize = abs(corners[0][0] - (mouseX-currentOffset));
    ySize = abs(corners[0][1] - mouseY);
    // set x position
    if ((mouseX-currentOffset) > corners[0][0]) {
      xPos = (corners[0][0] + (xSize/2));
    } else {
      xPos = (corners[0][0] - (xSize/2));
    }
    // set y position
    if (mouseY > corners[0][1]) {
      yPos = (corners[0][1] + (ySize/2));
    } else {
      yPos = (corners[0][1] - (ySize/2));
    }
  }
  // Function For Calculating The Size and Position of A Terrain Block
  void CalculatePosSize() {
    xSize = abs(corners[0][0] - corners[2][0]);
    ySize = abs(corners[0][1] - corners[2][1]);
    xPos = (corners[0][0] + (xSize/2));
    yPos = (corners[0][1] - (ySize/2));
  }
  // Function For Calculating The Size and Position of A Terrain Block That Is Being Moved/Rearranged
  void CalculateMovementPosSize() {
    int moveAmountX = int( ((mouseX-currentOffset) - xPos) );
    int moveAmountY = int( (mouseY - yPos) );
    
    // change corner positions
    for (int c = 0; c<cols; c++) {
      for (int r = 0; r<cols; r++) {
        if (r == 0) {
          corners[c][r] = corners[c][r] + moveAmountX;
        } else if (r == 1) {
          corners[c][r] = corners[c][r] + moveAmountY;
        }
      }
    }
    
    // change centre position
    xPos = xPos + moveAmountX;
    yPos = yPos + moveAmountY;
  }
  
  
  // Function To Find Where The Corners Should Be
  void CalculateCorners() {
    if (mouseX-currentOffset > corners[0][0]) {
      corners[2][0] = mouseX-currentOffset;
    } else {
      corners[2][0] = corners[0][0];
      corners[0][0] = mouseX-currentOffset;
    }
    if (mouseY < corners[0][1]) {
      corners[2][1] = mouseY;
    } else {
      corners[2][1] = corners[0][1];
      corners[0][1] = mouseY;
    }
    // top right corner
    corners[1][0] = corners[2][0];
    corners[1][1] = corners[0][1];
    // bottom left corner
    corners[3][0] = corners[0][0];
    corners[3][1] = corners[2][1];
  }
  
  
  // Function To Find Where The Corners Should Be Based On Centre Position and Size
  void CalculateCornersWithPosSize() {
    
    // bottom left : 0
    // bottom right : 1
    // top left : 2
    // top left : 3
    
    corners[0][0] = xPos - (xSize/2);
    corners[0][1] = yPos + (ySize/2);
    
    corners[1][0] = xPos + (xSize/2);
    corners[1][1] = yPos + (ySize/2);
    
    corners[2][0] = xPos + (xSize/2);
    corners[2][1] = yPos - (ySize/2);
    
    corners[3][0] = xPos - (xSize/2);
    corners[3][1] = yPos - (ySize/2);
    
  }
  
  
  // Function To Determine Which Grid Squares Are Inside Of The Terrain Block
  void CalculateInteriorGrid() {
    
    for (int i = 0; i<gridLinesX.length; i++) {
      for (int j = 0; j<gridLinesY.length; j++) {
        int gridBoxX = gridLinesX[i] + (gridSpacing/2);
        int gridBoxY = gridLinesY[j] + (gridSpacing/2);
        if (gridBoxX > corners[0][0] && gridBoxX < corners[2][0]) {
          if (gridBoxY < corners[0][1] && gridBoxY > corners[2][1]) {
            interiorGridX = expand(interiorGridX, (interiorGridX.length + 1));
            interiorGridY = expand(interiorGridY, (interiorGridY.length + 1));
            interiorGridX[interiorGridX.length - 1] = gridBoxX;
            interiorGridY[interiorGridY.length - 1] = gridBoxY;
          }
        }
      }
    }
    
  }
  
  // Function To Determine Which Grid Squares Are Inside Of The Terrain Block
  void ReCalculateInteriorGrid() {
    
    interiorGridX = expand(interiorGridX, 0);
    interiorGridY = expand(interiorGridY, 0);
    
    for (int i = 0; i<gridLinesX.length; i++) {
      for (int j = 0; j<gridLinesY.length; j++) {
        int gridBoxX = gridLinesX[i] + (gridSpacing/2);
        int gridBoxY = gridLinesY[j] + (gridSpacing/2);
        if (gridBoxX > corners[0][0] && gridBoxX < corners[2][0]) {
          if (gridBoxY < corners[0][1] && gridBoxY > corners[2][1]) {
            interiorGridX = expand(interiorGridX, (interiorGridX.length + 1));
            interiorGridY = expand(interiorGridY, (interiorGridY.length + 1));
            interiorGridX[interiorGridX.length - 1] = gridBoxX;
            interiorGridY[interiorGridY.length - 1] = gridBoxY;
          }
        }
      }
    }
    
  }
  
}


/////////////////// FLAGS /////////////////////////////////////////


// Flag Variables
boolean flagPlacingMode = false;
  boolean placingFlag = false;
  boolean movingFlag = false;
int flagBeingPlaced = 0;

// Flag Images
PImage startFlag, endFlag;


class Flag {
  
  int xPos;
  int yPos;
  int xSize;
  int ySize;
  
  int cols = 4; int rows = 2;
  int[][] corners = new int[cols][rows];
  
  boolean placing = true;
  boolean place = false;
  boolean placed = false;
  boolean moving = false;
  
  String type;
  
  
  Flag(int x, int y, String t) {
    xPos = x;
    yPos = y;
    type = t;
  }
  
  
  // Block Placing Function
  void placeFlag() {
    
    if (place) {
      
      place = false;
      placing = false;
      placed = true;
      
      for (Button b : ConstructionButtons) {
        if ( (b.ButtonName == "EndFlag" && type == "end") || (b.ButtonName == "StartFlag" && type == "start") ) {
          b.fade = true;
        }
      }
      
      if (!moving) {
        
        // calculate all positions for collisions and placement
        CalculatePosition();
        
      } else {
        
        // calculate all positions for collisions and placement
        CalculatePosition();
        
        // reset variable
        moving = false;
        
      }
      
    }
    
    if (placing || moving) {
      imageMode(CENTER);
      if (type == "start") {
        image(startFlag, mouseX-currentOffset, mouseY);
      } else if (type == "end") {
        image(endFlag, mouseX-currentOffset, mouseY);
      }
    } else if (placed) {
      imageMode(CENTER);
      if (type == "start") {
        image(startFlag, xPos, yPos);
      } else if (type == "end") {
        image(endFlag, xPos, yPos);
      }
    }
    
  }
  
  
  // Function To Check For Collisions Between Block And Other Blocks
  boolean CheckPlacementCollisions(boolean adjust) {
    
    boolean returnValue = false;
    
    if (adjust) {
      // calculate all positions for collisions and placement
      CalculatePosition();
    }
    
    for (int i = 0; i < TerrainBlocks.length; i++) {
      if (TerrainBlocks[i] != null) {
        if ( (abs(TerrainBlocks[i].xPos - xPos) < ((TerrainBlocks[i].xSize/2) + (xSize/2)) ) && (abs(TerrainBlocks[i].yPos - yPos) < ((TerrainBlocks[i].ySize/2) + (ySize/2)) ) ) {
          returnValue = true;
        }
      }
    }
    for (int i = 0; i < Flags.length; i++) {
      if (Flags[i] != this && Flags[i] != null) {
        if ( (abs(Flags[i].xPos - xPos) < ((Flags[i].xSize/2) + (xSize/2)) ) && (abs(Flags[i].yPos - yPos) < ((Flags[i].ySize/2) + (ySize/2)) ) ) {
          returnValue = true;
        }
      }
    }
    
    return returnValue;
    
  }
  
  
  // Function For Setting Position Variables
  void CalculatePosition() {
    xPos = mouseX - currentOffset;
    yPos = mouseY;
    if (type == "start") {
      xSize = startFlag.width;
      ySize = startFlag.height;
    } else if (type == "end") {
      xSize = endFlag.width;
      ySize = endFlag.height;
    }
  }
  
}




// FUNCTIONS //


// Function For Loading Material Image Files
public void loadMaterials() {
  dirtTexture = loadImage("images/dirtTexture2.jpg");
  dirtTexture.resize(gridSpacing, gridSpacing);
  grassTexture = loadImage("images/grassTexture.jpg");
  grassTexture.resize(gridSpacing, gridSpacing);
  lavaTexture = loadImage("images/lavaTexture.jpg");
  lavaTexture.resize(gridSpacing, gridSpacing);
}
// Function For Loading Other Image Files
public void loadOther() {
  startFlag = loadImage("images/GFlag(2).png");
  endFlag = loadImage("images/RFlag(2).png");
}


// Grid Drawing Function
boolean initializeGrid = true;
public void drawGrid () {
  
  int minx = ( (width/2) - (screenX/2) );
  int maxx = ( (width/2) + (screenX/2) );
  
  int miny = ( (height/2) - (screenY/2) );
  int maxy = ( (height/2) + (screenY/2) );
  
  if (initializeGrid) {
    gridLinesX = new int[screenX/gridSpacing+1];
    gridLinesY = new int[screenY/gridSpacing+1];
  }
  
  // place vertical lines
  for (int i = 0; i<gridLinesX.length; i++) {
    if (initializeGrid) {
      gridLinesX[i] = ( minx + (gridSpacing*i) );
    }
    stroke(50); strokeWeight(1);
    line(gridLinesX[i], miny, gridLinesX[i], maxy);
  }
  
  // place horizontal lines
  for (int i = 0; i<gridLinesY.length; i++) {
    if (initializeGrid) {
      gridLinesY[i] = ( miny + (gridSpacing*i) );
    }
    stroke(50); strokeWeight(1);
    line(minx, gridLinesY[i], maxx, gridLinesY[i]);
  }
  
  initializeGrid = false;
  
}


// Function Snaps Mouse To Grid
public void snapMouseToGrid(boolean adjust) {
  
  int closestX = 0;
  int offsetX = 0;
  for (int i = 1; i<gridLinesX.length; i++) {
    if (adjust) { // adjustment may be required
      
      if ( (TerrainBlocks[blockBeingPlaced].xSize / gridSpacing)%2 != 0) {
        if ( abs(mouseX - ( gridLinesX[i]+currentOffset + (gridSpacing/2) )) < abs(mouseX - ( gridLinesX[closestX]+currentOffset + (gridSpacing/2) )) ) {
          closestX = i;
          offsetX = gridSpacing/2;
        }
      } else {
        if ( abs(mouseX - (gridLinesX[i]+currentOffset)) < abs(mouseX - (gridLinesX[closestX]+currentOffset)) ) {
          closestX = i;
        }
      }
      
    } else { // adjustment is not required
      
      if ( abs(mouseX - (gridLinesX[i]+currentOffset)) < abs(mouseX - (gridLinesX[closestX]+currentOffset)) ) {
        closestX = i;
      }
      
    }
  }
  
  
  int closestY = 0;
  int offsetY = 0;
  for (int i = 1; i<gridLinesY.length; i++) {
    if (adjust) { // adjustment may be required
      
      if ( (TerrainBlocks[blockBeingPlaced].ySize / gridSpacing)%2 != 0) {
        if ( abs(mouseY - ( gridLinesY[i] + (gridSpacing/2) )) < abs(mouseY - ( gridLinesY[closestY] + (gridSpacing/2) )) ) {
          closestY = i;
          offsetY = gridSpacing/2;
        }
      } else {
        if ( abs(mouseY - (gridLinesY[i])) < abs(mouseY - (gridLinesY[closestY])) ) {
          closestY = i;
        }
      }
      
    } else { // adjustment is not required
      
      if ( abs(mouseY - gridLinesY[i]) < abs(mouseY - gridLinesY[closestY]) ) {
        closestY = i;
      }
      
    }
  }
  
  
  // move mouse
  MouseMover.mouseMove( (gridLinesX[closestX] + currentOffset + offsetX), (gridLinesY[closestY] + offsetY) );
  mouseX = (gridLinesX[closestX] + currentOffset + offsetX);  mouseY = (gridLinesY[closestY] + offsetY);
  
}


// When Called This Function Displays All Terrain
public void displayTerrain() {
  for (int i = 0; i < TerrainBlocks.length; i++) {
    if (TerrainBlocks[i] != null) {
      TerrainBlocks[i].placeBlock();
    }
  }
}
// When Called This Function Displays All Flags
public void displayFlags() {
  for (int i = 0; i < Flags.length; i++) {
    if (Flags[i] != null) {
      Flags[i].placeFlag();
    }
  }
}


// Function That Returns The Type of Block You Click On 
public String checkTerrainCollisions(int xValue, int yValue) {
  String returnValue = "none";
  
  // Check For Collision With A Terrain Block
  for (int i = 0; i < TerrainBlocks.length; i++) {
    if (TerrainBlocks[i] != null) {
      if (TerrainBlocks[i].placed) {
        if ( (xValue >= (TerrainBlocks[i].corners[0][0]+currentOffset)) && (xValue <= (TerrainBlocks[i].corners[2][0]+currentOffset)) ) {
          if ( (yValue <= TerrainBlocks[i].corners[0][1]) && (yValue >= TerrainBlocks[i].corners[2][1]) ) {
            // we have a collision 
            returnValue = TerrainBlocks[i].type;
            break;
          }
        }
      }
    }
  }
  
  return returnValue;
}


// Function That Returns The Index of The Block You Click On 
public int checkTerrainSelection(int xValue, int yValue) {
  int returnValue = 1000;
  
  // Check For Collision With A Terrain Block
  for (int i = 0; i < TerrainBlocks.length; i++) {
    if (TerrainBlocks[i] != null) {
      if (TerrainBlocks[i].placed) {
        if ( (xValue >= (TerrainBlocks[i].corners[0][0]+currentOffset)) && (xValue <= (TerrainBlocks[i].corners[2][0]+currentOffset)) ) {
          if ( (yValue <= TerrainBlocks[i].corners[0][1]) && (yValue >= TerrainBlocks[i].corners[2][1]) ) {
            // we have a collision 
            returnValue = i;
            break;
          }
        }
      }
    }
  }
  
  return returnValue;
}
// Function That Returns The Index of The Non-Terrain Object You Click On 
public int checkOtherSelection(int xValue, int yValue) {
  int returnValue = 1000;
  
  // Check For Collision With A Flag of Any Other Non-Terrain Object
  for (int i = 0; i < Flags.length; i++) {
    if (Flags[i] != null) {
      if (Flags[i].placed) {
        if ( (xValue >= (Flags[i].xPos-(Flags[i].xSize/2)+currentOffset)) && (xValue <= (Flags[i].xPos+(Flags[i].xSize/2)+currentOffset)) ) {
          if ( (yValue <= ( Flags[i].yPos+(Flags[i].ySize/2) )) && (yValue >= ( Flags[i].yPos-(Flags[i].ySize/2) )) ) {
            // we have a collision 
            returnValue = i;
            break;
          }
        }
      }
    }
  }
  
  return returnValue;
}

//attempt at a save function
String name;
void savelevel() {

  String[] level1 = new String[0];
  level1 = append(level1, str(Flags[0].xPos));
  level1 = append(level1, str(Flags[0].yPos));
  level1 = append(level1, Flags[0].type);
  level1 = append(level1, " ");
  level1 = append(level1, str(Flags[1].xPos));
  level1 = append(level1, str(Flags[1].yPos));
  level1 = append(level1, Flags[1].type);
  level1 = append(level1, " ");
  for (int i = 0; i < TerrainBlocks.length; i++) {
    if (TerrainBlocks[i] != null) {
      level1 = append(level1, str(TerrainBlocks[i].xPos)); 
      level1 = append(level1, str(TerrainBlocks[i].yPos));
      level1 = append(level1, str(TerrainBlocks[i].xSize));
      level1 = append(level1, str(TerrainBlocks[i].ySize));
      level1 = append(level1, TerrainBlocks[i].type);
      level1 = append(level1, " ");
    }
  }
  saveStrings(levelname, level1);
}

void load() {
  load = false;
  for(int i = 0; i < TerrainBlocks.length; i++){
   TerrainBlocks[i] = null; 
  }
  
  String[] lines = loadStrings(levelname);
  Flags[0] = new Flag(int(lines[0]), int(lines[1]), "start");
  Flags[0].xSize = startFlag.width;
  Flags[0].ySize = startFlag.height;
  Flags[0].placed = true;
  flagPlacingMode = false;
  placingFlag = false;
  Flags[0].placing = false;
  Flags[0].place = false;


  Flags[1] = new Flag(int(lines[4]), int(lines[5]), "end");
  Flags[1].xSize = endFlag.width;
  Flags[1].ySize = endFlag.height;
  Flags[1].placed = true;
  flagPlacingMode = false;
  placingFlag = false;
  Flags[1].placing = false;
  Flags[1].place = false;


  for (int i = 0; i < lines.length; i++) {
    if (lines[i].equals("dirt")) {

      for (int j = 0; j < TerrainBlocks.length; j++) {

        if (TerrainBlocks[j] == null) {
          TerrainBlocks[j] = new TerrainBlock(int(lines[i-4]), int(lines[i-3]), int(lines[i-2]), int(lines[i-1]), "dirt");
          break;
        }
      }
    } else if (lines[i].equals("grass")) {
      for (int j = 0; j < TerrainBlocks.length; j++) {

        if (TerrainBlocks[j] == null) {
          TerrainBlocks[j] = new TerrainBlock(int(lines[i-4]), int(lines[i-3]), int(lines[i-2]), int(lines[i-1]), "grass");
          break;
        }
      }
    } else if (lines[i].equals("lava")) {

      for (int j = 0; j < TerrainBlocks.length; j++) {

        if (TerrainBlocks[j] == null) {
          TerrainBlocks[j] = new TerrainBlock(int(lines[i-4]), int(lines[i-3]), int(lines[i-2]), int(lines[i-1]), "lava");
          break;
        }
      }
    }
  }
}

PImage launching, f1, f2, f3, f4, f5, f6, f7, f8;
void loadFireworks(){
 launching = loadImage("images/launching.png"); 
 f1 = loadImage("images/f1.png"); 
 f2 = loadImage("images/f2.png"); 
 f3 = loadImage("images/f3.png");
 f4 = loadImage("images/f4.png");
 f5 = loadImage("images/f5.png");
 f6 = loadImage("images/f6.png");
 f7 = loadImage("images/f7.png");
 f8 = loadImage("images/f8.png");
}

class Fireworks{
  int x, y = 850;
  int fc = 0;
  boolean is_launching = false;
  boolean exploding = false;
  boolean reset = false;
  
  Fireworks(){
  }
  void launch(){
    is_launching = true;
    x = int(random(0,width));
  }
  void explode(){
    is_launching = false;
    exploding = true;
    fc ++;
    if (fc >= 0 && fc < 4){
    image(f1, x, y);
    } else if (fc >= 4 && fc < 8){
    image(f2, x, y);  
    } else if (fc >= 8 && fc < 12){
    image(f3, x, y);  
    } else if (fc >= 12 && fc < 16){
    image(f4, x, y); 
    } else if (fc >= 16 && fc < 20){
    image(f5, x, y);
    } else if (fc >= 20 && fc < 24){
    image(f6, x, y);  
    } else if (fc >= 24 && fc < 28){
    image(f7, x, y);  
    } else if (fc >= 32 && fc < 36){
    image(f8, x, y); 
    fc = 0;
    exploding = false;
    reset = true;
    } 
    
  }
  
  void shoot(){
    int ft = millis();
    if (ft%1000 <= 15 && !(fw1.is_launching|| fw1.exploding)) {
      fw1.launch();
    }
    
    if (fw1.is_launching) {
      fw1.y-=3;
      image(launching, fw1.x, fw1.y);
    }
    
    if(ft%3000 <= 45 || fw1.exploding){
     fw1.explode(); 
    }
    
    if(fw1.reset){
     fw1.reset = false;
     fw1.is_launching = false;
     fw1.exploding = false;
     fw1.y = 850;
    }
  }
  
}

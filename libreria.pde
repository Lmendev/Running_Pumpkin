void pintarBotonJugar () {
  /* Función que pinta, maneja el control 
  de flujo y animación del boton jugar 
  en la pantalla de inicio */
  
  if(mouseX<325 && mouseX>100 && mouseY<280 && mouseY>200){
    image(jugar2, 100, 200);
    if(mousePressed)
      pantalla=1;
  }else
    image(jugar1, 100, 200);
}

void loadCharacter() {
//Calabaza
  imagen = loadImage("character/calabaza.png");
  mundo= new int[8][13];
calabaza = loadImage("character/calabaza.png");
}

void loadMonsters(){
  bruja = loadImage("monsters/bruja.png");
  momia = loadImage("monsters/momia.png");
  lobo = loadImage("monsters/lobo.png");
  calabera = loadImage("monsters/calabera.png");
  
}

void loadTiles(){
  baldosa = loadImage("tiles/tile.jpg");
}

void loadAnimations(){
  A1 = loadImage("animations/A1.png");
  A2 = loadImage("animations/A2.png");
  A3 = loadImage("animations/A3.png");
  A4 = loadImage("animations/A4.png");
  A5 =  loadImage("animations/A5.png");
  A6 = loadImage("animations/A6.png");
  
}

void loadCursor(){
  //--Cargar imagenes de cursor--//
  cursor1 = loadImage("cursor/cursor.png");
  cursor2 = loadImage("cursor/cursorpress.png");
}

void loadBackgrounds(){
  fondoInicio = loadImage("backgrounds/inicio.jpg"); // Imagen de fondo
  creditos= loadImage("backgrounds/fondoCreditos.png");
  win=loadImage("backgrounds/Win1.png");
   fondoMundo = loadImage("backgrounds/fondoMundo.jpg");
}

void loadSounds(){
  minim2 = new Minim(this);
  minim = new Minim(this);
  
  groove = minim.loadFile("sounds/musicaInicio.mp3");
  groove2 = minim2.loadFile("sounds/scream3.mp3");
  
}

void loadButtons(){
jugar1 = loadImage("buttons/jugar1.png");          // Boton jugar
  jugar2 = loadImage("buttons/jugar2.png");
  creditos1 = loadImage("buttons/creditos1.png");    // Boton creditos
  creditos2 = loadImage("buttons/creditos2.png");
    back = loadImage("buttons/back.png");
  back1 = loadImage("buttons/back1.png");
}


void pintarBotonCreditos() {
  /* Función que pinta, maneja el control 
  de flujo y animación del boton creditos 
  en la pantalla de inicio */
  
  if(mouseX<325&&mouseX>100&&mouseY<380&&mouseY>300){
    image(creditos2, 100, 300);
    if(mousePressed)
      pantalla=2;
  }else
    image(creditos1, 100, 300);  
}

void pintarBotonRegresar() {
  /* Función que pinta, maneja el control 
  de flujo y animación del boton back 
  en la pantalla de inicio */

  image(back,880,10);
    if(mouseX<72+880&&mouseX>880&&mouseY<72&&mouseY>10){
      image(back1, 880, 10);
        if(mousePressed){
          mundoAct=1;
          pantalla=0;
        }
    }
}

void pintarBotonRegresar2() {
  image(back,10,10);
      if(mouseX<72&&mouseX>10&&mouseY<72&&mouseY>10){
        image(back1, 10, 10);
        if(mousePressed)
             pantalla=0;
      }
}

void controlAnimacionMouse(){
if (mousePressed)
    image(cursor2, mouseX-cursor2.width/2,mouseY-cursor2.height/2);
  else
    image(cursor1, mouseX-cursor1.width/2,mouseY-cursor1.height/2);

}

void playMusic(){
  groove.loop();
}

void pintarBotonRegresar3(){
image(back,10,10);
      if(mouseX<72&&mouseX>10&&mouseY<72&&mouseY>10){
        image(back1, 10, 10);
          if(mousePressed)
            pantalla=0;
      }
}

void pintarBaldosas(){
for (k=0;k<cantB;k++)
      image(baldosa, posBaldosas[k].x, posBaldosas[k].y);
    for (u=0;u<cantM;u++)
      drawBody(monsters[u]);
}


void controlCalabaza(){
tint(255);
      if (usuario2.alive){
        if(!usuario2.isOut(mundo)) {
          
          if(mousePressed){
            if(usuario2.alive) {
              if(!sw){
                PVector mousePossition = new PVector(mouseX,mouseY);
                if(mousePossition.dist(usuario2.getLocation())<=usuario2.getDimension().y){
                  sw=true;
                  mouseX=parseInt(usuario2.getLocation().x);
                  mouseY=parseInt(usuario2.getLocation().y);
                }
              }else{
                if(!sw2 && mousePressed){
                  usuario2.setLocation(mouseX,mouseY);
                }
                
              }
            drawBody(usuario2);
            }else{//drawBody(usuario2); 
            } 
          }else{
            if(!usuario2.alive)
      usuario2.alive=true; 
      sw=false;
            sw2=false;
      usuario2.setImage(loadImage("character/calabaza.png"));
      drawBody(usuario2);
          }
        }else{
          if(!usuario2.isFinish(mundo)){
      usuario2.alive=false;
      usuario2.setImage(loadImage("character/calabaza1.png"));
            groove2 = minim2.loadFile("sounds/scream3.mp3", 512);
            groove2.play();
            //usuario2.setLocation(usuario2.getxInicial(),usuario2.getyInicial());
          }else{
            sw=false;
            usuario2.alive = true;
            if (mundoAct<12){
              loadLevel ("backgrounds/fondoMundo.jpg","levels/mundo"+mundoAct+".txt");  
              mundoAct++;  
            }else
              pantalla=3;
          }
        }
      }else{
        sw2=false;
        if(ani<5)
          image(A1, usuario2.locationX()-95, usuario2.locationY()-100);
        else if (ani<10)
            image(A2, usuario2.locationX()-95, usuario2.locationY()-100);
        else if (ani<15)
            image(A3, usuario2.locationX()-95, usuario2.locationY()-100);
        else if (ani<20)
            image(A4, usuario2.locationX()-95, usuario2.locationY()-100);
        else if (ani<25)
            image(A5, usuario2.locationX()-95, usuario2.locationY()-100);
        else if (ani<30){
            image(A6, usuario2.locationX()-95, usuario2.locationY()-100);
            ani =-1;
            usuario2.setLocation(usuario2.getxInicial(),usuario2.getyInicial());
            usuario2.alive = true;
            sw2=true;
         }
         ani++;
      }
}


public void animacion (){
  if(ani<5)
    image(A1, usuario2.locationX()-95, usuario2.locationY()-100);
  else if (ani<10)
      image(A2, usuario2.locationX()-95, usuario2.locationY()-100);
    else if (ani<15)
        image(A3, usuario2.locationX()-95, usuario2.locationY()-100);
      else if (ani<20)
            image(A4, usuario2.locationX()-95, usuario2.locationY()-100);
          else if (ani<25)
              image(A5, usuario2.locationX()-95, usuario2.locationY()-100);
            else if (ani<30){
                image(A6, usuario2.locationX()-95, usuario2.locationY()-100);
                ani =-1;
                usuario2.setLocation(usuario2.getxInicial(),usuario2.getyInicial());
                usuario2.alive = true;
              }
  ani++;
  
}

public void loadLevel (String fondo, String matMundo) {
  fondoMundo = loadImage(fondo);
  lines = loadStrings(matMundo);
  //Calcular cantidad de Baldosas y monsters en el mundo
  cantB=cantM=0;
  for (int i=0; i<lines.length; i++){
    posiciones = split(lines[i], ",");
    for(int j=0; j<posiciones.length; j++){
      if(posiciones[j].compareTo("1")==0 || posiciones[j].compareTo("2")==0 || posiciones[j].compareTo("3")==0)
        cantB++;
      if(posiciones[j].compareTo("5")==0 || posiciones[j].compareTo("3")==0|| posiciones[j].compareTo("10")==0|| posiciones[j].compareTo("6")==0|| posiciones[j].compareTo("7")==0)
        cantM++;
      if(posiciones[j].compareTo("2")==0)
        usuario2 = new Body(j*80+39,i*75+39,imagen,0);
      mundo[i][j]=parseInt(posiciones[j]);
    }
  }
  
  //Guardar las posiciones de las baldosas y los Monsters en una Matriz
  posBaldosas= new PVector[cantB];
  monsters = new Monster[cantM];
  k=u=0;
  for (int i=0; i<lines.length; i++){
    posiciones = split(lines[i], ",");
    for(int j=0; j<posiciones.length; j++){
      if (posiciones[j].compareTo("1")==0|| posiciones[j].compareTo("2")==0 || posiciones[j].compareTo("3")==0){
        posBaldosas[k] = new PVector();
        posBaldosas[k].x = j*80;
        posBaldosas[k].y = i*75;
        k++;
      }
      if (posiciones[j].compareTo("5")==0){
        monsters[u] = new Monster("monsters/momia.png", j*80+33, i*75+33, (int)random(3));
        u++;
      }
      if (posiciones[j].compareTo("6")==0){
        monsters[u] = new Monster("monsters/lobo.png", j*80+33, i*75+33, (int)random(3));
        u++;
      }
      if (posiciones[j].compareTo("7")==0){
        monsters[u] = new Monster("monsters/calabera.png", j*80+33, i*75+33, (int)random(3));
        u++;
      }
      if (posiciones[j].compareTo("3")==0){
        monsters[u] = new Monster("monsters/bruja.png", j*80+33, i*75+33, (int)random(3));
        u++;
      }
      if (posiciones[j].compareTo("10")==0){
        monsters[u] = new Monster("monsters/calabera.png", j*80+33, i*75+33, 3);
        monsters[u].setDistanciaSt(22);
        //monsters[u].set(4);
        u++;
      }
    }
  }
}
    
    
public void drawBody(Body b){
  pushMatrix();
    PVector location =b.getLocation();
    PVector dim =b.getDimension();
    translate(location.x,location.y);
    rotate(b.getRotation());
    noStroke();
    beginShape();
      texture(b.imageTexture);
      vertex(-dim.x/2,-dim.y/2,0,0);
      vertex(dim.x/2,-dim.y/2,dim.x,0);
      vertex(dim.x/2,dim.y/2,dim.x,dim.y);
      vertex(-dim.x/2,dim.y/2,0,dim.y);
    endShape();
  popMatrix();
}

public void drawBody(Monster b) {
  pushMatrix();
  switch(b.getAnimacion()){
    case 0: //animacion 1
      translate(b.getX(), b.getY());
      rotate(b.getTheta());
      image(b.getImage(), -28, -28);
      if(b.getTheta()>PI/4|| b.getTheta()<-PI/4)
        b.changeSt();
      b.setTheta(b.getTheta() + (PI / 100)* b.getSt());
      break;
    
    case 1: //animacion 2
      translate(b.getX(), b.getY());
      image(b.getImage(), -20, -26);
      if(b.getTiempoAct()== b.getTiempo()){
        b.setY(b.getY()+(1*b.getSt()));
        b.setDistanciaAct(b.getDistanciaAct()+1);
        if(b.getDistanciaAct() > b.getDistancia()){
          b.changeSt();
          b.setDistanciaAct(0);
        }
        b.setTiempoAct(0);
      }
      b.setTiempoAct(b.getTiempoAct()+1);
      break;
      
    case 2:// Animacion 3
      translate(b.getX(), b.getY());
      rotate(b.getTheta());
      scale(1,b.getScaleY());
      image(b.getImage(), -28, -28);
      if(b.getScaleY()>(1.3)|| b.getScaleY()<1)
        b.changeSt();
      b.setScaleY(b.getScaleY()+(0.03*b.getSt()));
      break;
    
    case 3:// Animacion 4
      //animaciòn de colision
      translate(b.getX(), b.getY());
      image(b.getImage(), -20, -26);
      if(b.getTiempoAct() > b.getTiempo()){
        b.setY(b.getY()+(4* b.getSt()));
        b.setDistanciaAct(b.getDistanciaAct()+1);
        if(b.getDistanciaAct() > b.getDistancia()){
          b.changeSt();
          b.setDistanciaAct(0);
        }
        b.setTiempoAct(0);
      }
      b.setTiempoAct(b.getTiempoAct()+2);
      
      //colision
      if (dist(b.getX()+10,b.getY(), usuario2.locationX(),usuario2.locationY())<60){
        usuario2.alive=false;
        groove2 = minim2.loadFile("sounds/scream3.mp3", 512);
        groove2.play();
        usuario2.setImage(loadImage("character/calabaza1.png"));
        //sw2=false;
        //usuario2.setLocation(usuario2.getxInicial(),usuario2.getyInicial());
      }           
      break;
  }
  popMatrix();
}
  


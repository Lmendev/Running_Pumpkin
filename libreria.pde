//--Librería Running Pumpkin--//
/*Fecha de creación: 24/'8/2013 */


//--Cargar imagenes--//

public void loadCharacter() {
  //--Cargar imagen calabaza--//
  calabazaImage = loadImage("character/calabaza.png");  // Cargar imagen calabaza
}

public void loadMonsters(){
  //--Cargar imagenes monstruos--//
  brujaImage = loadImage("monsters/bruja.png");  // Cargar imagen bruja
  momiaImage = loadImage("monsters/momia.png");  // Cargar imagen momia
  loboImage = loadImage("monsters/lobo.png");    // Cargar imagen lobo
  calaberaImage = loadImage("monsters/calabera.png");  // Cargar imagen calabera
}

public void loadTiles(){
  //--Cargar imagenes baldosas--//
  baldosa = loadImage("tiles/tile.jpg");  // Cargar imagen baldosa
}

public void loadAnimations(){
  //--Cargar imagenes animaciones--//
  animacion = loadImage("animations/animacion.png");  // Cargar imagen animación muerte 
}

public void loadCursor(){
  //--Cargar imagenes de cursor--//  
  spritecursor = loadImage("cursor/cursorsprite.png");  // Cargar imagen cursor
}

public void loadBackgrounds(){
  //--Cargar imagenes de fondo--//
  fondoInicio = loadImage("backgrounds/inicio.jpg");  // Cargar fondo pantalla inicio 
  creditos= loadImage("backgrounds/fondoCreditos.png");  // Cargar fondo pantalla creditos
  win=loadImage("backgrounds/Win1.png");  // Cargar fondo pantalla ganador
  fondoMundo = loadImage("backgrounds/fondoMundo.jpg");  // Cargar fondo pantalla mundo
}

public void loadSounds(){
  //--Cargar musica--//
  minim2 = new Minim(this);
  minim = new Minim(this);
  
  groove = minim.loadFile("sounds/musicaInicio.mp3");  // Cargar musica de fondo
  groove2 = minim2.loadFile("sounds/scream3.mp3");  // Cargar sonido scream;  
}

public void loadButtons(){
  //--Cargar imagenes botones--//
  jugarButton = new button("buttons/jugar1.png", "buttons/jugar2.png", 100, 200, 1);
  creditosButton = new button("buttons/creditos1.png", "buttons/creditos2.png", 100, 300, 2);
  backButton = new button("buttons/back.png", "buttons/back1.png", 10, 10, 0);
}

//--Fin cargar imagenes--//


//--Controlador botones--//

boolean eventoActivado=false, eventoFinalizado=false;

public void drawButton(button boton, boolean ultimoButton){
  
  if(mouseX>boton.getPosX() && mouseY>boton.getPosY() && mouseX<boton.getLimitX() && mouseY<boton.getLimitY()){
    image(boton.getOverImage(), boton.getPosX(), boton.getPosY());
 
    if(boton.getTarget() && eventoFinalizado){
      pantalla = boton.getNextScreen();
      eventoFinalizado=false;
    }
    
    if(eventoActivado){
      boton.setTarget(true);
      eventoActivado=false;
    }
  }else{
    image(boton.getDefaultImage(), boton.getPosX(), boton.getPosY());
    
    if(boton.getTarget() && eventoFinalizado){
      boton.setTarget(false);
    }
  }
  if(eventoFinalizado && ultimoButton)
      eventoFinalizado=false;
  
  if (eventoActivado && ultimoButton)
      eventoActivado=false;
}

public void mousePressed() {
  eventoActivado = true;
}

public void mouseReleased(){
  eventoFinalizado = true;
}

//--Fin controlador botones--//


void controlAnimacionMouse(){
  
  if (mousePressed){
    if(mousePossition.dist(usuario2.getLocation())<=usuario2.getDimension().y/2)
      tocado=true;
    if(tocado)
        image(spritecursor.get(28,0,28,31),usuario2.getLocation().x-11,usuario2.getLocation().y-8);
     else
        image(spritecursor.get(28,0,28,31), mouseX-spritecursor.width/4,mouseY-spritecursor.height/2);
  }
  else{
    image(spritecursor.get(0,0,28,31), mouseX-spritecursor.width/4,mouseY-spritecursor.height/2);
    tocado=false;
  }
}

void playMusic(){
  groove.loop();
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
        colisionando=false;
        if(!usuario2.isOut(mundo)) {
          
          if(mousePressed){
            if(usuario2.alive) {
              if(!sw){
                mousePossition.x=mouseX;
                mousePossition.y=mouseY;
                if(mousePossition.dist(usuario2.getLocation())<=usuario2.getDimension().y/2){
                  sw=true;
                  mouseDistance.x=usuario2.getLocation().x-mouseX;
                  mouseDistance.y=usuario2.getLocation().y-mouseY;
                  
                  
                }
              }else{
                if(!sw2 && mousePressed){
                  usuario2.setLocation(parseInt(mouseX+mouseDistance.x),parseInt(mouseY+mouseDistance.y));
               
                  
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
        animacion();
         
      }
}


public void animacion (){
  if(ani<5)
   image(animacion.get(0,0,164,174), usuario2.locationX()-95, usuario2.locationY()-100);
  else if (ani<10)
      image(animacion.get(168,0,164,174), usuario2.locationX()-95, usuario2.locationY()-100);
    else if (ani<15)
        image(animacion.get(336,0,164,174), usuario2.locationX()-95, usuario2.locationY()-100);
      else if (ani<20)
            image(animacion.get(504,0,164,174), usuario2.locationX()-95, usuario2.locationY()-100);
          else if (ani<25)
               image(animacion.get(672,0,162,174), usuario2.locationX()-95, usuario2.locationY()-100);
            else if (ani<30){
                image(animacion.get(840,0,168,174), usuario2.locationX()-95, usuario2.locationY()-100);
                ani =-1;
                usuario2.setLocation(usuario2.getxInicial(),usuario2.getyInicial());
                usuario2.alive = true;
                sw2=true;
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
        usuario2 = new Body(j*80+39,i*75+39,calabazaImage,0);
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
        if(!colisionando){
        groove2.play();
        }
        usuario2.setImage(loadImage("character/calabaza1.png"));
        colisionando =true;
        //sw2=false;
        //usuario2.setLocation(usuario2.getxInicial(),usuario2.getyInicial());
      }           
      break;
  }
  popMatrix();
}
  


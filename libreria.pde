
//--Librería Running Pumpkin--//
/*Fecha de creación: 24/08/2013 */


//--Cargar imagenes--//

public void loadAnimations(){
  //--Cargar imagenes animaciones--//
  animacion = loadImage("animations/animacion.png");  // Cargar imagen animación muerte 
}

public void loadBackgrounds(){
  //--Cargar imagenes de fondo--//
  fondoInicio = loadImage("backgrounds/inicio.jpg");  // Cargar fondo pantalla inicio 
  creditos= loadImage("backgrounds/fondoCreditos.png");  // Cargar fondo pantalla creditos
  win=loadImage("backgrounds/Win1.png");  // Cargar fondo pantalla ganador
  fondoMundo = loadImage("backgrounds/fondoMundo.jpg");  // Cargar fondo pantalla mundo
}

public void loadButtons(){
  //--Cargar imagenes botones--//
  jugarButton = new button("buttons/jugar1.png", "buttons/jugar2.png", 100, 200, 1);
  creditosButton = new button("buttons/creditos1.png", "buttons/creditos2.png", 100, 300, 2);
  backButton = new button("buttons/back.png", "buttons/back1.png", 10, 10, 0);
}

public void loadCharacter() {
  //--Cargar imagen calabaza--//
  calabazaImage = loadImage("character/calabaza.png");  // Cargar imagen calabaza
}

public void loadCursor(){
  //--Cargar imagenes de cursor--//  
  spritecursor = loadImage("cursor/cursorsprite.png");  // Cargar imagen cursor
}

public void loadMonsters(){
  //--Cargar imagenes monstruos--//
  brujaImage = loadImage("monsters/bruja.png");  // Cargar imagen bruja
  momiaImage = loadImage("monsters/momia.png");  // Cargar imagen momia
  loboImage = loadImage("monsters/lobo.png");    // Cargar imagen lobo
  calaberaImage = loadImage("monsters/calabera.png");  // Cargar imagen calabera
}

public void loadSounds(){
  //--Cargar musica--//
  
  groove = new SoundFile(this, "sounds/musicaInicio.mp3");  // Cargar musica de fondo
  if(groove==null)  println("No se pudo cargar el archivo 'sounds/musicaInicio.mp3'.");
  
  groove2 = new SoundFile(this, "sounds/scream3.mp3");  // Cargar sonido scream;  
  if(groove2==null)  println("No se pudo cargar el archivo 'sounds/scream3.mp3'.");
}

public void loadTiles(){
  //--Cargar imagenes baldosas--//
  baldosa = loadImage("tiles/tile.jpg");  // Cargar imagen baldosa
}

//--Fin cargar imagenes--//


//--Controlador botones--//

private boolean eventoActivado=false, eventoFinalizado=false;

private void drawButton(button boton, boolean ultimoButton){
  //--Controlador botones--//
  if(mouseX>boton.getPosX() && mouseY>boton.getPosY() && mouseX<boton.getLimitX() && mouseY<boton.getLimitY()){
    // Si el cursor se encuentra sobre el boton //
    image(boton.getOverImage(), boton.getPosX(), boton.getPosY());  // Pintar overImage
    if(boton.getTarget() && eventoFinalizado){
      // Si el boton se encuentra seleccionado y el evento ha finalizado //
      pantalla = boton.getNextScreen();  // Cambiar a siguiente pantalla
      boton.setTarget(false);  // Desactivar seleccion de botón
      eventoFinalizado=false;  // Desactivar evento finalizado
    }
    if(eventoActivado){
      // Si el evento ha sido activado //
      boton.setTarget(true);  // Activar seleccion de boton
      eventoActivado=false;  // Desactivar evento activado
    }
  }else{
    // Si el cursor no se encuentra sobre el boton //
    image(boton.getDefaultImage(), boton.getPosX(), boton.getPosY());  // Pintar defaultImage
    if(boton.getTarget() && eventoFinalizado)
      // Si boton seleccionado y el evento ha finalizado //
      boton.setTarget(false); // Desactivar seleccion de botón
  }
  
  if(eventoFinalizado && ultimoButton)
    eventoFinalizado=false;
  
  if (eventoActivado && ultimoButton)
    eventoActivado=false;
}

public void mousePressed() {
  eventoActivado = true;
}

public void mouseReleased() {
  eventoFinalizado = true;
}

//--Fin controlador botones--//


public void controlAnimacionMouse() {
  if(mousePressed) {
    if(mousePossition.dist(pumpkin.getLocation()) <= pumpkin.getDimension().y/2)
      tocado=true;
    else {
      tocado=false;
    }
    if(tocado)
      image(spritecursor.get(28, 0, 28, 31), pumpkin.getLocation().x - 14, pumpkin.getLocation().y - 15);
    else
      image(spritecursor.get(28, 0, 28, 31), mouseX - spritecursor.width/4, mouseY - spritecursor.height/2);
  }else {
    image(spritecursor.get(0,0,28,31), mouseX-spritecursor.width/4,mouseY-spritecursor.height/2);
    tocado=false;
  }
}


public void playMusic(){
  groove.loop();
}

public void pintarBaldosas(){
  for(k=0;k<cantB;k++)
    image(baldosa, posBaldosas[k].x, posBaldosas[k].y);
    for(u=0;u<cantM;u++)
      drawBody(monsters[u]);
}

public void controlCalabaza(){
  tint(255);
  mousePossition.x=mouseX;
  mousePossition.y=mouseY;
  if (pumpkin.alive){
    colisionando=false;
    if(!pumpkin.isOut(mundo)) {
      if(mousePressed){
        if(pumpkin.alive) {
          if(!sw) {
            if(mousePossition.dist(pumpkin.getLocation())<=pumpkin.getDimension().y/2){
              sw=true;
              mouseDistance.x=pumpkin.getLocation().x - mouseX;
              mouseDistance.y=pumpkin.getLocation().y - mouseY;
            }
          }else{
            if(!sw2 && mousePressed)
              pumpkin.setLocation(parseInt(mouseX+mouseDistance.x),parseInt(mouseY+mouseDistance.y));
          }
          drawBody(pumpkin);
        }
      }else {
        if(!pumpkin.alive)
          pumpkin.alive=true; 
        sw=false;
        sw2=false;
        pumpkin.setImage(loadImage("character/calabaza.png"));
        drawBody(pumpkin);
      }
    }else {
      if(!pumpkin.isFinish(mundo)) {
        pumpkin.alive=false;
        pumpkin.setImage(loadImage("character/calabaza1.png"));
        groove2.play();
      }else{
        sw=false;
        pumpkin.alive = true;
        if (mundoAct<12){
          loadLevel ("backgrounds/fondoMundo.jpg","levels/mundo"+mundoAct+".txt");  
          mundoAct++;  
        }else
          pantalla=3;
      }
    }
  }else {
    sw2=false;
    animacion();
  }
}

public void animacion() {
  if(ani<5)
   image(animacion.get(0,0,164,174), pumpkin.locationX()-95, pumpkin.locationY()-100);
  else if (ani<10)
      image(animacion.get(168,0,164,174), pumpkin.locationX()-95, pumpkin.locationY()-100);
    else if (ani<15)
        image(animacion.get(336,0,164,174), pumpkin.locationX()-95, pumpkin.locationY()-100);
      else if (ani<20)
            image(animacion.get(504,0,164,174), pumpkin.locationX()-95, pumpkin.locationY()-100);
          else if (ani<25)
               image(animacion.get(672,0,162,174), pumpkin.locationX()-95, pumpkin.locationY()-100);
            else if (ani<30){
                image(animacion.get(840,0,168,174), pumpkin.locationX()-95, pumpkin.locationY()-100);
                ani =-1;
                pumpkin.setLocation(pumpkin.getxInicial(),pumpkin.getyInicial());
                pumpkin.alive = true;
                sw2=true;
                tocado=false;
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
        pumpkin = new character(j*80+39,i*75+39,calabazaImage,0);
      mundo[i][j]=parseInt(posiciones[j]);
    }
  }
  
  //Guardar las posiciones de las baldosas y los Monsters en una Matriz
  posBaldosas= new PVector[cantB];
  monsters = new monster[cantM];
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
        monsters[u] = new monster("monsters/momia.png", j*80+33, i*75+33, (int)random(3));
        u++;
      }
      if (posiciones[j].compareTo("6")==0){
        monsters[u] = new monster("monsters/lobo.png", j*80+33, i*75+33, (int)random(3));
        u++;
      }
      if (posiciones[j].compareTo("7")==0){
        monsters[u] = new monster("monsters/calabera.png", j*80+33, i*75+33, (int)random(3));
        u++;
      }
      if (posiciones[j].compareTo("3")==0){
        monsters[u] = new monster("monsters/bruja.png", j*80+33, i*75+33, (int)random(3));
        u++;
      }
      if (posiciones[j].compareTo("10")==0){
        monsters[u] = new monster("monsters/calabera.png", j*80+33, i*75+33, 3);
        monsters[u].setDistanciaSt(22);
        //monsters[u].set(4);
        u++;
      }
    }
  }
}
    
public void drawBody(character b){
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

public void drawBody(monster b) {
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
      //--animaciòn de colision--//
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
      
      //--Colision--//
      if (dist(b.getX()+10,b.getY(), pumpkin.locationX(),pumpkin.locationY())<60 && pumpkin.alive){
        pumpkin.alive=false;
        if(!colisionando) {
          groove2.play();
        }
        pumpkin.setImage(loadImage("character/calabaza1.png"));
        colisionando =true;
        //sw2=false;
        //pumpkin.setLocation(pumpkin.getxInicial(),pumpkin.getyInicial());
      }           
      break;
  }
  popMatrix();
}

void stop() {
  groove.stop();
  groove2.stop();
 
  super.stop();
}

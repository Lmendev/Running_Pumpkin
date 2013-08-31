import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Running_Pumpkin extends PApplet {

/*--Desarrolladores--//
Running_Pumpkin un proyecto iniciado por:
Luis Antonio Mendoza Marriaga   @lmendoza92
Adriana Gallon                  @apgallon
Angelica Acosta                 @A_N_S_H_Y
*/

//--Librerias--//
  //Libreria de audio

//--Declaraci\u00f3n de variables--//
Minim minim;
AudioPlayer groove;
PImage fondoInicio; 
PImage jugar1, jugar2, creditos1, creditos2;
PImage spritecursor;
int pantalla=0, mundoAct=7;
PImage creditos, back, back1;
PImage win;
Minim minim2;
AudioSample groove2; 
character pumpkin;
PImage fondoMundo;
PImage baldosa;
PImage calabazaImage;
PImage brujaImage, momiaImage, loboImage, calaberaImage;
PImage animacion;
PImage imagen;
String[] lines, posiciones;
PVector[] posBaldosas;
PVector mousePossition = new PVector(mouseX,mouseY);
PVector mouseDistance = new PVector(0,0);
int k, u, cantB,cantM;
int [][] mundo= new int[8][13];
monster[] monsters;
boolean sw=false;
boolean colisionando=false,tocado=false;
int ani = 0, nextScreen=0;
boolean sw2=false, mouseOver=false;
button jugarButton, creditosButton, backButton;

public void setup () {
  size(960, 600, P3D);   // Tama\u00f1o ventana 960x 600
  noCursor();            // Ocultar cursor
  
  loadSounds();      // Cargar sonido
  loadCharacter();   // Cargar personaje
  loadCursor();      // Cargar cursor
  loadAnimations();  // Cargar animaciones
  loadButtons();     // Cargar botones
  loadBackgrounds(); // Cargar imagenes de fondo
  loadMonsters();    // Cargar monstruos
  loadTiles();       // Cargar baldosas
  
  loadLevel("backgrounds/fondoMundo.jpg", "levels/mundo1.txt");  // Cargar nivel 1
  
  playMusic(); // Ejecutar musica de fondo
}

public void draw(){
  
  switch(pantalla){
    case 0:  //--Pantalla de inicio--//
      image(fondoInicio, 0, 0);  // Pintar imagen de fondo
      drawButton(jugarButton, false);        // Pintar boton jugar
      drawButton(creditosButton, true);     // Pintar boton creditos
    break;  //--Final pantalla de inicio--//
       
    case 1:  //--Pantalla de juego--//
      image(fondoMundo, 0, 0);  // Pintar imagen de fondo
      drawButton(backButton, true);   // Pintar boton regresar
      pintarBaldosas();         // Pintar baldosas del nivel   
      controlCalabaza();        // Controlador de calabaza
    break; //--Final pantalla de juego--//
      
    case 2:  //--Pantalla creditos--//
      image(creditos, 0, 0);  // Pintar imagen de fondo
      drawButton(backButton, true); // Pintar boton regresar
  
    break; //--Final pantalla creditos--//
    
    case 3:  //--Pantalla juego terminado--//
      image(win, 0, 0);         // Pintar imagen de fondo
      //drawButton(back, back1, 880, 10, 0);    // Pintar boton regresar
      mundoAct=1;
    break;  //--Final pantalla juego terminado--//   
  }
  
  controlAnimacionMouse(); //Controlador de animaciones del mouse
}


public class button {

  //--Atributos--//
  private PImage defaultImage=null;
  private PImage overImage=null;
  private int posX=0, posY=0;
  private int limitX=0, limitY=0;
  private int nextScreen=0;
  private int width=0, height=0;
  private boolean target=false;
  
  //--Contructor--//
  public button(String defaultUrl, String overUrl, int posX, int posY, int nextScreen){
    this.defaultImage = loadImage(defaultUrl);
    this.overImage = loadImage(overUrl);
    this.width = this.defaultImage.width;
    this.height = this.defaultImage.height;
    this.posX = posX; this.posY = posY;
    this.limitX = this.posX + this.width;
    this.limitY = this.posY + this.height;
    this.nextScreen = nextScreen;  
  }
  
  //--Metodos--//
  public int getPosX(){
    return this.posX;
  }
  
  public int getPosY(){
    return this.posY;
  }
  
  public int getLimitX(){
    return this.limitX;
  }
  
  public int getLimitY(){
    return this.limitY;
  }
  
  public PImage getDefaultImage() {
    return this.defaultImage;
  }
  
  public PImage getOverImage() {
    return this.overImage;
  }
  
  public int getNextScreen(){
    return this.nextScreen;
  }
  
  public boolean getTarget(){
    return this.target;
  }
  
  public void setTarget(boolean target){
    this.target = target;
  }
}

public class character {

  private PVector location;
  private PVector dimension; 
  private PVector scale; //x= xFactor, y=yFactor
  private float rotation;
  private boolean alive;
  private PImage imageTexture;
  private int stamina;
  private int xInicial;
  private int yInicial;
  
public character(int x, int y, PImage texture,int stamina) {
  location = new PVector(x,y);
  xInicial =x;
  yInicial=y;
  rotation = 0; 
  alive = true;
  imageTexture = texture.get();
  dimension = new PVector(texture.width,texture.height);
  stamina  = 0;
}
  
public PVector getLocation(){
    return location;
  }
  public void setLocation(int x ,int y){
    location.x=x;
    location.y=y;
  }
  
public  PVector getDimension(){
    return dimension;
  }
public  float getRotation(){
    return rotation;
  }
public  void setRotation(float r){
    rotation = r;
  }
public  boolean isAlive(){
    return alive;
  }
public void die(){
    alive=false;
  }
  public void live(){
    alive=true;
  }
public  int getStamina(){
    return stamina;
  }
public  void setStamina(int s){
    stamina = s;
  }
public  void setImage(PImage Image){
    imageTexture = Image;
    dimension.x= imageTexture.width;
    dimension.y= imageTexture.height;
  }
public  void setScale(float w, float h){
    scale.x=w;
    scale.y=h;
  }
public  PVector getScale(){
    return scale;
  }
  public PVector getVertex(int i){
    float x=0, y=0;
    switch(i){
      case 0:
        x=location.x-(dimension.x/2);
	y=location.y-(dimension.y/2);
	break;

      case 1:
	x=location.x+(dimension.x/2);
	y=location.y-(dimension.y/2);
        break;
      
      case 2:
        x=location.x+(dimension.x/2);
        y=location.y+(dimension.y/2);
	break;

      case 3:
	x=location.x-(dimension.x/2);
	y=location.y+(dimension.y/2);
	break;
    }
    
    float  nx=location.x+(x-location.x)*PApplet.cos(rotation)-(y-location.y)*PApplet.sin(rotation);
    float ny=location.y+(x-location.x)*PApplet.sin(rotation)+(y-location.y)*PApplet.cos(rotation);
    return new PVector(nx,ny);
  }
  public PVector getInterval(PVector axis){
    float val= axis.dot(getVertex(0));
    PVector minmax= new PVector(val,val);
    for (int i=1;i<=3;i++){
      val= axis.dot(getVertex(i));
      minmax.x=PApplet.min(minmax.x,val);
      minmax.y=PApplet.max(minmax.y,val);
    }
    return minmax;
  }
  
  public PVector getFaceDir(int i){
    PVector face= new PVector();
    PVector v0 =new PVector();;
    PVector v1= new PVector();
    switch(i){
      case 0:
        v0= getVertex(0);
        v1= getVertex(1);
	break;
      case 1:
        v0= getVertex(1);
	v1= getVertex(2);
	break;
      case 2:
	v0= getVertex(2);
	v1= getVertex(3);
	break;
      case 3: 
	v0= getVertex(3);
	v1= getVertex(0);
	break;
    }
    face.x=v1.x-v0.x;
    face.y=v1.y-v0.y;
    return face;
  }
  public boolean intersects(character b){
    PVector minmax1=new PVector(0,0);
    PVector minmax2=new PVector(0,0);
    boolean coll=true;
    for (int i =0; i<4; i++){
      minmax1=getInterval(getFaceDir(i));
      minmax2= b.getInterval(getFaceDir(i));
      if(minmax1.y<minmax2.x || minmax2.y<minmax1.x ){
        coll= false;
      }
    }
    if(coll){
      for(int i=0;i<4;i++){
        minmax1=getInterval(b.getFaceDir(i));
        minmax2=b.getInterval(b.getFaceDir(i));
        if(minmax1.y<minmax2.x||minmax2.y<minmax1.x){
          coll=false;
        }
      } 
    }
    return coll;
  }
  public PVector[] celda(){
    PVector[] nloc= new PVector[4] ;
    nloc[0]=new PVector(PApplet.parseInt(location.x/80),PApplet.parseInt((location.y-(this.imageTexture.height/2)+3)/75));
    nloc[1]=new PVector (PApplet.parseInt((location.x+(this.imageTexture.width/2)-3)/80),PApplet.parseInt(location.y/75));
    nloc[2]=new PVector(PApplet.parseInt(location.x/80),PApplet.parseInt((location.y+(this.imageTexture.height/2)-3)/75));
    nloc[3]=new PVector(PApplet.parseInt((location.x-(this.imageTexture.width/2)+3)/80),PApplet.parseInt(location.y/75));
    return nloc;
  }
  public boolean isOut(int[][] mat){
    for(int i=0;i<celda().length;i++){
      if(mat[PApplet.parseInt(celda()[i].y)][PApplet.parseInt(celda()[i].x)]!=1 && mat[PApplet.parseInt(celda()[i].y)][PApplet.parseInt(celda()[i].x)]!=2)
        return true;
      }
    return false;
  }
  public boolean isFinish(int[][] mat){
    for(int i=0;i<celda().length;i++){
      if(mat[PApplet.parseInt(celda()[i].y)][PApplet.parseInt(celda()[i].x)]==3)
        return true;
    }
    return false;
  }
  public int getxInicial(){
    return this.xInicial;
  }
  public int getyInicial(){
    return this.yInicial;        
  }
  public float locationX(){
    return location.x;
  }
  public float locationY(){
    return location.y;
  }
}

//--Librer\u00eda Running Pumpkin--//
/*Fecha de creaci\u00f3n: 24/08/2013 */


//--Cargar imagenes--//

public void loadAnimations(){
  //--Cargar imagenes animaciones--//
  animacion = loadImage("animations/animacion.png");  // Cargar imagen animaci\u00f3n muerte 
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
  minim2 = new Minim(this);
  minim = new Minim(this);
  
  groove = minim.loadFile("sounds/musicaInicio.mp3");  // Cargar musica de fondo
  groove2 = minim.loadSample("sounds/scream3.mp3");  // Cargar sonido scream;  
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
      boton.setTarget(false);  // Desactivar seleccion de bot\u00f3n
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
      boton.setTarget(false); // Desactivar seleccion de bot\u00f3n
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
          if(!sw){
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
      }else{
        if(!pumpkin.alive)
          pumpkin.alive=true; 
          sw=false;
          sw2=false;
          pumpkin.setImage(loadImage("character/calabaza.png"));
          drawBody(pumpkin);
      }
    }else{
      if(!pumpkin.isFinish(mundo)){
        pumpkin.alive=false;
        pumpkin.setImage(loadImage("character/calabaza1.png"));
        groove2.trigger();
        //pumpkin.setLocation(pumpkin.getxInicial(),pumpkin.getyInicial());
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
  }else{
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
      if(b.getScaleY()>(1.3f)|| b.getScaleY()<1)
        b.changeSt();
      b.setScaleY(b.getScaleY()+(0.03f*b.getSt()));
      break;
    
    case 3:// Animacion 4
      //--animaci\u00f2n de colision--//
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
      if (dist(b.getX()+10,b.getY(), pumpkin.locationX(),pumpkin.locationY())<60){
        pumpkin.alive=false;
        if(!colisionando) {
          groove2.trigger();
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

public void stop()
{
  // always close Minim audio classes when you are done with them
  groove.close();
  groove2.close();
  minim.stop();
 
  super.stop();
}

public class monster {

  //--Atributos--//
  private PImage imagen;
  private int x, y;
  private int st;
  private float theta;
  private int distancia;
  private float tiempo;
  private int distanciaAct;
  private float tiempoAct;
  private int animacion;
  private float scaleX=0,scaleY=1;
  
  //--Constructor--//
  public monster(String imagen, int x, int y, int animacion){
    this.imagen = loadImage(imagen);
    this.x = x; this.y = y;
    this.st=1;
    this.theta = 0;
    this.distancia=6;
    this.tiempo = 2;
    this.distanciaAct=(int) random(6);
    this.tiempoAct= (float) random(3);
    this.animacion= animacion;
  }  
  
  //M\u00e9todos
  public PImage getImage(){
    return this.imagen; 
  }
  public int getX(){
    return this.x;
  }
  public int getY(){
    return this.y;
  }
  public void setX(int x){
    this.x = x;
  }
  public void setY(int y){
    this.y = y;
  }
  public float getTheta(){
    return this.theta;
  }
  public int getAnimacion(){
    return this.animacion;
  }
  public int getSt(){
    return this.st;
  }
  public void setTheta(float theta){
    this.theta = theta;
  }
  public void changeSt(){
    this.st = this.st*-1;
  }
  public void setDistanciaSt(int distancia){
    this.distancia = distancia;
  }
  public void setTiempo(float tiempo){
    this.tiempo = tiempo;
  }
  public int getDistancia(){
    return this.distancia;
  }
  public float getTiempo(){
    return this.tiempo;
  }
  public void setTiempoAct(float tiempo){
    this.tiempoAct = tiempo;
  }
  public void setDistanciaAct(int distancia){
    this.distanciaAct = distancia;
  }
  public int getDistanciaAct(){
    return this.distanciaAct;
  }
  public float getTiempoAct(){
    return this.tiempoAct;
  }
  public void setScaleY(float f){
    this.scaleY=f;
  }
    public float getScaleY(){
  return this.scaleY;
  }  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Running_Pumpkin" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

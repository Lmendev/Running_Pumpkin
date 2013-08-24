/*--Desarrolladores--//
Luis Antonio Mendoza Mariaga   @lmendoza92
Adriana Gallon                 @apgallon

*/


import ddf.minim.*;

//Declaración de variables
 Minim minim;
 AudioPlayer groove;
 PImage fondoInicio; 
 PImage jugar1, jugar2, creditos1, creditos2;
 PImage cursor1,cursor2;
 int pantalla=0, mundoAct=7;


 PImage creditos, back, back1;

 PImage win;



Minim minim2;
AudioPlayer groove2;
 Body usuario2;
PImage fondoMundo, baldosa, calabaza, bruja, momia, lobo, calabera;
PImage A1,A2,A3,A4,A5,A6;
PImage imagen;
String[] lines, posiciones;
PVector[] posBaldosas;
int k, u, cantB,cantM;
 int [][] mundo;
Monster[] monsters;
 boolean sw=false;
int ani =0;
boolean sw2=false;


public void setup () {
  size(960, 600, P3D);
  noCursor();
  
 
  minim2 = new Minim(this);
  groove2 = minim2.loadFile("sounds/scream3.mp3");
  

  //Calabaza
  imagen = loadImage("character/calabaza.png");
  mundo= new int[8][13];
  
  
  //--Cargar imagenes de pantalla inicio--//
  fondoInicio = loadImage("backgrounds/inicio.jpg"); // Imagen de fondo
  jugar1 = loadImage("buttons/jugar1.png");          // Boton jugar
  jugar2 = loadImage("buttons/jugar2.png");
  creditos1 = loadImage("buttons/creditos1.png");    // Boton creditos
  creditos2 = loadImage("buttons/creditos2.png");
  
  //--Cargar imagenes de cursor--//
  cursor1 = loadImage("cursor/cursor.png");
  cursor2 = loadImage("cursor/cursorpress.png");
    
  // Recursos globales
  baldosa = loadImage("tiles/tile.jpg");
  calabaza = loadImage("character/calabaza.png");
  bruja = loadImage("monsters/bruja.png");
  momia = loadImage("monsters/momia.png");
  lobo = loadImage("monsters/lobo.png");
  calabera = loadImage("monsters/calabera.png");
  fondoMundo = loadImage("backgrounds/fondoMundo.jpg");
  
  back = loadImage("buttons/back.png");
  back1 = loadImage("buttons/back1.png");
  A1 = loadImage("animations/A1.png");
  A2 = loadImage("animations/A2.png");
  A3 = loadImage("animations/A3.png");
  A4 = loadImage("animations/A4.png");
  A5 =  loadImage("animations/A5.png");
  A6 = loadImage("animations/A6.png");
  
  //Creditos
  
    
  cargarMundo("backgrounds/fondoMundo.jpg","levels/mundo1.txt"); 
 

  creditos= loadImage("backgrounds/fondoCreditos.png");
  back = loadImage("buttons/back.png");
  back1 = loadImage("buttons/back1.png");
  
  
  win=loadImage("backgrounds/Win1.png");
  
  
  playMusic(); // Ejecutar musica de fondo
}
  
  
public void draw(){
  
  switch(pantalla){
    case 0:  //--Pantalla de inicio--//
      image(fondoInicio, 0, 0);  // Pintar imagen de fondo
      pintarBotonJugar();        // Pintar boton jugar
      pintarBotonCreditos();     // Pintar boton creditos
    break;  //--Final pantalla de inicio--//
       
    case 1:  //--Pantalla de juego--//
      image(fondoMundo, 0, 0);  // Pintar imagen de fondo
      pintarBotonRegresar3();   // Pintar boton regresar
      pintarBaldosas();         // Pintar baldosas del nivel   
      controlCalabaza();        // Controlador de calabaza
    break; //--Final pantalla de juego--//
      
    case 2:  //--Pantalla creditos--//
      image(creditos, 0, 0);  // Pintar imagen de fondo
      pintarBotonRegresar2(); // Pintar boton regresar
    break; //--Final pantalla creditos--//
    
    case 3:  //--Pantalla juego terminado--//
      image(win, 0, 0);         // Pintar imagen de fondo
      pintarBotonRegresar();    // Pintar boton regresar
    break;  //--Final pantalla juego terminado--//   
  }
  
  controlAnimacionMouse(); //Controlador de animaciones del mouse
}


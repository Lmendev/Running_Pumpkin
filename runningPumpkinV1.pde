/*--Desarrolladores--//
Luis Antonio Mendoza Marriaga   @lmendoza92
Adriana Gallon                  @apgallon
*/

//--Librerias--//
import ddf.minim.*;  //Libreria de audio

//--Declaración de variables--//
Minim minim;
AudioPlayer groove;
PImage fondoInicio; 
PImage jugar1, jugar2, creditos1, creditos2;
PImage spritecursor;
int pantalla=0, mundoAct=7;
PImage creditos, back, back1;
PImage win;
Minim minim2;
AudioPlayer groove2; 
Body usuario2;
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
Monster[] monsters;
boolean sw=false;
boolean colisionando=false,tocado=false;
int ani = 0;
boolean sw2=false;

public void setup () {
  size(960, 600, P3D);   // Tamaño ventana 960x 600
  //noCursor();            // Ocultar cursor
  
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


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

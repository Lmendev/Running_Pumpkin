class Monster {
  //Variables
  private PImage imagen;
  private int x;
  private int y;
  private int st;
  private float theta;
  private int distancia;
  private float tiempo;
  private int distanciaAct;
  private float tiempoAct;
  private int animacion;
  private float scaleX=0,scaleY=1;
  
  //Constructor
  public Monster(String imagen, int x, int y, int animacion){
    this.imagen = loadImage(imagen);
    this.x = x;
    this.y = y;
    this.st=1;
    this.theta = 0;
    this.distancia=6;
    this.tiempo = 2;
    this.distanciaAct=(int) random(6);
    this.tiempoAct= (float) random(3);
    this.animacion= animacion;
  }  
  
  //Métodos
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

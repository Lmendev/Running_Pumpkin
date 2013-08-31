
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
  void setLocation(int x ,int y){
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
  void live(){
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

class Dot{
  float x,y;
  float vel;
  int note;
  float dur;
  color c;
  boolean isFinished;
  int[][] note2color = { {255,0,0}, {144,0,255}, {255,255,0}, {183,70,139}, {195,242,255}, {171,0,52}, {127,139,253}, {255,127,0}, {187,117,252}, {51,204,51}, {169,103,124}, {142,201,255}}; 
  float[] note2hue = {0,29.88,60,120,193,208.67,234.29,273.88,271.11,323.36,340.91,341.75};
  float[][] note2angle = { {cos(PI/2),sin(PI/2),PI/2}, {cos(4*PI/3),sin(4*PI/3),4*PI/3}, {cos(PI/6),sin(PI/6),PI/6}, {cos(PI),sin(PI),PI}, {cos(11*PI/6),sin(11*PI/6),11*PI/6}, {cos(2*PI/3),sin(2*PI/3),2*PI/3}, {cos(3*PI/2),sin(3*PI/2),3*PI/2}, {cos(PI/3),sin(PI/3),PI/3}, {cos(7*PI/6),sin(7*PI/6),7*PI/6}, {cos(0),sin(0),0}, {cos(5*PI/6),sin(5*PI/6),5*PI/6}, {cos(5*PI/3),sin(5*PI/3),5*PI/3} }; 

public Dot(float x, float y,float vel, int note){
    this.x = x;
    this.y = y;
    this.c = color(note2color[note%12][0],note2color[note%12][1],note2color[note%12][2]);
    this.vel = vel ;
    this.note = note;
    this.dur = 0;
    this.isFinished = false;
  }
  
  
  // ---- Methods
  public void plot(float size, color c){
    noStroke();
    fill(c,128);
    ellipse(x,y,size,size);
  }
  
  public void plot(){
    noStroke();
    
    fill(this.c,map(this.vel, 0, 255, 30, 230));
    ellipse(this.x,this.y,this.grow(),this.grow());
  }
  
  public void move(float newX, float newY){
    x = newX; 
    y = newY;
  }
  

  
  public float grow(){ 
    return dur=dur+0.5*vel/255;
  
  }
}

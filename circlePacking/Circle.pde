class Circle{
  float x;
  float y;
  float r;
  float s;
  float sW = 1;
  float maxDist;
  float oX;
  float oY;
  
  boolean growing = true;
  
  Circle(float x_, float y_,float r_,float s_,float oX_, float oY_){
    s=s_;
    x=x_;
    y=y_;
    oX= oX_;
    oY = oY_;
    
    r= r_; 
  }

  void show(){
    stroke(255);
    strokeWeight(sW);
    noStroke();
    fill(0);
    ellipse(x*s+oX,y*s+oY, r*2*s-(sW*s),r*2*s-(sW*s));
  }
  
}
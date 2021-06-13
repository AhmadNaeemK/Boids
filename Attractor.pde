class attractor{

  PVector pos;
  float attraction;
  
  public attractor(){
    this.pos = new PVector(0,0);
    this.attraction = random(0.01);
  }
  
  public attractor(PVector pos){
    this.pos = pos;
    this.attraction = random(0.03);
  }
  
  public void show(){
    
    noStroke();
    fill(0,255,0);
    ellipseMode(CENTER);
    ellipse(this.pos.x,this.pos.y,this.attraction * 500,this.attraction * 500);
    
  }
  
  
  
}

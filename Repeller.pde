class repeller{

  PVector pos;
  float repulsion;
  
  public repeller(){
    this.pos = new PVector(0,0);
    this.repulsion = random(0.01);
  }
  
  public repeller(PVector pos){
    this.pos = pos;
    this.repulsion = random(0.03);
  }
  
  public void show(){
    
    noStroke();
    fill(255,0,0);
    ellipseMode(CENTER);
    ellipse(this.pos.x,this.pos.y,this.repulsion * 500,this.repulsion * 500);
    
  }
  
  
  
}

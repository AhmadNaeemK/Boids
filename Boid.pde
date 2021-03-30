class boid{
  
  PVector pos;
  PVector direction;
  
  int tHeight = 20;
  int tWidth = 10;
  
  //constructors
  public boid(){
    this.pos = new PVector(0,0);
    this.direction = new PVector(random(-1,1),random(-1,1)); // assigns random direction
  }
  
  public boid(PVector pos){
    this.pos = pos;
    this.direction = new PVector(random(-1,1),random(-1,1)); // assigns random direction
  }
  
  //function to render
  void show(){
    ellipseMode(CENTER);
    float angle = this.direction.heading() + PI/2;
    
    fill(255,0,0);
    ellipse(this.pos.x ,this.pos.y + this.tHeight/2, this.tHeight/2, this.tHeight/2);
    pushMatrix();
    translate(this.pos.x ,this.pos.y + this.tHeight/2); //translate to the center of triangle
    rotate(angle); // to show the direction of movement
    
    noStroke();
    fill(255);
    triangle( 0, -this.tHeight/2,
              0 +this.tWidth/2,  0 +int(this.tHeight)/2,
              0 -this.tWidth/2,  0 +int(this.tHeight)/2
            );       
    popMatrix();
  }
  
  
  private int checkOutofBound(){ // check if the boid has reached the edge
    
    int temp = 0;
    if (this.pos.x < 0 || this.pos.x> width){
      temp = 1;
    } else if (this.pos.y < 0 || this.pos.y > height){
      temp = 2;
    }
    
    if ( (this.pos.x < 0 || this.pos.x> width) && (this.pos.y < 0 || this.pos.y > height)){
      temp = 3;
    }
   
    return temp;
  }
  
  private void onOutofBound(){
    int temp = this.checkOutofBound();
    
    switch (temp){
      case 0:
        return;
      case 1:
        this.direction.x *= -1;
        return;
      case 2:
        this.direction.y *= -1;
        return;
      case 3:
        this.direction.mult(-1);
        return;
    }
    
  }
  
  
  void update(){
  
    this.pos.add(this.direction);
    this.onOutofBound();
    
  }
}

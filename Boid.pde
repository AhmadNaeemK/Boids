class boid{
  
  PVector pos;
  PVector velocity;
  PVector acceleration;
  
  boolean highlight = false;
  
  int maxSpeed = 10;
  int minSpeed = 2;
  float acc = random(0,0.001);
  
  int tHeight = 20;
  int tWidth = 10;
  
  int viewRadius = 50;
  
  ArrayList<boid> neighbours;
  
  
  //constructors
  public boid(){
    this.pos = new PVector(0,0);
    this.velocity = new PVector(0,0); // assign 0 velocity
    this.acceleration = new PVector(random(-0.01,0.01),random(-0.01,0.01)); //assign random acceleration
  }
  
  public boid(PVector pos){
    this.pos = pos;
    this.velocity = new PVector(0,0); // assigns random velocity
    this.acceleration = PVector.random2D(); //unit vector with random direction
    this.acceleration.setMag( acc ) ;
  }
  
  //function to render
  void show(){
    ellipseMode(CENTER);
    float angle = this.velocity.heading() + PI/2;
   
    pushMatrix();
    translate(this.pos.x ,this.pos.y + this.tHeight/2); //translate to the center of triangle
    rotate(angle); // to show the velocity of movement
    
    noStroke();
    fill(255);
    triangle( 0, -this.tHeight/2,
              this.tWidth/2,  int(this.tHeight)/2,
             -this.tWidth/2,  int(this.tHeight)/2
            );       
    popMatrix();
    
    if (this.highlight){
      fill(255,0,0,50);
      ellipse(this.pos.x ,this.pos.y + this.tHeight/2, this.viewRadius*2, this.viewRadius*2);
      
      showNeighbours();
    }
    
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
        this.velocity.x *= -1;
        return;
      case 2:
        this.velocity.y *= -1;
        return;
      case 3:
        this.velocity.mult(-1);
        return;
    }
    
  }
  
  private void accelerate(){
    if (this.velocity.mag() < maxSpeed){
      this.velocity.add(this.acceleration);
      this.acceleration = new PVector(this.velocity.x, this.velocity.y); //copy velocity
      this.acceleration.setMag(acc);
    }
  }
  
  //get neighbours within certain radius
  void getNeighbours(ArrayList<boid> flock){
    this.neighbours = new ArrayList<boid> ();
    
    for (boid b : flock){
      if (b!= this && PVector.dist(b.pos,this.pos) < this.viewRadius){
        this.neighbours.add(b);
      }
    }
  }
  
  void showNeighbours(){
    if (this.neighbours.size() > 0){
  
      stroke(255,0,0);
      for (boid neighbour : this.neighbours){
        line(this.pos.x,this.pos.y + this.tHeight/2,
             neighbour.pos.x, neighbour.pos.y + neighbour.tHeight/2);
      }
      
    }
    
    
    
  }
  
  
  void update(){
    this.pos.add(this.velocity);
    this.accelerate();
    this.onOutofBound();
  }
}

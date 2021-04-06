class boid{
  
  PVector pos;
  PVector velocity;
  PVector acceleration;
  
  boolean highlight = false;
  
  float maxSpeed = 1;
  float acc = 0.01;
  
  int tHeight = 20;
  int tWidth = 10;
  
  int viewRadius = 10;

  float viewAngle = 3 * PI/2;
  
  float collisionRadius = 6;
  
  ArrayList<boid> neighbours;
  
  
  //constructors
  public boid(){
    this.pos = new PVector(0,0);
    this.velocity = PVector.random2D(); // assigns random velocity
    this.velocity.setMag(0.01);
    this.acceleration = new PVector(0,0);
  }
  
  public boid(PVector pos){
    this.pos = pos;
    this.velocity = PVector.random2D(); // assigns random velocity
    this.velocity.setMag(0.01);
    this.acceleration = PVector.random2D();
    this.acceleration.setMag(acc);
  }
  
  //function to render
  void show(){
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
    if (this.highlight){
      fill(255,0,0,50);
      float notVisibleAngle = 2 * PI - this.viewAngle;
      arc (0 ,0, this.viewRadius*2, this.viewRadius*2, notVisibleAngle/2 + PI/2, notVisibleAngle/2 + this.viewAngle +PI/2, PIE); // show view Area   
    }        
    popMatrix();
    
    if (this.highlight){
      showNeighbours();
    }
    
  }
  
  void showParticle(){
    noStroke();
    fill(255);
    ellipseMode(CENTER);
    ellipse(this.pos.x,this.pos.y,2,2);
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
  
  
  
  private void checkOutofBound(){ // check if the boid has reached the edge
    if (this.pos.x < 0) this.pos.x = width;
    else if (this.pos.x > width) this.pos.x = 0;
    
    if (this.pos.y < 0) this.pos.y = height;
    else if (this.pos.y > height) this.pos.y = 0;
  }
 
  
  //get neighbours within certain radius
  void getNeighbours(ArrayList<boid> flock){
    this.neighbours = new ArrayList<boid> (); 
    for (boid b : flock){
      PVector displacement = PVector.sub(b.pos,this.pos);
      if (b!= this && displacement.mag() <this.viewRadius && PVector.angleBetween(this.velocity, displacement)<=  this.viewAngle/2){
        this.neighbours.add(b);
      }
    }
  }
  
  //boid movement
  void alignment(){ //steer towards the average heading of local flockmates
    if (this.neighbours.size() > 0){
      PVector average = new PVector(0,0);
      for (boid b : this.neighbours){
        average.add(b.velocity);
      }
      average = average.div(this.neighbours.size());
      this.acceleration.add(PVector.sub(average,velocity));
      this.acceleration.limit(acc);
    } else return;
  }
  
  void cohesion(){ //steer to move toward the average position of local flockmates
    if (this.neighbours.size() > 0){
      PVector average = new PVector(0,0);
      for (boid b : this.neighbours){
        average.add(b.pos);
      }
      average = average.div(this.neighbours.size());
      this.acceleration.add(PVector.sub(average,pos));
      this.acceleration.limit(acc);
    } else return;
  }
  
  void seperation(){
    if (this.neighbours.size() > 0){
       PVector minDisplacement = PVector.sub(this.pos,this.neighbours.get(0).pos);
       for (int i=1; i < this.neighbours.size(); i++){
         PVector displacement = PVector.sub(this.pos,this.neighbours.get(i).pos);
         if (displacement.mag()< minDisplacement.mag()){
           minDisplacement = displacement;
         }
       }
       
       if (minDisplacement.mag() < this.collisionRadius){
           //int dir = floor(random(0,2)) -1;
           //minDisplacement.rotate(dir * PI/2);
           this.acceleration.add(minDisplacement);
           //this.acceleration.limit(acc);
       } else return;
      
    }  
  }

  void update(){
    this.pos.add(this.velocity);
    this.velocity.add(this.acceleration);
    this.velocity.limit(maxSpeed);
    this.alignment();
    this.cohesion();
    this.seperation();
    this.checkOutofBound();
  }
}

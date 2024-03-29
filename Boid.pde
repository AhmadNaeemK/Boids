class boid{
  
  PVector pos;
  PVector velocity;
  PVector acceleration;
  
  boolean highlight = false;
  
  float maxSpeed = 1;
  float acc = 0.05;
  
  int tHeight = 20;
  int tWidth = 10;
  
  int tHeight = 2;
  int tWidth = 1;
  
  int viewRadius = tHeight + 10;

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
    fill(0,0,255);
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
    fill(0);
    ellipseMode(CENTER);
    ellipse(this.pos.x,this.pos.y,this.tWidth,this.tWidth);
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
 
  //get nearest objects ---------------------------------------------------------------------------------------------
  
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
  
  //get nearest attractor
  attractor getFoodAttractor(ArrayList<attractor> food){
    float min_dist = width;
    attractor min_attractor = null;
    for (attractor a: food){
      PVector displacement = PVector.sub(a.pos,this.pos);
      if (displacement.mag()<min_dist && displacement.mag() <this.viewRadius && PVector.angleBetween(this.velocity, displacement)<=  this.viewAngle/2){
        min_attractor = a;
      }
    }
    return min_attractor;
  }
  
  //get nearest wall
  repeller getWallRepeller(ArrayList<repeller> walls){
    float min_dist = width;
    repeller min_repeller = null;
    for (repeller a: walls){
      PVector displacement = PVector.sub(a.pos,this.pos);
      if (displacement.mag()<min_dist && displacement.mag() <this.viewRadius && PVector.angleBetween(this.velocity, displacement)<=  this.viewAngle/2){
        min_repeller = a;
      }
    }
    return min_repeller;
  }
  
  //boid movement--------------------------------------------------------------------------
  
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
  
  //steer towards the food source
  void food_attraction(ArrayList<attractor> food){
    attractor nFood = getFoodAttractor(food); // nearest food
    if (nFood != null){
      this.acceleration.add(PVector.sub(nFood.pos,this.pos));
      this.acceleration.limit(nFood.attraction);
    } else return;
  }
  
  //steer away from wall
  void wall_repulsion(ArrayList<repeller> walls){
    repeller nWall = getWallRepeller(walls); // nearest Wall
    if (nWall != null){
      this.acceleration.add(PVector.sub(this.pos,nWall.pos));
      this.acceleration.limit(nWall.repulsion);
    } else return;
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

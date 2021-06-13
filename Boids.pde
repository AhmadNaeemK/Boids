
import java.util.ArrayList;

ArrayList<boid> boidArray;
ArrayList<attractor> foodArray;
ArrayList<repeller> wallArray;

void setup(){
  size(1280,560);
  background(255);
  
  boidArray = new ArrayList<boid>();
  foodArray = new ArrayList<attractor>();
  wallArray = new ArrayList<repeller>();
  int numBoids = 1000;
  int numAttractors = 100;
  int numWalls = 100;
  
  for (int i=0; i <numBoids; i++){
    boidArray.add(new boid(new PVector(random(width),random(height))));
    
    if  (i < numBoids/5)
    boidArray.get(i).highlight = true;
  }
  
  for (int i=0; i <numAttractors; i++){
    foodArray.add(new attractor(new PVector(random(width),random(height))));
  }
  
  for (int i=0; i <numWalls; i++){
    wallArray.add(new repeller(new PVector(random(width),random(height))));
  }
  
  
}

void draw(){
  background(255);
  
  for (boid i: boidArray){
    i.getNeighbours(boidArray);
  }
    
  for (boid i: boidArray){
    i.update();
    i.food_attraction(foodArray);
    i.wall_repulsion(wallArray);
    i.showParticle();
  }
  
  for (attractor i: foodArray){
    i.show();
  }
  
  for (repeller i: wallArray){
    i.show();
  }
}

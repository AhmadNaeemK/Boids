
import java.util.ArrayList;

ArrayList<boid> boidArray;

void setup(){
  size(1280,560);
  background(55);
  
  boidArray = new ArrayList<boid>();
  int numBoids = 5000;
  
  for (int i=0; i <numBoids; i++){
    boidArray.add(new boid(new PVector(random(width),random(height))));
  }
  
  boidArray.get(0).highlight = true;
  
  
  
}

void draw(){
  background(55);
  
  for (boid i: boidArray){
    i.getNeighbours(boidArray);
  }
  
  for (boid i: boidArray){
    i.update();
    i.showParticle();
  }
}


import java.util.ArrayList;

ArrayList<boid> boidArray;

void setup(){
  size(1280,560);
  background(55);
  
  boidArray = new ArrayList<boid>();
  int numBoids = 100;
  
  for (int i=0; i <numBoids; i++){
    boidArray.add(new boid(new PVector(width/2,height/2) ));
  }
  
  boidArray.get(0).highlight = true;
  
  
  
}

void draw(){
  background(55);
  
  for (boid i: boidArray){
    i.getNeighbours(boidArray);
    i.update();
    i.show();
  }
}

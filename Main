// Declare an ArrayList of Animal objects.
ArrayList<Animal> animals;
Vehicle predator;
FlockCenter center;
PImage bg;

void setup() {
  // Initialize and fill the ArrayList
  // with a bunch of animals.
  size(800,800);
  float x = random(500,width);
  float y = random(300,height);
  predator = new Vehicle(x-300,y-200);
  animals = new ArrayList<Animal>();
  center = new FlockCenter(x,y, predator);
  for (int i = 0; i < 15; i++) {
    animals.add(new Animal(x,y, predator, center.location));
  }
  bg = loadImage("oceanbackground.jpg");
  bg.resize(800, 800);
  
}

void draw() {
  cursor(CROSS);
  background(bg);
  for (Animal v : animals) {
    v.applyBehaviors(animals, predator);
    v.update(center.location);
    v.display();
  }
  predator.seek(center.location);
  predator.update();
  predator.display();
  center.applyBehaviors(predator);
  center.update();
  //center.display();
  predatorKill();
}

void predatorKill() {
  for (int i = 0; i < animals.size(); i++) {
    float dist = PVector.dist(predator.location,animals.get(i).location);
    if (abs(dist) < 110) { // if shark gets too close, the fish gets eaten!
      //print("yum");
      animals.remove(i);
    }
  }
}
    
void mouseClicked() { 
  // spawns new animal
  //saveFrame("screenshot3.jpg");
  animals.add(new Animal(center.location.x,center.location.y, predator, center.location));
}

class Vehicle {
  PImage img;
  PVector location;
  PVector velocity;
  PVector acceleration;
  // Additional variable for size
  float r;
  float maxforce;
  float maxspeed;

  Vehicle(float x, float y) {
    img = loadImage("shark2.png");
    img.resize(125,0);
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    location = new PVector(x,y);
    r = 10.0;
    maxspeed = 0.518; // .53
    maxforce = 0.11;
    //[end]
  }

  
  void update() {
    //checkEdges();
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    //acceleration.mult(0);
  }

  
  void applyForce(PVector force) {
    //acceleration.add(force);
    acceleration = force;
  }

  
  void seek(PVector target) {
    PVector desired = PVector.sub(target,location);
    float d = desired.mag();
    desired.normalize();
    // If we are closer than 100 pixels...
    if (d < 100) {
      float m = map(d,0,100,0,maxspeed);
      desired.mult(m);
      //[end]
    } else {
      // Otherwise, proceed at maximum speed.
      desired.mult(maxspeed);
    }

    // The usual steering = desired - velocity
    PVector steer = PVector.sub(desired,velocity);
    //PVector offset = new PVector(random(-1,1), random(-1,1));
    //steer.add(offset);
    steer.limit(maxforce);
    applyForce(steer);
  }
  
  void separate(ArrayList<Vehicle> vehicles) {
    float desiredseparation = r*2; //[bold]
    PVector sum = new PVector();
    int count = 0;
    for (Vehicle other : vehicles) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < desiredseparation)) {
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);  //[bold]
        sum.add(diff);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }
  }
  void checkEdges() {
    if(location.x>width) {
      location.x = 0;
    }
    else if (location.x < 0) {
      location.x = width;
    }
    if(location.y>height) {
      location.y = 0;
    }
    else if (location.y < 0) {
      location.y = height;
    }
  }
  
  float wrap(float location, float limit) {
    if (location%limit < 0) {
      return limit + location%limit;
    }
    return location%limit;
  }

  void display() {
    //Display Predator
    //float theta = velocity.heading() + PI/2;
    float theta = velocity.heading() - PI/12;
    //fill(120);
    stroke(0);
    pushMatrix();
    translate(wrap(location.x, width),wrap(location.y,height));
    rotate(theta);
    //beginShape();
    //vertex(0, -r*2);
    //vertex(-r, r*2);
    //vertex(r, r*2);
    //endShape(CLOSE);
    image(img, 0, 0);
    popMatrix();
  }
}

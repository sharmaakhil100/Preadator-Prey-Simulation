class Animal{
  PVector location;
  PVector velocity;
  PVector acceleration;
  PImage img;
  PVector target;
  float radius;
  color c;
  float degree;
  float rotateSpeed;
  float vLimit;
  float aFactor = .002;
  boolean avoid; 
  Vehicle threat;
  
  
  
  Animal(float x, float y, Vehicle threat, PVector targ) {
     target = targ;
     img = loadImage("fish5.png");
     img.resize(25,0);
     radius = 5;
     vLimit = 1;
     this.threat = threat;
     degree = random(360);
     location = new PVector(x,y);
     velocity = new PVector(random(-2,2),random(-2,2));
     acceleration = new PVector(random(-aFactor,aFactor),random(-aFactor,aFactor));
     rotateSpeed = (random(-10,10));
     c = color(random(100),random(100),random(100));
     avoid = false;
  }
  
  void update(PVector targ) {
     this.target = targ;
     //checkEdges();
     dangerSensor(threat.location);
     keyPressed();
     velocity.add(acceleration);
     velocity.limit(vLimit);
     location.add(velocity);
     //spin();
  }
  
  void display() {
    //fill(c);
    noFill();
    pushMatrix();
    float newX = wrap(location.x, width);
    float newY = wrap(location.y, height);
    translate(newX,newY);
    //rotate(radians(degree));
    //ellipse(0,0,radius*2,radius*2);
    float theta = velocity.heading();
    rotate(theta);
    image(img,0,0);
    popMatrix();
  }
  
  float wrap(float location, float limit) {
    if (location%limit < 0) {
      return limit + location%limit;
    }
    return location%limit;
  }
  
  void dangerSensor(PVector threat) {
    float d = PVector.dist(threat, location);
    if (d < 40) {
      avoid = true;
      c = color(255,0,0);
    }
    else if (d < 200) {
      avoid = false;
      c = color(0,0,255);
    }
    else {
      avoid = false;
      c = color(0,255,0);
    }
  }
  
  PVector avoid(PVector target) {
    PVector desired = PVector.sub(target,location);
    desired.mult(-1); // for fleeing behavior
    desired.normalize();
    desired.mult(vLimit);
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(0.1);
    return steer;
  }
  
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,location);
    desired.normalize();
    desired.mult(vLimit);
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(0.1);
    return steer;
  }
  
  void applyForce(PVector force) {
    //acceleration.add(force);
    acceleration = force;
  }
  
  void spin() {
    degree = (degree+rotateSpeed)%360;
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
  
  
  void applyBehaviors(ArrayList<Animal> animals, Vehicle predator) {
    PVector separateForce = separate(animals);
    PVector seekForce = seek(target);
    PVector average = new PVector(0,0);
    separateForce.mult(0.5);
    seekForce.mult(0.5);
    average = PVector.add(separateForce,seekForce);
    if (avoid) {
      average =  PVector.add(average,avoid(predator.location).mult(5.0));
      average.mult(1/3);
      //target = new PVector(random(width), random(height));
    }
    else {
      average.mult(0.5);
      //average = new PVector(0,0);
    }
    applyForce(average);
  }
  
  PVector separate(ArrayList<Animal> animals) {
    float desiredseparation = radius*6; //[bold]
    PVector sum = new PVector();
    int count = 0;
    for (Animal other : animals) {
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
      sum.mult(vLimit);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(0.1);
      return steer;
    }
    else { 
      return new PVector(0,0);
    }
  }
  
  
  void keyPressed() {
    if (keyPressed == true) {
      if (key == CODED) {
        if (keyCode == UP) {
          vLimit *= 1.2;
        } 
        if (keyCode == DOWN) {
          vLimit = vLimit * .8;
        } 
        if (keyCode == RIGHT) {
          acceleration.mult(1.05);
        } 
      }
    }
  }
  
  
  
}

class FlockCenter{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float radius;
  color c;
  float degree;
  float vLimit;
  float aFactor = .010;
  boolean avoid; 
  Vehicle threat;
  color cd = color(0,0,0);
  PVector center;
  
  FlockCenter(float x, float y, Vehicle threat) {
     center = new PVector(x,y);
     radius = 10;
     vLimit = 0.5;
     this.threat = threat;
     location = new PVector(x,y);
     velocity = new PVector(0,0);
     acceleration = new PVector(0,0);
     avoid = false;
  }
  
  void update() {
     step();
     //checkEdges();
     dangerSensor(threat.location);
     keyPressed();
     velocity.add(acceleration);
     velocity.limit(vLimit);
     location.add(velocity);
    
  }
  
  void display() {
    fill(cd);
    ellipse(wrap(location.x,width), wrap(location.y,height), 10,10);
  }
  
  float wrap(float location, float limit) {
    if (location%limit < 0) {
      return limit + location%limit;
    }
    return location%limit;
  }
  
  void step() {
    float r = random(1);
    if (r < .2) {
      center.x += 20;
    } else if (r < .4) {
      center.x -= 10;
    } else if (r < .6) {
      center.y += 30;
    } else {
      center.y -= 35;
    }
  }
  
  
  void dangerSensor(PVector threat) {
    float d = PVector.dist(threat, location);
    if (d < 250) {
      avoid = true;
      cd = color(255,0,0);
    }
    else if (d < 350) {
      avoid = false;
      cd = color(255,255,0);
    }
    else {
      avoid = false;
      cd = color(255,255,255);
    }
  }
  
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,location);
    desired.normalize();
    desired.mult(vLimit);
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(0.1);
    return steer;
  }
  
  PVector avoid(PVector target) {
    PVector desired = PVector.sub(location,target);
    desired.normalize();
    desired.mult(vLimit);
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(0.1);
    return steer;
  }
  
  
  
  void applyForce(PVector force) {
     acceleration = force;
  }
  
   
  void checkEdges() {
    if(location.x>width) {
      location.x = random(width);
    }
    else if (location.x < 0) {
      location.x = random(width);
    }
    if(location.y>height) {
      location.y = random(height);
    }
    else if (location.y < 0) {
      location.y = random(height);
    }
  }
  
  void applyBehaviors(Vehicle predator) {
    if (avoid) {
      applyForce(avoid(predator.location));
    }
    else {
      applyForce(seek(center));
    }
  }
  
}

class Particle {
  private float velX, velY, posX, posY;
  
  public Particle(float posX, float posY, float velX, float velY) {
    this.velX = velX;
    this.velY = velY;
    this.posX = posX;
    this.posY = posY;
  }
  
  public void draw() {
    
    stroke(255);
    point(posX, posY);
  }
  
  public void update() {
    posX += velX;
    posY += velY;
  }
  
  public void applyForce(float x, float y) {
    velX += x;
    velY += y;
  }
  
  public float getX() {
    return posX;
  }
  
  public float getY() {
    return posY;
  }
}

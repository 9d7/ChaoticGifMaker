/* Cyclic Smoke Generation
 * By Eric Schneider
 *
 * Big credit to Dan Shiffman (@shiffman on twitter) for the idea of periodic noise
 * Massive credit to Kurt Spencer (@KdotJPG on github) for his simplex noise implementation */

/***** CANVAS/GIF SETTINGS *****/

/* Number of frames in the animation. should be >= LIFETIME */
final static private int NUM_FRAMES = 150; 

/* SPEED gives the amount that the vector field will move along a 4D circle per frame.
 * This is offered instead of a parameter like CIRCLE_RADIUS because I didn't want changing
 * the number of frames to massively influence the look of the smoke. More information about the
 * equation this governs can be found in the getNoise function. */
final static private float SPEED = 0.1;

/* I divide the input to the getNoise function by this value before plugging it into the simplex
 * noise equation. Because moving one unit in the noise field can have drastically different effects than
 * moving, say, 1/80th of a unit, you can think of this as a measure of similarity between adjacent particles,
 * where as speed will give a measure of similarity between the noise fields of adjacent frames. In both cases,
 * smaller numbers -> more similarity. */
final static private float NOISE_SCALE = 1f/20;

/* If you want the same seed, use this. -1 will generate a random one. */
private long RANDOM_SEED = -1;


/***** FORCE SETTINGS *****/

/* A scalar applied to the noise before it pushes the particle. */
final static private float NOISE_FORCE_SCALE = 1.2;

/* A constant force applied every frame. -Y moves it upwards like smoke. */
final static private float GRAVITY_Y = 0;
final static private float GRAVITY_X = 0;



/***** EMITTER SETTINGS *****/

/* The position in the world that particles emit from. From 0 to 1 */
final private float EMITTER_X = 1f/2;
final private float EMITTER_Y = 1f/2;

/* The initial velocities from the particle emitter can be scaled. By default, random values are on the interval (-1, 1)
 * in the X-axis and (0, 1) in the Y. */
final static private float INITIAL_X_VELOCITY_SCALING = 2;
final static private float INITIAL_Y_VELOCITY_SCALING = 1;

/* I'm sure you can figure out what this one does :) 
 * These particles are just being emitted from a point, but I give them a random velocity so they don't just all do the same thing. */
final static private int PARTICLES_PER_FRAME = 40;

/* Particles will despawn instantly after this many frames. Should be a factor of NUM_FRAMES. */
final static int LIFETIME = 75;


/***** RENDER SETTINGS *****/

/* If RENDER, render NUM_FRAMES frames at RENDER_LOCATION */
private boolean RENDER = true;
final static private String RENDER_LOCATION = "output";

/* If DO_BLUR, blur the canvas at every frame by BLUR_AMT. Good for turning dots into smoke. */
private boolean DO_BLUR = true;
final static private int BLUR_AMT = 3;
/***********************\
* ACTUAL CODE (FINALLY) *
\***********************/

private OpenSimplexNoise osn;

/* gets random numbers for X and Y velocity */
private RandomBucket genVelX, genVelY;

private Particle[] particles;
private int particleIndex; /* iterates through particles, adding more and overwriting old ones */

private int currentFrame;

void setup() {
  size(400, 400);
  
  osn = new OpenSimplexNoise(RANDOM_SEED == -1 ? (long)random(1000000) : RANDOM_SEED);
  particles = new Particle[LIFETIME * PARTICLES_PER_FRAME];
  
  genVelX = new RandomBucket(LIFETIME * PARTICLES_PER_FRAME, -INITIAL_X_VELOCITY_SCALING, INITIAL_X_VELOCITY_SCALING);
  genVelY = new RandomBucket(LIFETIME * PARTICLES_PER_FRAME,                           0, INITIAL_Y_VELOCITY_SCALING);
  
  particleIndex = 0;
  currentFrame = 0;
}


void draw() {
  background(0);
  
  // generate this frame's new particles
  for (int i = particleIndex; i < particleIndex + PARTICLES_PER_FRAME; i++) {
    particles[i] = new Particle(EMITTER_X*width, EMITTER_Y*height, genVelX.get(i), genVelY.get(i));
  }
  particleIndex += PARTICLES_PER_FRAME;
  if (particleIndex >= particles.length) particleIndex = 0;
  
  // update force on each particle and draw it
  for (Particle p: particles) {
    if (p == null) continue; // we don't care about particles that haven't spawned
    
    p.applyForce(GRAVITY_X, GRAVITY_Y);
    
    // we get the second noise value at a large offset from the first to create two distinct noise loops
    float noiseX = getNoise(p.getX(), p.getY(), currentFrame);
    float noiseY = getNoise(p.getX() + width, p.getY(), currentFrame);
    
    p.applyForce(noiseX * NOISE_FORCE_SCALE, noiseY * NOISE_FORCE_SCALE);
    
    p.update();
    p.draw();
  
  }
  
  /* blurring stuff */
  if (DO_BLUR) {
    filter(BLUR, BLUR_AMT);
  }
  
  //filter(THRESHOLD, 0.05); /* does some cool stuff if you turn it on when blur is on */
  
  /* rendering stuff */
  if (RENDER && currentFrame >= NUM_FRAMES && currentFrame < 2 * NUM_FRAMES) {
    String outputFrame = RENDER_LOCATION + "/loop-" + String.format("%03d", currentFrame-NUM_FRAMES) + ".png";
    println("Saving " + outputFrame + "...");
    save(outputFrame);
  }
  if (RENDER && currentFrame == 2 * NUM_FRAMES) print("Done! Frames saved.");
  
  
  currentFrame++;

}

// gets a position in the 2d space, shifted in 4d space relative to the current frame
float getNoise(float x, float y, int frame) {
  
  /* one rotation per NUM_FRAMES. */
  float theta = 1f*(frame % NUM_FRAMES)/NUM_FRAMES*TAU;
  
  /* distance traveled per frame is equal to r*(change in theta), and change in theta is equal to (TAU/NUM_FRAMES).
   * To have this distance be constant, then, r has to be proportional to NUM_FRAMES/TAU. As such, this means that speed
   * determines how many units we travel around the circle per frame. */
  float r = NUM_FRAMES*SPEED/TAU;
  
  float w = r*cos(theta); /* thanks dan! */
  float z = r*sin(theta);
  
  return (float)osn.eval(x*NOISE_SCALE, y*NOISE_SCALE, z, w);
}

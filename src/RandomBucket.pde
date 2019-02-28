/* generates a bunch of random values and indexes through them modularly.
 * this ensures that the random numbers generated are cyclic (i.e. they'll repeat
 * after NUM_FRAMES frames). */

class RandomBucket {
  float[] values;
  
  public RandomBucket(int size, float min, float max) {
    values = new float[size];
    
    /* populate the bucket of random values */
    for (int i = 0; i < size; i++) {
      values[i] = random(min, max);
    }
  }
  
  /* get a value */
  public float get(int index) {
    return values[index % values.length];
  }

}

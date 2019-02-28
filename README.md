# ChaoticGifMaker
Implements a particle system set in a 4d vector field loop.

**To use:**  
  1. Download all files and place them into a new Processing sketch.
  2. Download Kurt Spencer's [OpenSimplexNoise](https://gist.github.com/KdotJPG/b1270127455a94ac5d19).
  3. Tweak the parameters, and when you're happy, set the `RENDER` to `true`.
  4. Wait for `Done!` to appear in the console.
  5. Navigate into the folder where your output is stored (by default, the folder named "output" in your sketch directory)
  6. Compile into a gif with `ffmpeg -i loop-%3d.png output.gif`
  7. Profit

**What does it do?**  
Here are examples:  
!(Ooh, wacky!)[https://github.com/ericeschnei/ChaoticGifMaker/blob/master/output.gif?raw=true]
!(Thank you Eric, very cool!)[https://github.com/ericeschnei/ChaoticGifMaker/blob/master/output3.gif?raw=true

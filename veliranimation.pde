static int FRAMERATE = 15;
float t = 0, dt = (float)1/FRAMERATE;

int objSize = 25;
int cols = 13;
int rows = 9;
int oSize = rows;
PImage imgRobot;
Oscillator o[];
int robot1X=-400;
int robot2X=-600;


int barSize = 20;
int numBars = 18;
float colorArray1[];
float colorArray2[];
float colorArray[];
float satArray1[];
float satArray2[];
float satArray[];
float sunColorArray[];
float sunSatArray[];


/* @pjs transparent="true"; */
void setup()
{
  int inc = 5;
  size(900, 560, P3D);
  o = new Oscillator[oSize];
  float p[] = ha(17, 1);
  int amplitude = objSize*2;

  imgRobot = loadImage("ipadrobot.png");

  o[0] = new Oscillator(amplitude, p[0], 0, "sin");
  o[1] = new Oscillator(amplitude, p[1], 0, "sin");
  o[2] = new Oscillator(amplitude, p[2], 0, "sin");
  o[3] = new Oscillator(amplitude, p[3], 0, "sin");
  o[4] = new Oscillator(amplitude, p[4], 0, "sin");
  o[5] = new Oscillator(amplitude, p[5], 0, "sin");
  o[6] = new Oscillator(amplitude, p[6], 0, "sin");
  o[7] = new Oscillator(amplitude, p[7], 0, "sin");
  o[8] = new Oscillator(amplitude, p[8], 0, "sin");

  colorArray1 = ia(numBars/2, .5, .6);
  colorArray2 = ia(numBars/2, .6, .5);
  colorArray = concat(colorArray1, colorArray2);

  satArray1 = ia(numBars/2, .6, .9);
  satArray2 = ia(numBars/2, .9, .6);
  satArray = concat(satArray1, satArray2);

  //Sunset
  sunColorArray = ia(numBars, .05, .2);
  sunSatArray = ia(numBars, .6, .9);
}

void draw()
{
  background(0, 0); //background(255, 255, 255, 0);
  lights();

  //paint sunset
  colorMode(HSB, 1);
  noStroke();
  int index;
  for (int i=0; i<numBars; i++)
  {
    index = int((i + t) % numBars);
    fill(sunColorArray[i], sunSatArray[index], 1);
    rect(0, i*barSize, width, barSize);
  }

  //paint waves
  for (int i=0; i<numBars; i++)
  {
    index = abs(int((i - t) % numBars));
    fill(colorArray[index], satArray[index], 1);
    rect(0, height/2 + i*barSize, width, barSize);
  }

translate(0, 0, 1);
  robot1X++;
  robot2X++;
  if (robot1X >= width + 224)robot1X=-112;
  if (robot2X >= width + 224 )robot2X=-112;
  
  image(imgRobot, robot1X, 300);
   image(imgRobot, robot2X, 300);


  colorMode(RGB, 255);

  pushMatrix();

  translate(width/2, objSize*7);
  translate(0, 0, objSize*5); //lift above the bg

  rotateY(radians((float)mouseX/width * 90 - 45));
  translate(-cols/2 * objSize, 0);

  for (int c=0; c<cols; c++)
  {
    pushMatrix();
    translate(c * objSize, 0);
    for (int r=0; r<rows; r++)
    {

      if (vMatrix[c][r]!=0)
      {       
        if (vMatrix[c][r]==1)
        {
          fill(73, 71, 69);
          noStroke();//stroke(100, 100, 0);
        } else if (vMatrix[c][r]==2)
        {
          fill(142, 184, 30);
          noStroke();//stroke(100);
        }
        pushMatrix();
        translate(0, r * objSize);

        //box 1
        translate(o[r].getValue(), 0);

        box(objSize);
        //box 2
        translate(o[r].getValue(), 0);

        translate(0, 0, -objSize);
        box(objSize);

        popMatrix();
      }
    }
    popMatrix();
  }
  popMatrix();


  t+=dt;
}

void mousePressed()
{
  t=.1;
  for (int i=0; i<o.length; i++)
  {
    o[i].prime();
  }
}


class Oscillator {
  float offset;
  float amplitude;
  float period;
  float timeShift;
  String waveShape;
  float value;
  int oPause = 1;
  int primePause = 0;

  Oscillator(float amplitude, float period, float timeShift, String waveShape) {
    this.amplitude = amplitude;
    this.period = period;
    this.timeShift = timeShift;
    this.waveShape = waveShape;
    this.value = getValue();
  }

  void prime()
  {
    primePause = 1;
    oPause = 0;
  }

  float getValue() {
    if (this.waveShape.equals("sin")) {
      value = amplitude*sin(TWO_PI/period*(t-timeShift));
    } else if (this.waveShape.equals("psin")) { // positive sine
      value = amplitude*pow(sin(TWO_PI/period*(t-timeShift)/2), 2);
    } else if (this.waveShape.equals("id")) { // for rotating or spinning
      value = amplitude*((t-timeShift)%TWO_PI/TWO_PI/period);
    }

    if (primePause == 1 && value <= 0.01)
    {
      oPause = 1;
      primePause = 0;
    }

    if (oPause == 1)
      return 0;
    else
      return value;
  }
}


int[][] vMatrix = {
  {
    1, 0, 0, 0, 0, 0, 0, 0, 0
  }
  , {
    1, 1, 1, 0, 0, 0, 0, 0, 0
  }
  , {
    1, 1, 1, 1, 1, 0, 0, 0, 0
  }
  , {
    1, 1, 1, 1, 1, 1, 1, 0, 0
  }
  , {
    1, 1, 1, 1, 1, 1, 1, 1, 1
  }
  , {
    0, 1, 1, 1, 1, 1, 1, 1, 1
  }
  , {
    0, 0, 0, 1, 1, 1, 1, 1, 1
  }
  , {
    2, 0, 0, 0, 0, 1, 1, 1, 1
  }
  , {
    2, 2, 2, 0, 0, 0, 0, 1, 1
  }
  , {
    2, 2, 2, 2, 2, 0, 0, 0, 0
  }
  , {
    2, 2, 2, 2, 2, 0, 0, 0, 0
  }
  , {
    2, 2, 2, 0, 0, 0, 0, 0, 0
  }
  , {
    2, 0, 0, 0, 0, 0, 0, 0, 0
  }
};

//harmonic array
float[] ha(int n, float coef) { // harmonic array
  float ra[] = new float[n];
  for (int i=0; i<n; i++) {
    ra[i] = n*coef/(i+1);
  }
  return ra;
}

float[] ia(int n, float f, float l) { // linear interpolation from f to l
  float ra[] = new float[n];
  for (int i=0; i<n; i++) {
    ra[i] = f + i*(l-f)/(n-1);
  }
  return ra;
}


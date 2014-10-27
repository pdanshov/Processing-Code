/**Persuasive Tech Project*/

import ddf.minim.*;
AudioPlayer player;
Minim minim;

import fullscreen.*;
FullScreen fs;

import traer.physics.*;
PImage img, img2;
ParticleSystem physics;
Particle[][] particles;
final int MAX_GRIDSIZE = 30;
int gridSizeX, gridSizeY;
float gridStepX, gridStepY;
int cols, rows;
int picX, picY, picW, picH;
int gx, gy;
boolean gvalid;
float zrest = -10.0f;
float zmove = -1.0f;
float springStrength = 2.5;
float springDamping = 0.05f;

ArrayList master, slave;
//String[] files;
int nextimg;
int fade=0, fade2=255;
int timer;
int checkSize=0;
Timer time;
int s=0;
boolean a=false;

int fx;
int fy;
int z=1;

int eximg;
String[] words = { 
  "Relax", "Breathe", "Clear your mind"
};
int index;
PFont font;

void setup() {
  size(800, 600, P3D);
  minim=new Minim(this);
  player=minim.loadFile("sound.mp3", 2048);
  frameRate(60);
  frame.setResizable(true);
  time=new Timer(500);
  time.start();
  noSmooth();
  // load image
  //  files=new String[18];
  //  for (int i=0; i <= 17; i++) {
  //    files[i]= i + ".jpg";
  //  }
  master=new ArrayList();

  for (int i=0; i<=17; i++) {
    master.add(new String(i+".jpg"));
  }

  slave=new ArrayList(master);
  //  for (int i=2.size()-1; i>=0; i--) {
  //    slave.add(master.get(i));
  //  }
  //println(slave);

  //  for (int i=slave.size()-1; i>=0; i--) {
  //    //println(slave.get(i));
  //    slave.remove(i);
  //  }

  //eximg=(int)random(slave.size());
  //img2=loadImage("trans.gif");
  img2=loadImage("1.jpg");
  img=loadImage("1.jpg");
  slave.remove("1.jpg");
  font = loadFont("MonotypeCorsiva-48.vlw");

  fs=new FullScreen(this);
  //  nextimg=(nextimg+1)%files.length;
  //  img=loadImage(files[nextimg]);
  // Determine where the image will appear on screen and ensure
  // if fills no more than 95% of the width or height but maintain
  // aspect ratio.
  float w = width;
  float h = height;
  //  while (w > 0.9f*width) {
  //    w *= width;
  //    h *= height;
  //  }
  //  while (h > 0.9f*height) {
  //    w *= width;
  //    h *= height;
  //  }
  picW = (int) w;
  picH = (int) h;
  picX = (width - picW)/2;
  picY = (height - picH)/2;

  // Calculate the horizontal and vertical grid size ensuring that
  // a grid location is roughly square and the maximum no of "strips"
  // horizontally or vertically does not exceed MAX_GRIDSIZE
  if (picW > picH) {
    gridSizeX = MAX_GRIDSIZE;
    gridSizeY = (int) ((h/w)*MAX_GRIDSIZE);
  }
  else {
    gridSizeY = MAX_GRIDSIZE;
    gridSizeX = (int) ((w/h)*MAX_GRIDSIZE);
  }

  // Calculate the size of the grid strips in pixels
  gridStepX = ((float) (picW)) / (gridSizeX - 1);
  gridStepY = ((float) (picH)) / (gridSizeY - 1);

  //        System.out.println(gridStepX + " " + gridStepY);

  physics = new ParticleSystem(0, 0.05f);
  particles = new Particle[gridSizeX][gridSizeY];  // [cols][rows]

    // Create the particles and vertical springs
  for (int i = 0; i < gridSizeX; i++) {  // for each row
    for (int j = 0; j < gridSizeY; j++) { // for each col
      particles[i][j] = physics.makeParticle(0.2f, i * gridStepX + picX, j * gridStepY + picY, zrest);
    }
  }
  // Create the horizontal springs
  for (int j = 0; j < gridSizeY; j++) {
    for (int i = 1; i < gridSizeX; i++) {
      physics.makeSpring(particles[i - 1][j], particles[i][j], springStrength, springDamping, gridStepY);
    }
  }
  // Create the vertical springs
  for (int i = 0; i < gridSizeX; i++) {  // for each row
    for (int j = 1; j < gridSizeY; j++) { // for each col
      // Spring -  (  particle 1, particle 2, sterngth, damping, restLength )
      physics.makeSpring(particles[i][j - 1], particles[i][j], springStrength, springDamping, gridStepX);
    }
  }
  // Fix the particles on the picture edge
  for (int i = 0; i < gridSizeX; i++) {
    particles[i][0].makeFixed();
    particles[i][gridSizeY-1].makeFixed();
  }
  for (int j = 0; j < gridSizeY; j++) {
    particles[0][j].makeFixed();
    particles[gridSizeX-1][j].makeFixed();
  }
  noStroke();
  registerMouseEvent(this);
  timer=0;
}
void draw()
{
  if (s==0) {
    frame.setSize(1, 1);
  }
  //  camera();
  //  physics.advanceTime(0.1f);
  physics.tick(0.1);
  //  System.out.println(frameRate);
  if (key=='s' && checkSize==0)
  {
    frame.setSize(800, 600);
    fs.enter();
    checkSize=1;
    s=1;
    player.loop();
    player.shiftGain(-30.0, 0.0, 10000);
  }
  else {
    if (timer==0 && fade<255 && s==1)
    {
      fade=fade+5;
      //fill(255, 0, 0, fade);
      // tint(255, 255, 255, fade);
      // image(img, 0, 0, width, height);
      //delay(75);
      if (key=='z' && z==0) {
        gx = (int) ((width/2 - picX + gridStepX/2)/gridStepX);
        gy = (int) ((height/2 - picY + gridStepY/2)/gridStepY);
        particles[gx][gy].position().set(width/2, height/2, 200);
        particles[gx][gy].velocity().clear();
      }
      else if (key=='z' && z==1)
      {
        z=0;
      }
      background(0);
    }
    else
      if (fade>=255 && timer!=0 && time.isFinished()) {
        fade = 0;
        //tint(0, 0, 0, fade);
        eximg=(int)random(slave.size());
        img=loadImage((String)slave.get(eximg));
        slave.remove(eximg);
        if (slave.size()==0) {
          //println("reset");
          slave=new ArrayList(master);
        }
        //      nextimg=(nextimg+1)%files.length;
        //      img=loadImage(files[nextimg]);
        //delay(7000); //this decides how long an image should be displayed
        timer=0;
        time.start();
      }
    timer=(timer+1)%2;
  }
  //timer=(timer+1)%2;
  //background(220, 220, 255);
  //image(img2,0,0,width,height);
  //background(img2);
  //background(0);

  textFont(font);
  tint(150, 150, 150, 255);
  fill(255, 255, 255, 255);
  index = int(random(words.length));
  text("'ello", width/2.3, height/5, 100);
  render();
}

void render() {
  textureMode(NORMAL);

  float t, s, t2, s2;
  float deltaS = 1.0f/gridSizeX;
  float deltaT = 1.0f/gridSizeY;

  for (int row = 0; row < gridSizeY - 1; row++) {

    beginShape(TRIANGLE_STRIP);
    texture(img);
    //tint(255, 255, 255, fade);

    for (int col = 0; col < gridSizeX; col++) {
      t = row * deltaT;
      s = col * deltaS;
      vertex(particles[col][row].position().x(), particles[col][row].position().y(), particles[col][row].position().z(), s, t);
      t += deltaT;
      vertex(particles[col][row+1].position().x(), particles[col][row+1].position().y(), particles[col][row+1].position().z(), s, t);
    }
    endShape();
  }
}

void mouseEvent(MouseEvent event) {
  switch(event.getID()) {
  case MouseEvent.MOUSE_PRESSED:
    gx = (int) ((mouseX - picX + gridStepX/2)/gridStepX);
    gy = (int) ((mouseY - picY + gridStepY/2)/gridStepY);
    if (gx >0 && gx < gridSizeX-1 && gy>0 && gy <gridSizeY-1) {
      gvalid = true;
      particles[gx][gy].position().set(mouseX, mouseY, zmove);
      particles[gx][gy].velocity().clear();
    }
    break;
  case MouseEvent.MOUSE_MOVED:
    break;
  case MouseEvent.MOUSE_CLICKED:
    if (gvalid) {
      particles[gx][gy].position().set(mouseX, mouseY, zrest);
    }
    gvalid = false;
    break;
  case MouseEvent.MOUSE_RELEASED:
    if (gvalid) {
      particles[gx][gy].position().set(mouseX, mouseY, zrest);
    }
    gvalid = false;

    break;
  case MouseEvent.MOUSE_DRAGGED:
    if (gvalid) {
      particles[gx][gy].position().set(mouseX, mouseY, zmove);
      particles[gx][gy].velocity().clear();
    }
    break;
  }
}
void keyPressed() {
  if (key=='x') {
    gx = (int) ((width/2 - picX + gridStepX/2)/gridStepX);
    gy = (int) ((height/2 - picY + gridStepY/2)/gridStepY);
    particles[gx][gy].position().set(width/2, height/2, 200);
    particles[gx][gy].velocity().clear();
  }
  if (key=='Z') {
    z=1;
  }
  if (key=='a' && !a) {
    player.shiftGain(0.0, -80.0, 2000);
    a=true;
  } 
  else if (key=='a' && a) {
    player.shiftGain(-30.0, 0.0, 5000);
    a=false;
  }
}
void stop()
{
  player.close();
  minim.stop();

  super.stop();
}

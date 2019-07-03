
// Michal Huller 22.02.2015
// Drawing Mandala
// revised on 30.06.2019

/**
 * 
 * KEYS
 * y                   : toogle symmetry
 * s                   : save image as png
 * n                   : new image
 * r                   : start recording PDF
 * e                   : end recording PDF and save
 * w                   : toogle background black or white
 * l                   : toogle lines
 * m                   : toogle Mandala
 * t                   : toogle transparent 
 * 1-2                 : 1 - decrease pen width and 2 - increase
 * 3-4                 : 3 - decrease number petals and 4 - increase
 * space               : new noise seed
 * backspace           : clear screen
 * s                   : save png
 * c                   : change color in the current pallette
 * p                   : toggle Flower of life on/off
 */

float agentsAlpha = 90, strokeW = 3;
int drawMode = 1;
color bg = 0;
PImage scrShot;
PGraphics buf;
// color pallette
color [][]tablePens = {
  {#F98866, #FF420E, #80BD9E, #89DA59, #FFFFFF},
  {#98DBC6, #5BC8AC, #E6D72A, #F18D9E, #FFFFFF},
  {#F4CC70, #DE7A22, #20948b, #6AB187, #FFFFFF},
  {#F1F1F2, #BCBABE, #A1D6E2, #1995AD, #FFFFFF},
  {#9A9EAB, #5D535E, #EC96A4, #DFE166, #FFFFFF},
  {#eb8a44, #f9dc24, #4b7447, #8eba43, #ffffff},
  {#f52549, #fa6775, #ffd64d, #9bc01c, #ffffff},
  {#34888C, #7CAA2D, #F5E356, #CB6318, #FFFFFF},
  {#258039, #F5BE41, #31A9B8, #CF3721, #FFFFFF},
  {#EE693F, #F69454, #FCFDFE, #739F3D, #F68454},
  {#F70025, #F7EFE2, #F25C00, #F9A603, #FFFFFF},
  {#A1BE95, #E2DFA2, #92AAC7, #ED5752, #FFFFFF},
  {#4897D8, #FFDB5C, #FA6E59, #F8A055, #FFFFFF},
  {#00293c, #1e656d, #f1f3ce, #f62a00, #f2ee7e},
  {#626d71, #cdcdc0, #ddbc95, #b38867, #ffffff},
  {#258039, #f5be41, #31a9b8, #cf3721, #212117},
  {#b9d9c3, #752a07, #fbcb7b, #eb5e30, #ffffff},
  {#1e1f26, #283655, #4d648d, #d0e1f9, #e4ebfa},
  {#a1be95, #e2dfa2, #92aac7, #ed5752, #ffffff},
  {#4897d8, #ffdb5c, #fa6e59, #f8a055, #ffffff},
  {#af4425, #662e1c, #ebdcb2, #c9a66b, #ffffff},
  {#c1e1dc, #ffccac, #fbf190, #fdd475, #ffffff}  
};

boolean transp = false;
boolean pen = true;
boolean fromPIC = true;
boolean toDraw = false;
boolean circles = true;
boolean drawPerch = false;

int slices = 12;
color picolor = 0;
PVector []nek;
float factor=1;
int pal = 0;
int pix;

void setup() {
  size(800, 800); //(1200,676); //(1280,1024); //(900, 506); //size(1280,800,P3D);//16:9
  background(bg);
  smooth();
  frameRate(5);
  nek = new PVector[4];
  for (int i=0; i<4; i++)
    nek[i] = new PVector(0, 0);

  buf = createGraphics(1600, 1600);
  factor = float(buf.width)/width;
  //noLoop();
  initit();
}

void initit() {  
  buf.beginDraw();
  buf.background(bg);
  background(bg);
  if (circles) 
    drawPerch = true;
  buf.endDraw();
  //pal = round(random(5000)) % 22;
  //pix = round(random(3400)) % 5;
  pal = (pal + 1) % 22;
  pix = 0;
  picolor = tablePens[pal][pix];
}

void draw() {  
  if (transp) {
    stroke(picolor, 120);
    buf.stroke(picolor, 120);
  } else {
    stroke(picolor, 240);
    buf.stroke(picolor, 240);
  }
  strokeWeight(strokeW);
  buf.strokeWeight(strokeW *factor);
  noFill();
  buf.noFill();

  buf.beginDraw();
  //// draw flower of life
  if (drawPerch) {
    drawPerch = false;
    makefl();    
  }
  if (toDraw) {
    /////////////// Mandala //////////////
    int fast = slices;
    if (nek[0].x == 0 && nek[0].y == 0) {
      nek[0].x = pmouseX;
      nek[0].y = pmouseY;
    }
    if (nek[1].x == 0 && nek[1].y == 0) {
      nek[1].x = pmouseX;
      nek[1].y = pmouseY;
    }
    if (nek[2].x == 0 && nek[2].y == 0) {
      nek[2].x = mouseX;
      nek[2].y = mouseY;
    }

    nek[3].x = mouseX;
    nek[3].y = mouseY;
    PVector []slnek = new PVector[4]; // right side points
    PVector []slbuf = new PVector[4]; // big buffer points
    for (int i=0; i<4; i++) {
      slnek[i] = new PVector(nek[i].x - width/2, nek[i].y - height/2);
      slbuf[i] = new PVector(nek[i].x - width/2, nek[i].y - height/2);
      slbuf[i].mult(factor);
    }

    float alpha = 0; 

    pushMatrix();
    translate(width/2, height/2);
    if (alpha > 0) rotate((TWO_PI/fast)/2);

    buf.pushMatrix();
    buf.translate(buf.width/2, buf.height/2);
    if (alpha > 0) buf.rotate((TWO_PI/fast)/2);

    for (int ll = 0; ll < fast; ll++) {
      /////////////// mirror //////////////////
      if (ll % 2 == 1) {   
        
        PVector []mir = new PVector[4]; // mirror points 
        for (int i=0; i<4; i++) {
          mir[i] = PVector.fromAngle(TWO_PI/slices - slnek[i].heading());
          mir[i].setMag(slnek[i].mag());
        }

        curve(mir[0].x, mir[0].y, mir[1].x, mir[1].y, 
        mir[2].x, mir[2].y, mir[3].x, mir[3].y);

        PVector []mirbuf = new PVector[4]; // mirror points of buf
        for (int i=0; i<4; i++) {
          mirbuf[i] = PVector.fromAngle(TWO_PI/slices - slbuf[i].heading());
          mirbuf[i].setMag(slbuf[i].mag());
        }
        buf.curve(mirbuf[0].x, mirbuf[0].y, mirbuf[1].x, mirbuf[1].y, 
        mirbuf[2].x, mirbuf[2].y, mirbuf[3].x, mirbuf[3].y);
      }
      else {
        curve(slnek[0].x, slnek[0].y, slnek[1].x, slnek[1].y, 
        slnek[2].x, slnek[2].y, 
        slnek[3].x, slnek[3].y);
        buf.curve(slbuf[0].x, slbuf[0].y, slbuf[1].x, slbuf[1].y, 
        slbuf[2].x, slbuf[2].y, 
        slbuf[3].x, slbuf[3].y);
      }
      rotate(TWO_PI/fast);
      buf.rotate(TWO_PI/fast);
    }
    popMatrix();
    buf.popMatrix();
  }
  buf.endDraw();
  
  nek[0].x = nek[1].x;
  nek[0].y = nek[1].y;
  nek[1].x = pmouseX;
  nek[1].y = pmouseY;
  nek[2].x = mouseX;
  nek[2].y = mouseY;
}


void keyReleased() {
  if (key == 'n' || key == 'N') {
    initit();
  }

  if (key == 's' || key == 'S') {
    int numR = int(random(5000));
    String fname="kal_" + year() + month() + day() + "_" + frameCount +"_" + numR + ".png";
    String bufSave = "h"+fname;
    scrShot=get(0, 0, width, height);
    scrShot.save("snapshot/" + fname);
    buf.save("snapshot/" + bufSave);
  }
  if (key == 't' || key =='T') {
    transp = !transp;
  }
  if (key == '1') {
    strokeW -= 0.3;
    if (strokeW < 0.3) strokeW = 0.3;
  }
  if (key == '2') {
    strokeW += 0.3;
    if (strokeW > 20) strokeW -= 0.3;
  }
  if (key == '3') {
    slices -= 2;
    if (slices < 6) slices = 6;
  }
  if (key == '4') {
    slices += 2;
    if (slices > 36) slices = 36;
  }

  if (key == 'w' || key =='W') {
    bg = 255 - bg;
    initit();
  }
  if (key == 'c' || key =='C') {
    pix = (pix + 1) % 5;
    picolor = tablePens[pal][pix];
  }
  if (key == 'p' || key =='P') {
    circles = !circles;
    if (circles) makefl();
  }
}

void mouseDragged() {
  if (!toDraw) {
    toDraw = true;
  }
}

void mouseReleased() { 
  toDraw = false;
}

void makefl() {
  float koter = width/3;
    pushMatrix();
    buf.pushMatrix();
    translate(width/2, height/2);
    buf.translate(buf.width/2, buf.height/2);
    ellipse(0, 0, koter, koter);
    buf.ellipse(0, 0, koter* factor, koter*factor);
    for (int j=0; j<3; j++) {
      for (int i=0; i < 6; i++) {
        if (j == 0) {
          ellipse(0, -0.5*koter, koter, koter);
          buf.ellipse(0, -0.5*koter*factor, koter*factor, koter*factor);
        }
        if (j == 1) {
          ellipse(0, -koter, koter, koter);
          buf.ellipse(0, -koter*factor, koter*factor, koter*factor);
        }
        if (j == 2) {
          ellipse(0, -sqrt(3)*koter/2, koter, koter);
          buf.ellipse(0, -sqrt(3)*koter*factor/2, koter*factor, koter*factor);
        }
        rotate(TWO_PI/6);
        buf.rotate(TWO_PI/6);
      }
      if (j%2 == 1) {
        rotate(TWO_PI/12);
        buf.rotate(TWO_PI/12);
      }
    }
    ellipse(0, 0, 3*koter, 3*koter);
    buf.ellipse(0, 0, 3*koter*factor, 3*koter*factor);

    popMatrix();
    buf.popMatrix();
}

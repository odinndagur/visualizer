import peasy.*;
PeasyCam cam;

float[][] heights = new float[50][50];

int planeW = 400;
int planeH = 1200;

void setup(){
  size(800,800,P3D);
  //cam = new PeasyCam(this,100);
  for(int i = 0; i < heights.length; i++){
    for(int j = 0; j < heights[0].length; j++){
    heights[i][j] = random(30);
    }
  }
}

void draw(){
  background(105);
  translate(width/2,height/2);
  rectMode(CENTER);
  rotateX(PI/2.5);
  stroke(0);
  rect(0,0,planeW,planeH);
  stroke(255,0,0);
  noFill();
  
  for(int i = 0; i < heights.length; i++){
      beginShape();

    for(int j = 0; j < heights[0].length; j++){
      stroke(255,0,0,map(i,0,heights.length,0,255));
      vertex(
      map(j,0,heights[0].length,-planeW/2,planeW/2),
      map(i,0,heights.length,-planeH/2,planeH/2),
      heights[i][j]);
    }
          endShape(OPEN);

  }
  
  fill(255);
  stroke(0);

}

PVector centre;
int radius = 300;
int segment = 6;
float numOfSegments = radius / segment;
float angle = 2*PI;

void setup() {
  size(800,800);
  background(255);
  centre = new PVector(width/2, height/2);
}

void draw() {
  noFill();
  stroke(0);

  // Start drawing here
  angle-=0.1;

  //float endX = centre.x + radius*sin(radians(angle));
  //float endY = centre.y + radius*cos(radians(angle));

  //line(centre.x, centre.y, endX, endY);

  // divide line into 60 segments
  // each segment greyscale of 0 to 255
  // randomise

  float endX = centre.x + 0;
  float endY = centre.y + 0;

  for (int i = 0; i < numOfSegments; i++) {
    PVector oldEnd = new PVector(endX, endY);

    endX = oldEnd.x + segment*sin(radians(angle));
    endY = oldEnd.y + segment*cos(radians(angle));

    stroke(int(random(0,255)));
    line(oldEnd.x, oldEnd.y, endX, endY);
    //stroke+=5;
  }


  // End drawing here
}

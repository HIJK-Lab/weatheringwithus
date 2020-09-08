Dataset[] cities;
int numOfCities = 12;
int dataSize;

PVector centre;
int radius = 600;
int numOfSegments = 36;
int segment = radius / numOfSegments;
int segmentsPerCity = int(numOfSegments / numOfCities);

float angle = 0;
float revolution = 360;
float increment;
int counter = 0;
int previousMillis = 0;
int interval = 150; // Control speed of rotation here

float sw = 5; // Control strokeweight here

void setup() {
  size(700,700);
  background(255);
  // pixelDensity(2);
  noFill();

  cities = new Dataset[numOfCities];

  // loop through x number of cities
  for (int i = 0; i < numOfCities; i++) {
    int cityID = i + 1;
    String historical = "data/historical_" + cityID + ".json";
    String RCP85 = "data/RCP85_" + cityID + ".json";
    Dataset h = loadJSON(historical);
    Dataset r = loadJSON(RCP85);
    cities[i] = combine(h, r);
  }

  increment = revolution / dataSize;
  centre = new PVector(width/2, height/2);
}


void draw() {
  int currentMillis = millis();

  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;

    float next = angle + increment;

    for (int i = 0; i < numOfSegments; i++) {
      color shade;

      int x = int(i / segmentsPerCity);
      shade = int( map(cities[x].values[counter], cities[x].min, cities[x].max, 255, 50) );

      // Determine if line or dot
      int y = (i + 1) % 3;
      if (y == 0 || y == 1) sw = 8;
      else sw = 3;

      strokeWeight(sw);
      stroke(shade);
      arc(centre.x, centre.y, i*segment, i*segment, radians(angle)-PI/2, radians(next)-PI/2);

      // clear the space ahead
      //strokeWeight(8);
      stroke(255);
      arc(centre.x, centre.y, i*segment, i*segment, radians(next)-PI/2, radians(next+increment)-PI/2);
      //line( centre.x, centre.y, centre.x + (radius/2)*cos(radians(next)-PI/2), centre.y + (radius/2)*sin(radians(next)-PI/2) );
    }

    counter++;
    if (counter >= dataSize) counter = 0;
    angle+=increment;
    if (angle >= revolution-1) angle = 0;
  }
}


Dataset loadJSON(String http) {
  JSONObject json = loadJSONObject(http);
  JSONObject data = json.getJSONObject("data");

  // Iterate through each value of JSONObject and sort by ascending date
  // forum.processing.org/two/discussion/5344/how-can-i-access-a-jsonobject-keys-set
  String[] keys;
  keys = (String[]) data.keys().toArray(new String[data.size()]);
  keys = sort(keys);

  float[] values = new float[keys.length];

  for (int i = 0; i < keys.length; i++) {
    String key = keys[i];
    JSONObject value = data.getJSONObject(key);
    values[i] = value.getFloat("max");
  }

  Dataset d = new Dataset(values, 0, 0);
  return d;
}


Dataset combine(Dataset historical, Dataset RCP85) {
  float[] combined = concat(historical.values, RCP85.values);
  float min = min(combined);
  float max = max(combined);

  dataSize = combined.length;

  //combined = fillArray(combined, revolution);

  Dataset d = new Dataset(combined, min, max);
  return d;
}


float[] fillArray(float[] array, int desiredSize) {
  while (array.length < desiredSize) array = concat(array, array);
  return array;
}

// ====== CLASSES ======

class Dataset {
  float[] values;
  float min, max;

  Dataset(float[] v, float m1, float m2) {
    values = v;
    min = m1;
    max = m2;
  }
}

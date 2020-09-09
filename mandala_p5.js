let numOfCities = 12
let historical = [numOfCities]
let RCP85 = [numOfCities]
let cities = [numOfCities]
let dataSize

let centre
const radius = 600
const numOfSegments = 36
let segment = radius / numOfSegments
let segmentsPerCity = (numOfSegments / numOfCities) | 0

let angle = 0
const revolution = 360
let increment
let counter = 0
let previousMillis = 0
const interval = 300 // Control speed of rotation here

let sw = 5 // Control strokeweight here
let bg;

function preload () {
  bg = loadImage("assets/green-sand.png")
    
  for (let i = 0; i < numOfCities; i++) {
    let cityID = i + 1
    historical[i] = loadJSON("data/historical_" + cityID + ".json")
    RCP85[i] = loadJSON("data/RCP85_" + cityID + ".json")
  }
}

function setup () {
  let canvas = createCanvas(600, 600)
  canvas.parent('sketch');
  blendMode(MULTIPLY)
  background(bg)
  noFill()

  for (let i = 0; i < numOfCities; i++) {
    let h = loadData(historical[i])
    let r = loadData(RCP85[i])
    cities[i] = combine(h,r)
  }

  increment = revolution / dataSize
  centre = createVector(width/2, height/2)
}

function draw () {
  
  let currentMillis = millis()

  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis

    let next = angle + increment

    for (let i = 0; i < numOfSegments; i++) {
      let shade

      let x = int(i / segmentsPerCity)
      shade = int( map(cities[x].values[counter], cities[x].min, cities[x].max, 255, 180) )

      // Determine if line or dot
      let y = (i + 1) % 3
      if (y == 0 || y == 1) sw = 7
      else sw = 3
        
      strokeWeight(sw)
      stroke(shade)
      arc(centre.x, centre.y, i*segment, i*segment, radians(angle)-PI/2, radians(next)-PI/2)

      // clear the space ahead
      stroke(255)
      arc(centre.x, centre.y, i*segment, i*segment, radians(next)-PI/2, radians(next+increment)-PI/2)
    }

    counter++
    if (counter >= dataSize) counter = 0
    angle += increment
    if (angle >= revolution - 1) angle = 0
  }
}

function loadData (object) {
  let data = object.data
  let keys = Object.keys(data)
  keys = sort(keys)

  let values = new Array(keys.length)

  for (let i = 0; i < keys.length; i++) {
    let key = keys[i]
    let value = data[key]
    values[i] = value.max
  }

  let d = new Dataset(values, 0, 0)
  return d
}

function combine (historical, RCP85) {
  let combined = concat(historical.values, RCP85.values)
  let minimum = min(combined)
  let maximum = max(combined)

  dataSize = combined.length

  let d = new Dataset(combined, minimum, maximum)
  return d
}

class Dataset {
  constructor (values, min, max) {
    this.values = values
    this.min = min
    this.max = max
  }
}

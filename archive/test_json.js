let json;

function preload () {
  let url = "data/test.json"
  json = loadJSON(url)
  console.log(json)
}

function setup () {
  createCanvas(700, 700)
  background(255)
  noFill()

  let data = json.fruit
  // console.log(data)
}

{.experimental: "dotOperators".}

type Vector = tuple[x, y:float]

const 
  DOWN* = 1 
  UP* = -1
  RIGHT* = 1
  LEFT*  = -1
  STILL* = 0
type Object* = object 
  pos*: Vector = (0.0, 0.0)
  speed*: Vector = (0.5, 0)
  acceleration*: Vector = (0.25, 0.05)
  maximumSpeed* = 2.5f
  directionX*, directionY* = 0
  accelerating*, moving*: bool 

func `*`*(firstVector: Vector, secondVector: Vector): Vector {.inline.} = (firstVector.x * secondVector.x, firstVector.y * secondVector.y)

func `*`*(firstVector: Vector, number: float): Vector {.inline.} = (firstVector.x * number, firstVector.y * number)

func `.`*(firstVector: Vector, secondVector: Vector): Vector {.inline.} = 
  (firstVector.x * secondVector.y, firstVector.y * secondVector.x)
 
func `+`*(firstVector: Vector, secondVector: Vector): Vector {.inline.} = (firstVector.x + secondVector.x, firstVector.y + secondVector.y)

func fill*(vect: var Vector, number: float) {.inline.} = 
  vect = (number, number)

func move*(obj: var Object, time: float) = 
  obj.pos.x += obj.speed.x * obj.directionX
  obj.pos.y += obj.speed.y * obj.directionY


func accelerate*(obj: var Object, time: float) = 
  # vf = vi + 󰇂 t*a
  obj.speed = obj.speed + (obj.acceleration * time)
  obj.pos.x += obj.speed.x * obj.directionX
  obj.pos.y += obj.speed.y * obj.directionY
    

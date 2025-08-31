import ui/ui
import ui/transitions
import terminal
import std/unicode
import math
import os
import times, threadpool

type Line = object 
  x0,x1,y0,y1: int
type Point = tuple[x,y: float]
type Rectangle = object 
  points: array[4, Point]

type ActualGoodRectangle = object
  angle: float
  animationProgression, scalar: float32 = 0.0
  up = true
  centerX,centerY: float
  sX,sY: array[4, float]
  mX,mY: array[4, float]


func reset(rect: var ActualGoodRectangle) {.inline.} = 
  for i in 0..3:
    rect.mX[i] = rect.sX[i]
    rect.mY[i] = rect.sY[i]

func newRectangle(centerPoint: Point, width, height: float):  Rectangle {.inline.} = 
  {.pragma: simd.}
  let 
    halfWidth = width / 2
    halfHeight = height / 2
    x0 = centerPoint.x - halfWidth 
    x1 = centerPoint.x + halfWidth
    y0 = centerPoint.y - halfHeight
    y1 = centerPoint.y + halfHeight

  result = Rectangle(points:[(x0,y0), (x1, y0),(x1, y1), (x0, y1)])
func newActualRectangle(x, y: float32, width, height: float):  ActualGoodRectangle {.inline.} = 
  {.pragma: simd.}
  let 
    halfWidth = width / 2
    halfHeight = height / 2
    x0 =  - halfWidth 
    x1 = halfWidth
    y0 = -halfHeight
    y1 =  halfHeight

  result = ActualGoodRectangle(centerX:x,centerY:y, sX:[x0,x1,x1,x0], sY:[y0,y0,y1,y1])


func scaleUp(rect: var ActualGoodRectangle, scalar: float) {.inline.} = 
  {.pragma: simd.}
  let current = easeInOut(rect.animationProgression)
  rect.mX[0] = rect.sX[0] - scalar * current
  rect.mX[1] = rect.sX[1] + scalar * current
  rect.mX[2] = rect.sX[2] + scalar * current
  rect.mX[3] = rect.sX[3] - scalar * current

func scaleDown(rect: var ActualGoodRectangle, scalar: float) {.inline.} = 
  {.pragma: simd.}
  let current = easeInOut(rect.animationProgression)
  rect.mX[0] = rect.sX[0] + scalar * current
  rect.mX[1] = rect.sX[1] - scalar * current
  rect.mX[2] = rect.sX[2] - scalar * current
  rect.mX[3] = rect.sX[3] + scalar * current



func rotate(obj: var Line, angle: float) = 
  let
    rad = angle.degToRad
    xCenter = (obj.x0 + obj.x1) / 2
    yCenter = (obj.y0 + obj.y1) / 2 
    x0Trans = obj.x0.toFloat - xCenter
    y0Trans = obj.y0.toFloat - yCenter
    x1Trans = obj.x1.tofloat - xCenter
    y1Trans = obj.y1.tofloat - yCenter

  obj.x0 = (xCenter + x0Trans * cos(rad) - y0Trans * sin(rad)).round().toInt()
  obj.y0 = (yCenter + x0Trans * sin(rad) + y0Trans * cos(rad)).round().toInt()
  obj.x1 = (xCenter + x1Trans * cos(rad) - y1Trans * sin(rad)).round().toInt()
  obj.y1 = (yCenter + x1Trans * sin(rad) + y1Trans * cos(rad)).round().toInt()

func rotate(rect: var Rectangle, angle, aspectratio: float ) = 
  let 
    centerpoint: Point = ((rect.points[0].x + rect.points[2].x ) / 2, (rect.points[0].y + rect.points[2].y) / 2)
    rad = angle.degtorad
    sintheta = sin(rad)
    costheta = cos(rad)


  for i, point in rect.points:
    rect.points[i] = (centerpoint.x + (point.x - centerpoint.x) * costheta - ((point.y - centerpoint.y) * aspectratio) * sintheta, centerpoint.y + ((point.x - centerpoint.x) * sintheta + ((point.y - centerpoint.y) * aspectratio) * costheta) / aspectratio)

const dash = Rune(0x23)

func rotate(rect: var ActualGoodRectangle, angle: float) {.inline.} = 
  rect.angle += angle mod 360

func setAngle(rect: var ActualGoodRectangle, angle: float) {.inline.} = 
  rect.angle = angle

proc drawRect(buffer: var TerminalBuffer, rect: ActualGoodRectangle, aspectRatio: float ) = 
  {.pragma: simd.}

  let 
    rad = rect.angle.degtorad
    centerX = rect.centerX 
    centerY = rect.centerY 
    sintheta = sin(rad)
    costheta = cos(rad)
    
    x0O = rect.sX[0]  
    y0O = rect.sY[0]  
    x1O = rect.sX[1]  
    y1O = rect.sY[1]  
    x2O = rect.sX[2]  
    y2O = rect.sY[2]  
    x3O = rect.sX[3]  
    y3O = rect.sY[3] 

    newX0 = (centerX + (x0O * costheta - y0O * sintheta))
    newY0 = (centerY + (x0O * sintheta + (y0O) * costheta) * aspectRatio)
    newX1 = (centerX + (x1O * costheta - y1O * sintheta) )
    newY1 = (centerY + (x1O * sintheta + y1O * costheta)  * aspectRatio)
    newX2 = (centerX + (x2O * costheta - y2O * sintheta))
    newY2 = (centerY + (x2O * sintheta + y2O * costheta)  * aspectRatio)
    newX3 = (centerX + (x3O * costheta - y3O * sintheta))
    newY3 = (centerY + (x3O * sintheta + y3O * costheta)  * aspectRatio)

 
    newX0Rounded = newX0.round().toInt()
    newY0Rounded = newY0.round().toInt()
    newX1Rounded = newX1.round().toInt()
    newY1Rounded = newY1.round().toInt()
    newX2Rounded = newX2.round().toInt()
    newY2Rounded = newY2.round().toInt()
    newX3Rounded = newX3.round().toInt()
    newY3Rounded = newY3.round().toInt()

   
    
  buffer.drawLine(newX0Rounded, newY0Rounded, newX1Rounded, newY1Rounded, dash)
  buffer.drawLine(newX1Rounded, newY1Rounded, newX2Rounded, newY2Rounded, dash)
  buffer.drawLine(newX2Rounded, newY2Rounded, newX3Rounded, newY3Rounded,dash)
  buffer.drawLine(newX3Rounded, newY3Rounded, newX0Rounded, newY0Rounded, dash)



proc drawRectClean(buffer: var TerminalBuffer, rect: ActualGoodRectangle, aspectRatio: float ) = 
  {.pragma: simd.}

  let 
    rad = rect.angle.degtorad
    centerX = rect.centerX 
    centerY = rect.centerY 
    sintheta = sin(rad)
    costheta = cos(rad)
    
    x0O = rect.sX[0]  
    y0O = rect.sY[0]  
    x1O = rect.sX[1]  
    y1O = rect.sY[1]  
    x2O = rect.sX[2]  
    y2O = rect.sY[2]  
    x3O = rect.sX[3]  
    y3O = rect.sY[3] 

    newX0 = (centerX + (x0O * costheta - y0O * sintheta))
    newY0 = (centerY + (x0O * sintheta + (y0O) * costheta) * aspectRatio)
    newX1 = (centerX + (x1O * costheta - y1O * sintheta) )
    newY1 = (centerY + (x1O * sintheta + y1O * costheta)  * aspectRatio)
    newX2 = (centerX + (x2O * costheta - y2O * sintheta))
    newY2 = (centerY + (x2O * sintheta + y2O * costheta)  * aspectRatio)
    newX3 = (centerX + (x3O * costheta - y3O * sintheta))
    newY3 = (centerY + (x3O * sintheta + y3O * costheta)  * aspectRatio)

 
    newX0Rounded = newX0.round().toInt()
    newY0Rounded = newY0.round().toInt()
    newX1Rounded = newX1.round().toInt()
    newY1Rounded = newY1.round().toInt()
    newX2Rounded = newX2.round().toInt()
    newY2Rounded = newY2.round().toInt()
    newX3Rounded = newX3.round().toInt()
    newY3Rounded = newY3.round().toInt()

   
    
  buffer.drawLineClean(newX0Rounded, newY0Rounded, newX1Rounded, newY1Rounded, dash)
  buffer.drawLineClean(newX1Rounded, newY1Rounded, newX2Rounded, newY2Rounded, dash)
  buffer.drawLineClean(newX2Rounded, newY2Rounded, newX3Rounded, newY3Rounded,dash)
  buffer.drawLineClean(newX3Rounded, newY3Rounded, newX0Rounded, newY0Rounded, dash)


func rotateAndDraw(buffer: var TerminalBuffer, rect: ActualGoodRectangle, angle, aspectRatio: float ) = 
  {.pragma: simd.}

  let 
    rad = rect.angle.degtorad
    centerX = rect.centerX 
    centerY = rect.centerY 
    sintheta = sin(rad)
    costheta = cos(rad)
    
    x0O = rect.sX[0]  
    y0O = rect.sY[0]  
    x1O = rect.sX[1]  
    y1O = rect.sY[1]  
    x2O = rect.sX[2]  
    y2O = rect.sY[2]  
    x3O = rect.sX[3]  
    y3O = rect.sY[3] 

    newX0 = (centerX + (x0O * costheta - y0O * sintheta))
    newY0 = (centerY + (x0O * sintheta + (y0O) * costheta) * aspectRatio)
    newX1 = (centerX + (x1O * costheta - y1O * sintheta) )
    newY1 = (centerY + (x1O * sintheta + y1O * costheta)  * aspectRatio)
    newX2 = (centerX + (x2O * costheta - y2O * sintheta))
    newY2 = (centerY + (x2O * sintheta + y2O * costheta)  * aspectRatio)
    newX3 = (centerX + (x3O * costheta - y3O * sintheta))
    newY3 = (centerY + (x3O * sintheta + y3O * costheta)  * aspectRatio)

 
    newX0Rounded = newX0.round().toInt()
    newY0Rounded = newY0.round().toInt()
    newX1Rounded = newX1.round().toInt()
    newY1Rounded = newY1.round().toInt()
    newX2Rounded = newX2.round().toInt()
    newY2Rounded = newY2.round().toInt()
    newX3Rounded = newX3.round().toInt()
    newY3Rounded = newY3.round().toInt()

   
    
  buffer.drawLine(newX0Rounded, newY0Rounded, newX1Rounded, newY1Rounded, dash)
  buffer.drawLine(newX1Rounded, newY1Rounded, newX2Rounded, newY2Rounded, dash)
  buffer.drawLine(newX2Rounded, newY2Rounded, newX3Rounded, newY3Rounded,dash)
  buffer.drawLine(newX3Rounded, newY3Rounded, newX0Rounded, newY0Rounded, dash)
  
  # rect.x0 = centerPointX + x0Trans * costheta - y0Trans * sintheta
  # rect.y0 = centerPointY + x0Trans * sintheta + y0Trans * costheta
  # rect.x1 = centerPointX + x1Trans * costheta - y1Trans * sintheta
  # rect.sX = centerPointY + x1Trans * sintheta + y1Trans * costheta



func rotate(rect: var ActualGoodRectangle, angle, aspectRatio: float ) = 
  {.pragma: simd.}

  let 
    rad = rect.angle.degtorad
    centerX = rect.centerX 
    centerY = rect.centerY 
    sintheta = sin(rad)
    costheta = cos(rad)
    
    x0O = rect.mX[0]  
    y0O = rect.mY[0]  
    x1O = rect.mX[1]  
    y1O = rect.mY[1]  
    x2O = rect.mX[2]  
    y2O = rect.mY[2]  
    x3O = rect.mX[3]  
    y3O = rect.mY[3] 

  rect.mX[0] = (centerX + (x0O * costheta - y0O * sintheta))
  rect.mY[0] = (centerY + (x0O * sintheta + (y0O) * costheta) * aspectRatio)
  rect.mX[1] = (centerX + (x1O * costheta - y1O * sintheta) )
  rect.mY[1] = (centerY + (x1O * sintheta + y1O * costheta)  * aspectRatio)
  rect.mX[2] = (centerX + (x2O * costheta - y2O * sintheta))
  rect.mY[2] = (centerY + (x2O * sintheta + y2O * costheta)  * aspectRatio)
  rect.mX[3] = (centerX + (x3O * costheta - y3O * sintheta))
  rect.mY[3] = (centerY + (x3O * sintheta + y3O * costheta)  * aspectRatio)

func translate(rect: var ActualGoodRectangle, x, y: float) {.inline.}= 
  rect.centerX += x
  rect.centerY += y

func translateX(rect: var ActualGoodRectangle, x: float) {.inline.}= 
  rect.centerX += x

func translateY(rect: var ActualGoodRectangle, y: float) {.inline.}= 
  rect.centerY += y


func rotateAtAngle(buffer: var TerminalBuffer1, rect: ActualGoodRectangle, angle, aspectRatio: float ) = 
  {.pragma: simd.}

  let 
    rad = rect.angle.degtorad
    centerX = rect.centerX 
    centerY = rect.centerY 
    sintheta = sin(rad)
    costheta = cos(rad)
    
    x0O = rect.sX[0]  
    y0O = rect.sY[0]  
    x1O = rect.sX[1]  
    y1O = rect.sY[1]  
    x2O = rect.sX[2]  
    y2O = rect.sY[2]  
    x3O = rect.sX[3]  
    y3O = rect.sY[3] 

    newX0 = (centerX + (x0O * costheta - y0O * sintheta))
    newY0 = (centerY + (x0O * sintheta + (y0O) * costheta) * aspectRatio)
    newX1 = (centerX + (x1O * costheta - y1O * sintheta) )
    newY1 = (centerY + (x1O * sintheta + y1O * costheta)  * aspectRatio)
    newX2 = (centerX + (x2O * costheta - y2O * sintheta))
    newY2 = (centerY + (x2O * sintheta + y2O * costheta)  * aspectRatio)
    newX3 = (centerX + (x3O * costheta - y3O * sintheta))
    newY3 = (centerY + (x3O * sintheta + y3O * costheta)  * aspectRatio)

 
    newX0Rounded = newX0.round().toInt()
    newY0Rounded = newY0.round().toInt()
    newX1Rounded = newX1.round().toInt()
    newY1Rounded = newY1.round().toInt()
    newX2Rounded = newX2.round().toInt()
    newY2Rounded = newY2.round().toInt()
    newX3Rounded = newX3.round().toInt()
    newY3Rounded = newY3.round().toInt()

   
    
  buffer.drawLine(newX0Rounded, newY0Rounded, newX1Rounded, newY1Rounded, dash, foregroundColor = RGB(0xffffff))
  buffer.drawLine(newX1Rounded, newY1Rounded, newX2Rounded, newY2Rounded, dash, foregroundColor = RGB(0xffffff))
  buffer.drawLine(newX2Rounded, newY2Rounded, newX3Rounded, newY3Rounded,dash, foregroundColor = RGB(0xffffff))
  buffer.drawLine(newX3Rounded, newY3Rounded, newX0Rounded, newY0Rounded, dash, foregroundColor = RGB(0xffffff))
 

func drawRect(buffer: var TerminalBuffer, rect: Rectangle) {.inline.} = 
  buffer.drawLine(rect.points[0].x.round().toInt(), rect.points[0].y.round().toInt(), rect.points[1].x.round().toInt(), rect.points[1].y.round().toInt(), Rune(0x2D))
  buffer.drawLine(rect.points[1].x.round().toInt(), rect.points[1].y.round().toInt(), rect.points[2].x.round().toInt(), rect.points[2].y.round().toInt(), Rune(0x2D))
  buffer.drawLine(rect.points[2].x.round().toInt(), rect.points[2].y.round().toInt(), rect.points[3].x.round().toInt(), rect.points[3].y.round().toInt(), Rune(0x2D))
  buffer.drawLine(rect.points[3].x.round().toInt(), rect.points[3].y.round().toInt(), rect.points[0].x.round().toInt(), rect.points[0].y.round().toInt(), Rune(0x2D))


func drawRect(buffer: var TerminalBuffer, rect: ActualGoodRectangle) {.inline.} = 
  {.pragma: simd.}

  let
    firstX = rect.sX[0].round().toInt()
    firsty = rect.sY[0].round().toInt()
    secondx = rect.sx[1].round().toInt()
    secondy = rect.sY[1].round().toInt()
    thirdx = rect.sx[2].round().toInt()
    thirdy = rect.sY[2].round().toInt() 
    fourthx = rect.sx[3].round().toInt()
    fourthy = rect.sY[3].round().toInt()

  buffer.drawLine(firstX, firsty, secondX, secondY, dash)
  buffer.drawLine(secondx, secondy, thirdx, thirdy, dash)
  buffer.drawLine( thirdx, thirdy, fourthx, fourthy,dash)
  buffer.drawLine(fourthx, fourthy, firstX, firsty, dash)

func drawRectNew(buffer: var TerminalBuffer, rect: ActualGoodRectangle) {.inline.} = 
  {.pragma: simd.}

  let
    firstX = rect.mX[0].round().toInt()
    firsty = rect.mY[0].round().toInt()
    secondx = rect.mx[1].round().toInt()
    secondy = rect.mY[1].round().toInt()
    thirdx = rect.mx[2].round().toInt()
    thirdy = rect.mY[2].round().toInt() 
    fourthx = rect.mx[3].round().toInt()
    fourthy = rect.mY[3].round().toInt()

  buffer.drawLine(firstX, firsty, secondX, secondY, dash)
  buffer.drawLine(secondx, secondy, thirdx, thirdy, dash)
  buffer.drawLine( thirdx, thirdy, fourthx, fourthy,dash)
  buffer.drawLine(fourthx, fourthy, firstX, firsty, dash)

func drawRectFixedIGuess(buffer: var TerminalBuffer, rect: ActualGoodRectangle, angle, aspectRatio: float) {.inline.} = 
  {.pragma: simd.}

  let
    firstX = rect.sX[0].round().toInt()
    firsty = rect.sY[0].round().toInt()
    secondx = rect.sx[1].round().toInt()
    secondy = rect.sY[1].round().toInt()
    thirdx = rect.sx[2].round().toInt()
    thirdy = rect.sY[2].round().toInt() 
    fourthx = rect.sx[3].round().toInt()
    fourthy = rect.sY[3].round().toInt()

  buffer.drawLineFixedIGuess(firstX, firsty, secondX, secondY, dash, angle, aspectRatio)
  buffer.drawLineFixedIGuess(secondx, secondy, thirdx, thirdy, dash, angle, aspectRatio)
  buffer.drawLineFixedIGuess( thirdx, thirdy, fourthx, fourthy,dash, angle, aspectRatio)
  buffer.drawLineFixedIGuess(fourthx, fourthy, firstX, firsty, dash, angle, aspectRatio)

func drawRectFixedInshallah(buffer: var TerminalBuffer, rect: ActualGoodRectangle, aspectRatio: float) {.inline.} = 
  {.pragma: simd.}

  let
    firstX = rect.sX[0]
    firsty = rect.sY[0]
    secondx = rect.sx[1]
    secondy = rect.sY[1]
    thirdx = rect.sx[2]
    thirdy = rect.sY[2]
    fourthx = rect.sx[3]
    fourthy = rect.sY[3]

  buffer.drawLineAspectCorrected(x0=firstX, y0=firsty, x1=secondX, y1=secondY, ch=dash, aspectRatio=aspectRatio)
  buffer.drawLineAspectCorrected(x0=secondx, y0=secondy, x1=thirdx, y1=thirdy, ch=dash, aspectRatio=aspectRatio)
  buffer.drawLineAspectCorrected(x0=thirdx, y0=thirdy, x1=fourthx, y1=fourthy, ch=dash, aspectRatio=aspectRatio)
  buffer.drawLineAspectCorrected(x0=fourthx, y0=fourthy, x1=firstX, y1=firsty, ch=dash, aspectRatio=aspectRatio)
#  buffer.drawLineFixedIGuess(secondx, secondy, thirdx, thirdy, dash, angle, aspectRatio)
#  buffer.drawLineFixedIGuess( thirdx, thirdy, fourthx, fourthy,dash, angle, aspectRatio)
#  buffer.drawLineFixedIGuess(fourthx, fourthy, firstX, firsty, dash, angle, aspectRatio)

func drawRectFixedInshallahHopium(buffer: var TerminalBuffer, rect: ActualGoodRectangle, aspectRatio: float) {.inline.} = 
  {.pragma: simd.}

  let
    firstX = rect.sX[0]
    firsty = rect.sY[0]
    secondx = rect.sx[1]
    secondy = rect.sY[1]
    thirdx = rect.sx[2]
    thirdy = rect.sY[2]
    fourthx = rect.sx[3]
    fourthy = rect.sY[3]

  buffer.drawLineAspectCorrected1(x0=firstX, y0=firsty, x1=secondX, y1=secondY, ch=dash, aspectRatio=aspectRatio)
  buffer.drawLineAspectCorrected1(x0=secondx, y0=secondy, x1=thirdx, y1=thirdy, ch=dash, aspectRatio=aspectRatio)
  buffer.drawLineAspectCorrected1(x0=thirdx, y0=thirdy, x1=fourthx, y1=fourthy, ch=dash, aspectRatio=aspectRatio)
  buffer.drawLineAspectCorrected1(x0=fourthx, y0=fourthy, x1=firstX, y1=firsty, ch=dash, aspectRatio=aspectRatio)
#  buffer.drawLineFixedIGuess(secondx, secondy, thirdx, thirdy, dash, angle, aspectRatio)
#  buffer.drawLineFixedIGuess( thirdx, thirdy, fourthx, fourthy,dash, angle, aspectRatio)
#  buffer.drawLineFixedIGuess(fourthx, fourthy, firstX, firsty, dash, angle, aspectRatio)

func scaleUpAndDown(rect: var ActualGoodRectangle, scalar: float32) {.inline.} =
  if rect.animationProgression == 1:
    rect.up = not rect.up
  {.pragma: simd.}
  let current = easeInOut(rect.animationProgression)
  rect.mX[0] = rect.sX[0] - scalar * current
  rect.mX[1] = rect.sX[1] + scalar * current
  rect.mX[2] = rect.sX[2] + scalar * current
  rect.mX[3] = rect.sX[3] - scalar * current  
  rect.animationProgression += 0.01 mod 1.01
    #stdout.write("\e[50;0H " & $(scalar * rect.animationProgression))
    #stdout.write("\e[50;0H " & $(scalar * rect.animationProgression))

proc main() =
  stdout.hideCursor
  defer: stdout.showCursor

  stdout.write("\e[2J")
  let
    s = terminalSize()
  var rect = newActualRectangle(s.w / 2, s.h / 2, 20 , 20)
  let 
    startTime = cpuTime()
  var buffer = newTerminalBuffer(s.w, s.h)
  #rect.angle = 1.float
  let xO = rect.centerX
  while true:
    #buffer.drawRectFixedInshallahHopium(rect, 1.8691588785)

    #rect.reset()
    #rect.scaleUpAndDown(5)
    #rect.centerX = xO + easeInOut(rect.animationProgression) * (buffer.width.float - 40)
#    rect.rotate(rect.angle, 0.535)

    buffer.drawRect(rect, 0.535)
    rect.rotate(1)
#    buffer.drawRectNew(rect)
    buffer.display()
    buffer.clean()
    let endTime = cpuTime()
    if  endTime - startTime >= 10:
      break
    #rect.angle = (rect.angle + 1) mod 360
    #sleep 16
    sleep 1

proc main1() =
  stdout.hideCursor
  defer: stdout.showCursor

  stdout.write("\e[2J")
  let
    s = terminalSize()
  var rect = newActualRectangle(s.w / 2, s.h / 2, 20 , 20)
  let 
    startTime = cpuTime()
  var buffer = newTerminalBuffer1(s.w, s.h)
  rect.angle = 1
  while true:
    #buffer.drawRectFixedInshallahHopium(rect, 1.8691588785)

    rotateAtAngle(buffer, rect,rect.angle, 0.535)
    buffer.display()
    buffer.clean()
    let endTime = cpuTime()
    if  endTime - startTime >= 10:
      break
    rect.angle = (rect.angle + 1) mod 360
    #sleep 30

proc mainClean() =
  stdout.hideCursor
  defer: stdout.showCursor

  stdout.write("\e[2J")
  let
    s = terminalSize()
  var rect = newActualRectangle(s.w / 2, s.h / 2, 20 , 20)
  let 
    startTime = cpuTime()
  var buffer = newTerminalBuffer(s.w, s.h)
  rect.angle = 1
  while true:
    #buffer.drawRectFixedInshallahHopium(rect, 1.8691588785)

    drawRectClean(buffer, rect, 0.535)
    #buffer.display()
    let endTime = cpuTime()
    #sleep 1
    buffer.cleanClean()

    if  endTime - startTime >= 10:
      break
    rect.angle = (rect.angle + 1) mod 360
    #sleep 30
 


mainClean()

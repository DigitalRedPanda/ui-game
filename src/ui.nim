import ui/ui, terminal, os, std/syncio, rdstdin, bitops, math, random, times, unicode, game/entity, strutils

func drawTab(buffer: var TerminalBuffer, x,y: int, content: string, borderColor = (255,255,255), textColor = (255,255,255), padding: Natural) =
  buffer.drawRect(x,y, x + content.len + padding + 1, y + padding, borderColor)
  buffer.write((x + padding), y + (padding shr 1), content, textColor)

    
#var character: Channel[char]

#proc getchWithTimeout(ms: Natural): char = 
#  var 
#    thread: Thread[void]
#  proc sendStdinInput() {.thread.} =
#    let txt = getch()
#    character.send txt
#  createThread(thread, sendStdinInput)
#  sleep ms
#  var recvChar = character.tryRecv()
#  if recvChar.dataAvailable:
#    return recvChar.msg
#  else:
#    #addr(thread).dealloc
#    return '\0'


proc main1() = 
  stdout.write("\e[?1049h\e[?25l\e[s\e[?47h\e[2J")
  setControlCHook(proc () {.noconv.} =  
    stdout.write("\e[?25h\e[?47l\e[u\e[?1049l")
    deinitUi()
    quit(0)
    )
  defer: 
    stdout.write("\e[?25h\e[?47l\e[u\e[?1049l")
    deinitUi()
  const channels = ["CopyNine", "Suppakaizou", "BessBosss", "SoulSev", "ma7dev",  "SadMadLadSalman", "laptop_battery", "Zaaatar", "abu_daa"]
  var 
    text: seq[Rune]
  initUi()
  randomize()
  var currentWidth = 0
  let b = terminalSize()
  var bibliothecas = newSeq[tuple[x1,y1,x2,y2: int, color: RGB]]()
  while currentWidth < b.w - 2:
    let rnd = rand(1..30)
    bibliothecas.add((currentWidth, b.h - rnd - 1,currentWidth + 2,b.h - 1 , blue))
    currentWidth += rnd + 2
  var entity = Object()
  while true:
#    circle.directionY = DOWN
#    circle.accelerating = true
#    circle.acceleration = 0.25
    
    let 
      size = terminalSize()
      quarterSize = (height:size.h shr 2, width:size.w shr 2)
      halfSize = (width:size.w shr 1, height: size.h shr 1)
      startTime = epochTime()
    var 
      s = newTerminalBuffer(size.w, size.h)
      totalWidth = 0
      totalHeight = 0
    #echo "󰏤"
    #echo "deadlole"
   
    s.drawRect((halfSize.width) - quarterSize.width, (halfSize.height) - quarterSize.height, (halfSize.width) + quarterSize.width, (halfSize.height) + quarterSize.height,(169,27,13))
    for i in channels:
      if totalWidth + i.len + 2 * 2 >= size.w:
        totalWidth = 0
        totalHeight += 3
      s.drawTab(totalWidth + 1,totalHeight + 1, i, grey, white, 2)
      totalWidth += i.len + 2 * 2
    let temp = getKeyAsync(7)
    if temp != None:
      case temp:
        of Escape:
          stdout.write("\e[2J\e[0;0H[\e[32mINFO\e[0m]exiting...")
          break
        of Backspace:
          if text.len > 0:
            text = text[0..<text.len-1]
        of Enter:
          case $(text):
            of "right":
              entity.directionX = RIGHT
              entity.directionY = 0
              entity.accelerating = true
              entity.moving = true

            of "left":
              entity.directionX = LEFT
              entity.directionY = 0
              entity.accelerating = true
              entity.moving = true
            of "up":
              entity.directionY = UP
              entity.directionX = 0
              entity.accelerating = true
              entity.moving = true
            of "down":
              entity.directionY = DOWN
              entity.directionX = 0
              entity.moving = true
              entity.accelerating = true
            of "stop":
              entity.directionX = STILL
              entity.directionY = STILL
              entity.accelerating = false
              entity.moving = false
              entity.speed = (0, 0)
              
            else: discard 
          text = @[]
        else: 
          text.add temp.Rune
    let endTime = epochTime()
    #s.write(1, 1, $( 1 / ((endTime - startTime))))
    entity.move(endTime - startTime)
    s.drawTab(halfSize.width, 4, $text, padding=2)
    s.write(entity.x.floor.toInt, entity.y.floor.toInt, "x")
    #stdout.write("\e[28m")
    #stdout.flushFile()
    s.display
    #stdout.write("\e[8m")
    #stdout.flushFile()

proc main() = 
  stdout.write("\e[?1049h\e[?25l\e[s\e[?47h\e[2J")
  initUi()
  #stdout.writeLine("could not connnect to main channel; \e[48;5;234m\e[38;5;240m`\e[38;5;250mjoin channel\e[38;5;240m`\e[0m assertion failed")
  stdout.flushFile()
  defer:
    deinitUi()
    stdout.write("\e[?25h\e[?47l\e[u\e[?1049l\e[28m")
    stdout.flushFile()
  while true:
    discard
  discard

main1()

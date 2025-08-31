# This is just an example to get you started. Users of your library will
# import this file by writing ``import ui/submodule``. Feel free to rename or
# remove this file altogether. You may create additional modules alongside
# this file as required.
import macros, os, terminal, unicode, bitops, strformat, math, posix, termios, times, std/algorithm
import posix, tables, termios
from posix import Time
import strutils, strformat,times, cpuinfo
import threadpool



type  Key* {.pure.} = enum      ## Supported single key presses and key combinations
    None = (-1, "None"),

    # Special ASCII characters
    CtrlA  = (1, "CtrlA"),
    CtrlB  = (2, "CtrlB"),
    CtrlC  = (3, "CtrlC"),
    CtrlD  = (4, "CtrlD"),
    CtrlE  = (5, "CtrlE"),
    CtrlF  = (6, "CtrlF"),
    CtrlG  = (7, "CtrlG"),
    CtrlH  = (8, "CtrlH"),
    Tab    = (9, "Tab"),     # Ctrl-I
    CtrlJ  = (10, "CtrlJ"),
    CtrlK  = (11, "CtrlK"),
    CtrlL  = (12, "CtrlL"),
    Enter  = (13, "Enter"),  # Ctrl-M
    CtrlN  = (14, "CtrlN"),
    CtrlO  = (15, "CtrlO"),
    CtrlP  = (16, "CtrlP"),
    CtrlQ  = (17, "CtrlQ"),
    CtrlR  = (18, "CtrlR"),
    CtrlS  = (19, "CtrlS"),
    CtrlT  = (20, "CtrlT"),
    CtrlU  = (21, "CtrlU"),
    CtrlV  = (22, "CtrlV"),
    CtrlW  = (23, "CtrlW"),
    CtrlX  = (24, "CtrlX"),
    CtrlY  = (25, "CtrlY"),
    CtrlZ  = (26, "CtrlZ"),
    Escape = (27, "Escape"),

    CtrlBackslash    = (28, "CtrlBackslash"),
    CtrlRightBracket = (29, "CtrlRightBracket"),

    # Printable ASCII characters
    Space           = (32, "Space"),
    ExclamationMark = (33, "ExclamationMark"),
    DoubleQuote     = (34, "DoubleQuote"),
    Hash            = (35, "Hash"),
    Dollar          = (36, "Dollar"),
    Percent         = (37, "Percent"),
    Ampersand       = (38, "Ampersand"),
    SingleQuote     = (39, "SingleQuote"),
    LeftParen       = (40, "LeftParen"),
    RightParen      = (41, "RightParen"),
    Asterisk        = (42, "Asterisk"),
    Plus            = (43, "Plus"),
    Comma           = (44, "Comma"),
    Minus           = (45, "Minus"),
    Dot             = (46, "Dot"),
    Slash           = (47, "Slash"),

    Zero  = (48, "Zero"),
    One   = (49, "One"),
    Two   = (50, "Two"),
    Three = (51, "Three"),
    Four  = (52, "Four"),
    Five  = (53, "Five"),
    Six   = (54, "Six"),
    Seven = (55, "Seven"),
    Eight = (56, "Eight"),
    Nine  = (57, "Nine"),

    Colon        = (58, "Colon"),
    Semicolon    = (59, "Semicolon"),
    LessThan     = (60, "LessThan"),
    Equals       = (61, "Equals"),
    GreaterThan  = (62, "GreaterThan"),
    QuestionMark = (63, "QuestionMark"),
    At           = (64, "At"),

    ShiftA  = (65, "ShiftA"),
    ShiftB  = (66, "ShiftB"),
    ShiftC  = (67, "ShiftC"),
    ShiftD  = (68, "ShiftD"),
    ShiftE  = (69, "ShiftE"),
    ShiftF  = (70, "ShiftF"),
    ShiftG  = (71, "ShiftG"),
    ShiftH  = (72, "ShiftH"),
    ShiftI  = (73, "ShiftI"),
    ShiftJ  = (74, "ShiftJ"),
    ShiftK  = (75, "ShiftK"),
    ShiftL  = (76, "ShiftL"),
    ShiftM  = (77, "ShiftM"),
    ShiftN  = (78, "ShiftN"),
    ShiftO  = (79, "ShiftO"),
    ShiftP  = (80, "ShiftP"),
    ShiftQ  = (81, "ShiftQ"),
    ShiftR  = (82, "ShiftR"),
    ShiftS  = (83, "ShiftS"),
    ShiftT  = (84, "ShiftT"),
    ShiftU  = (85, "ShiftU"),
    ShiftV  = (86, "ShiftV"),
    ShiftW  = (87, "ShiftW"),
    ShiftX  = (88, "ShiftX"),
    ShiftY  = (89, "ShiftY"),
    ShiftZ  = (90, "ShiftZ"),

    LeftBracket  = (91, "LeftBracket"),
    Backslash    = (92, "Backslash"),
    RightBracket = (93, "RightBracket"),
    Caret        = (94, "Caret"),
    Underscore   = (95, "Underscore"),
    GraveAccent  = (96, "GraveAccent"),

    A = (97, "A"),
    B = (98, "B"),
    C = (99, "C"),
    D = (100, "D"),
    E = (101, "E"),
    F = (102, "F"),
    G = (103, "G"),
    H = (104, "H"),
    I = (105, "I"),
    J = (106, "J"),
    K = (107, "K"),
    L = (108, "L"),
    M = (109, "M"),
    N = (110, "N"),
    O = (111, "O"),
    P = (112, "P"),
    Q = (113, "Q"),
    R = (114, "R"),
    S = (115, "S"),
    T = (116, "T"),
    U = (117, "U"),
    V = (118, "V"),
    W = (119, "W"),
    X = (120, "X"),
    Y = (121, "Y"),
    Z = (122, "Z"),

    LeftBrace  = (123, "LeftBrace"),
    Pipe       = (124, "Pipe"),
    RightBrace = (125, "RightBrace"),
    Tilde      = (126, "Tilde"),
    Backspace  = (127, "Backspace"),

    # Special characters with virtual keycodes
    Up       = (1001, "Up"),
    Down     = (1002, "Down"),
    Right    = (1003, "Right"),
    Left     = (1004, "Left"),
    Home     = (1005, "Home"),
    Insert   = (1006, "Insert"),
    Delete   = (1007, "Delete"),
    End      = (1008, "End"),
    PageUp   = (1009, "PageUp"),
    PageDown = (1010, "PageDown"),

    F1  = (1011, "F1"),
    F2  = (1012, "F2"),
    F3  = (1013, "F3"),
    F4  = (1014, "F4"),
    F5  = (1015, "F5"),
    F6  = (1016, "F6"),
    F7  = (1017, "F7"),
    F8  = (1018, "F8"),
    F9  = (1019, "F9"),
    F10 = (1020, "F10"),
    F11 = (1021, "F11"),
    F12 = (1022, "F12"),

    Mouse = (5000, "Mouse")
type
  RGB* = distinct uint32
const 
  white* = RGB(0xFFFFFF)
  black* = RGB(0x000000)
  blue* = RGB(0x003E7B)
  grey* = RGB(0x7B7B7B )

type 
  TerminalBuffer* = object
    width*, height*: int
    bufferChar*: seq[Rune]
    bufferForegroundColor*: seq[RGB]
    bufferBackgroundColor*: seq[RGB]
    #currentColor*: RGB
  TerminalChar* = object 
    character*: Rune
    foregroundColor* = white
    backgroundColor* = black
  TerminalBuffer1* = object 
    width*, height*: int
    buffer*: seq[TerminalChar]

const 
  reset* = "\e[0m"

proc nonblock(enabled: bool) =
  var ttyState: Termios

  # get the terminal state
  discard tcGetAttr(STDIN_FILENO, ttyState.addr)

  if enabled:
    # turn off canonical mode & echo
    ttyState.c_lflag = ttyState.c_lflag and not Cflag(ICANON or ECHO)

    # minimum of number input read
    ttyState.c_cc[VMIN] = 0.char

  else:
    # turn on canonical mode & echo
    ttyState.c_lflag = ttyState.c_lflag or ICANON or ECHO

  # set the terminal attributes.
  discard tcSetAttr(STDIN_FILENO, TCSANOW, ttyState.addr)

func toKey(c: int): Key =
  try:
    result = Key(c)
  except RangeDefect:  # ignore unknown keycodes
    result = Key.None
proc initUi*() = 
  nonblock(true)


func newTerminalBuffer*(width, height: int): TerminalBuffer = 
  let size = width * height
  result = TerminalBuffer(width:width, height:height, bufferChar:newSeqOfCap[Rune](size), bufferForegroundColor:newSeq[RGB](size), bufferBackgroundColor:newSeq[RGB](size))

func newTerminalBuffer1*(width, height: int): TerminalBuffer1 = 
  let size = width * height
  result = TerminalBuffer1(width:width, height:height, buffer:newSeqOfCap[TerminalChar](size))

proc deinitUi*() = 
  nonblock(false)

func write*(buffer: var TerminalBuffer, x,y: int, content: string, color = white) =
  let runes = content.toRunes
  for i in 0..<content.len:
    let currentIndex = y * buffer.width + x + i
    buffer.bufferChar[currentIndex] = runes[i] 
    buffer.bufferForegroundColor[currentIndex] = color

func drawRect*(buffer: var TerminalBuffer, x1,y1,x2,y2: int, foregroundColor = white) =
  buffer.bufferChar[y1 * buffer.width + x1] = Rune(0x250C)
  buffer.bufferChar[y1 * buffer.width + x2] = Rune(0x2510)
  buffer.bufferChar[y2 * buffer.width + x1] = Rune(0x2514)
  buffer.bufferChar[y2 * buffer.width + x2] = Rune(0x2518)
  for i in x1+1..<x2: 
    buffer.bufferChar[y1 * buffer.width + i] = Rune(0x2500)
    buffer.bufferChar[y2 * buffer.width + i] = Rune(0x2500)
  for i in y1+1..<y2:
    buffer.bufferChar[i * buffer.width + x1] = Rune(0x2502)
    buffer.bufferChar[i * buffer.width + x2] = Rune(0x2502)

func drawCircle*(buffer:  var TerminalBuffer, x1,y1: int, radius: float, foregroundColor = white) =
  let circumference = radius * TAU
  for i in 0..<circumference.toInt():
    let 
      x = ((radius * 2) * cos((i.toFloat() * TAU) / circumference)).toInt + x1
      y = (radius * sin((i.toFloat() * TAU) / circumference)).toInt + y1
    buffer.bufferChar[y * buffer.width + x] = Rune(0x2E)
const 
  zeroRune = Rune(0)
  spaceRune = Rune(0x20)

proc clean*(buffer: var TerminalBuffer) = 
  let total = buffer.width * buffer.height
  {.pragma: simd.}
  buffer.bufferChar.fill(0, total - 1, spaceRune)
  buffer.bufferForegroundColor.fill(0, total - 1, white)
  buffer.bufferBackgroundColor.fill(0, total  - 1, black)
  #buffer.outputBuffer.setLen(0)

proc cleanClean*(buffer: var TerminalBuffer) = 
#  let total = buffer.width * buffer.height
#  {.pragma: simd.}
#  buffer.bufferChar.fill(0, total - 1, spaceRune)
#  buffer.bufferForegroundColor.fill(0, total - 1, white)
#  buffer.bufferBackgroundColor.fill(0, total  - 1, black)
  stdout.write("\e[0;0H\e[2J")
  stdout.flushFile
  #buffer.outputBuffer.setLen(0)



proc clean*(buffer: var TerminalBuffer1) = 
  let 
    total = buffer.width * buffer.height
    char = TerminalChar(character:spaceRune)
  {.pragma: simd.}
  buffer.buffer.fill(0, total - 1, char)
  #buffer.outputBuffer.setLen(0)


proc cleanStuff(buffer: var TerminalBuffer, startIndex, endIndex: int) {.thread, inline.} = 
  {.simd.}
  let
    black = black
    white = white
  buffer.bufferChar.fill(startIndex, endIndex - 1, spaceRune)
  buffer.bufferForegroundColor.fill(startIndex, endIndex - 1, white)
  buffer.bufferBackgroundColor.fill(startIndex, endIndex  - 1, black)
  
  discard
{.experimental.}
proc cleanParallel*(buffer: var TerminalBuffer) = 
  {.pragma: simd.}
  let 
    total = buffer.width * buffer.height
#    black = black
#    white = white
    cores = 2
    chunk = total div 3 
  parallel:
    for i in 0..<cores:
      
      spawn cleanStuff(buffer, i * chunk, chunk + (i * chunk))
#    buffer.bufferChar[i] = spaceRune
#    buffer.bufferForegroundColor[i] = white
#    buffer.bufferBackgroundColor[i] = black
#  {.pragma: simd.}
#  buffer.bufferChar.fill(0, total - 1, spaceRune)
#  buffer.bufferForegroundColor.fill(0, total - 1, white)
#  buffer.bufferBackgroundColor.fill(0, total  - 1, black)
#  buffer.outputBuffer.setLen(0)



{.emit: """#include <unistd.h>""".}
proc sys_write(fd: cint, buf: pointer, count: csize): cint {.importc: "write", header: "<unistd.h>".}

proc display*(buffer: var TerminalBuffer)    = 
    stdout.write("\e[H")
    let total = buffer.width * buffer.height
    for i in 0..<total:

      {.pragma: simd.}
      let 
        temp = buffer.bufferChar[i]    
        color = buffer.bufferForegroundColor[i]
        r = ((color.uint32 shr 16) and 0xFF).uint8
        g = ((color.uint32 shr 8) and 0xFF).uint8
        b = (color.uint32  and 0xFF).uint8

      stdout.write(&"\e[38;2;{r};{g};{b}m{temp}")
    stdout.write("\e[0m")
    stdout.flushFile 

proc display*(buffer: var TerminalBuffer1)    = 
    stdout.write("\e[H")
    let total = buffer.width * buffer.height
    for i in 0..<total:
      {.pragma: simd.}
      let 
        temp = buffer.buffer[i]    
        color = temp.foregroundColor
        r = ((color.uint32 shr 16) and 0xFF).uint8
        g = ((color.uint32 shr 8) and 0xFF).uint8
        b = (color.uint32  and 0xFF).uint8

      stdout.write(&"\e[38;2;{r};{g};{b}m{temp.character}")
    stdout.write("\e[0m")
    stdout.flushFile 



#proc displayFast*(buffer: var TerminalBuffer) =
#  # Precompute all positions and colors first
#  var output = buffer.outputBuffer
#  for i in 0..<buffer.height:
#    let rowStart = i * buffer.width
#
#    output.add(&"\e[{$ (i+1)};1H") # Move to row start once per row
#
#    for j in 0..<buffer.width:
#      let currentIndex = rowStart + j
#      let temp = buffer.bufferChar[currentIndex]
#      let color = buffer.bufferForegroundColor[currentIndex]
#      let r = ((color.uint32 shr 16) and 0xFF).uint8
#      let g = ((color.uint32 shr 8) and 0xFF).uint8
#      let b = (color.uint32 and 0xFF).uint8
#
#      output.add(&"\e[38;2;{r};{g};{b}m{temp}")
#
#  output.add("\e[0m")
#  stdout.write(output)
#  stdout.flushFile()
func clear*(buffer: var TerminalBuffer) = 
  buffer.bufferChar = newSeq[Rune](buffer.width * buffer.height)
  buffer.bufferForegroundColor = newSeq[RGB](buffer.width * buffer.height)
  buffer.bufferBackgroundColor = newSeq[RGB](buffer.width * buffer.height)
const
  CSI = 0x1B.chr & 0x5B.chr
  SET_BTN_EVENT_MOUSE = "1002"
  SET_ANY_EVENT_MOUSE = "1003"
  SET_SGR_EXT_MODE_MOUSE = "1006"
  # SET_URXVT_EXT_MODE_MOUSE = "1015"
  ENABLE = "h"
  DISABLE = "l"
  MouseTrackAny = fmt"{CSI}?{SET_BTN_EVENT_MOUSE}{ENABLE}{CSI}?{SET_ANY_EVENT_MOUSE}{ENABLE}{CSI}?{SET_SGR_EXT_MODE_MOUSE}{ENABLE}"
  DisableMouseTrackAny = fmt"{CSI}?{SET_BTN_EVENT_MOUSE}{DISABLE}{CSI}?{SET_ANY_EVENT_MOUSE}{DISABLE}{CSI}?{SET_SGR_EXT_MODE_MOUSE}{DISABLE}"
  KEYS_D = [Key.Up, Key.Down, Key.Right, Key.Left, Key.None, Key.End, Key.None, Key.Home]
  KEYS_E = [Key.Delete, Key.End, Key.PageUp, Key.PageDown, Key.Home, Key.End]
  KEYS_F = [Key.F1, Key.F2, Key.F3, Key.F4, Key.F5, Key.None, Key.F6, Key.F7, Key.F8]
  KEYS_G = [Key.F9, Key.F10, Key.None, Key.F11, Key.F12]
proc parseStdin[T](input: T): Key =
    var ch1, ch2, ch3, ch4, ch5: char
    result = Key.None
    if read(input, ch1.addr, 1) > 0:
      case ch1
      of '\e':
        if read(input, ch2.addr, 1) > 0:
          if ch2 == 'O' and read(input, ch3.addr, 1) > 0:
            if ch3 in "ABCDFH":
              result = KEYS_D[int(ch3) - int('A')]
            elif ch3 in "PQRS":
              result = KEYS_F[int(ch3) - int('P')]
          elif ch2 == '[' and read(input, ch3.addr, 1) > 0:
            if ch3 in "ABCDFH":
              result = KEYS_D[int(ch3) - int('A')]
            elif ch3 in "PQRS":
              result = KEYS_F[int(ch3) - int('P')]
            elif ch3 == '1' and read(input, ch4.addr, 1) > 0:
              if ch4 == '~':
                result = Key.Home
              elif ch4 in "12345789" and read(input, ch5.addr, 1) > 0 and ch5 == '~':
                result = KEYS_F[int(ch4) - int('1')]
            elif ch3 == '2' and read(input, ch4.addr, 1) > 0:
              if ch4 == '~':
                result = Key.Insert
              elif ch4 in "0134" and read(input, ch5.addr, 1) > 0 and ch5 == '~':
                result = KEYS_G[int(ch4) - int('0')]
            elif ch3 in "345678" and read(input, ch4.addr, 1) > 0 and ch4 == '~':
              result = KEYS_E[int(ch3) - int('3')]
            else:
              discard   # if cannot parse full seq it is discarded
          else:
            discard     # if cannot parse full seq it is discarded
        else:
          result = Key.Escape
      of '\n':
        result = Key.Enter
      of '\b':
        result = Key.Backspace
      else:
        result = toKey(int(ch1))

proc kbhit(ms: int): cint =
  var tv: Timeval
  tv.tv_sec = posix.Time(ms div 1000)
  tv.tv_usec = 1000 * (int32(ms) mod 1000) # int32 because of macos
  var fds: TFdSet
  FD_ZERO(fds)
  FD_SET(STDIN_FILENO, fds)
  discard select(STDIN_FILENO+1, fds.addr, nil, nil, tv.addr)
  return FD_ISSET(STDIN_FILENO, fds)


proc getKeyAsync*(ms: int): Key =
  result = Key.None
  if kbhit(ms) > 0:
    result = parseStdin(cint(STDIN_FILENO))
proc drawLine*(buffer:  var TerminalBuffer, x0,y0,x1,y1: int, ch: Rune, foregroundColor = white, backgroundColor = black) =
  var
    x0 = x0
    y0 = y0
    x1 = x1
    y1 = y1
  
  let 
    width = buffer.width
    dx = abs(x1 - x0)
    dy = abs(y1 - y0)
    sx = if x0 < x1: 1 else: -1
    sy = if y0 < y1: 1 else: -1
  var err = dx - dy
  
  
  while true:
    let index = width * y0 + x0
    buffer.bufferChar[index] = ch
    buffer.bufferForegroundColor[index] = foregroundColor
    buffer.bufferBackgroundColor[index] = backgroundColor 
    let 
      r = ((foregroundColor.uint32 shr 16) and 0xFF).uint8
      g = ((foregroundColor.uint32 shr 8) and 0xFF).uint8
      b = (foregroundColor.uint32  and 0xFF).uint8

    #stdout.write(fmt"\e[{y0};{x0}H\e[48;2;{r};{g};{b}m\e[38;2;{r}{g}{b}m{ch}\e[0m")
    if x0 == x1 and y0 == y1:
      break
    let e2 = 2 * err
    if e2 > -dy:
      err -= dy
      x0 += sx
    if e2 < dx:
      err += dx
      y0 += sy

proc drawLine*(buffer:  var TerminalBuffer1, x0,y0,x1,y1: int, ch: Rune, foregroundColor = white, backgroundColor = black) =
  var
    x0 = x0
    y0 = y0
    x1 = x1
    y1 = y1
  
  let 
    width = buffer.width
    dx = abs(x1 - x0)
    dy = abs(y1 - y0)
    sx = if x0 < x1: 1 else: -1
    sy = if y0 < y1: 1 else: -1
  var err = dx - dy
  
  
  while true:
    let index = width * y0 + x0
#    buffer.bufferChar[index] = ch
#    buffer.bufferForegroundColor[index] = foregroundColor
#    buffer.bufferBackgroundColor[index] = backgroundColor 
    buffer.buffer[index] = TerminalChar(character:ch, foregroundColor:foregroundColor, backGroundColor:backGroundColor)
    if x0 == x1 and y0 == y1:
      break
    let e2 = 2 * err
    if e2 > -dy:
      err -= dy
      x0 += sx
    if e2 < dx:
      err += dx
      y0 += sy


proc drawLineClean*(buffer:  var TerminalBuffer, x0,y0,x1,y1: int, ch: Rune, foregroundColor = white, backgroundColor = black) =
  var
    x0 = x0
    y0 = y0
    x1 = x1
    y1 = y1
  
  let 
    #width = buffer.width
    dx = abs(x1 - x0)
    dy = abs(y1 - y0)
    sx = if x0 < x1: 1 else: -1
    sy = if y0 < y1: 1 else: -1
  var err = dx - dy
  
  
  while true:
    let
      #index = width * y0 + x0
      fR = ((foregroundColor.uint32 shr 16) and 0xFF).uint8
      fG = ((foregroundColor.uint32 shr 8) and 0xFF).uint8
      fB = (foregroundColor.uint32  and 0xFF).uint8
      bR = ((backgroundColor.uint32 shr 16) and 0xFF).uint8
      bG = ((backgroundColor.uint32 shr 8) and 0xFF).uint8
      bB = (backgroundColor.uint32  and 0xFF).uint8
    stdout.write(&"\e[{y0};{x0}H\e[38;2;{fR}{fG}{fB}m{ch}\e[0m")

#    buffer.bufferChar[index] = ch
#    buffer.bufferForegroundColor[index] = foregroundColor
#    buffer.bufferBackgroundColor[index] = backgroundColor 
    if x0 == x1 and y0 == y1:
      break
    let e2 = 2 * err
    if e2 > -dy:
      err -= dy
      x0 += sx
    if e2 < dx:
      err += dx
      y0 += sy

  stdout.flushFile


func drawLineFixedIGuess*(buffer: var TerminalBuffer, x0,y0,x1,y1: int, ch: Rune, angle, aspectRatio: float, foregroundColor = white, backgroundColor = black) = 
  let 
    width = buffer.width
    height = buffer.height
    angleRad = arctan(tan(angle.degToRad) * aspectRatio)
    dx = cos(angleRad) 
    dy = sin(angleRad) / aspectRatio
    maxLength = sqrt(float(width * width) + float(height * height) / (aspectRatio * aspectRatio))
  
  # Calculate start and end points centered in the grid
  let centerX = width / 2
  let centerY = height / 2
  let startX = centerX - dx * maxLength / 2
  let startY = centerY - dy * maxLength / 2
  let endX = centerX + dx * maxLength / 2
  let endY = centerY + dy * maxLength / 2
  
  # Bresenham's line algorithm with aspect ratio correction
  var
    x0 = round(startX).int
    y0 = round(startY).int
    x1 = round(endX).int
    y1 = round(endY).int
  
  let
    dxVal = abs(x1 - x0)
    dyVal = abs(y1 - y0)
    sx = if x0 < x1: 1 else: -1
    sy = if y0 < y1: 1 else: -1
  var err = dxVal - dyVal
  
  while true:
    if x0 >= 0 and x0 < width and y0 >= 0 and y0 < height:
      buffer.bufferChar[width * y0 + x0] = ch
    
    if x0 == x1 and y0 == y1:
      break
    
    let e2 = 2 * err
    if e2 > -dyVal:
      err -= dyVal
      x0 += sx
    if e2 < dxVal:
      err += dxVal
      y0 += sy

func lerp(a, b, t: float): float {.inline.} = a + (b - a) * t

proc drawLineAspectCorrected*(buffer: var TerminalBuffer, x0, y0, x1, y1: float, ch: Rune, foregroundColor = white, backgroundColor = black, aspectRatio: float) =

  {.pragma: simd.}
  let
    # Normalize for aspect ratio
    nx0 = x0
    ny0 = y0 
    nx1 = x1
    ny1 = y1 

    dx = nx1 - nx0
    dy = ny1 - ny0
    steps = max(abs(dx), abs(dy)).int
  {.pragma: simd.}
  for i in 0..steps:
    let
      t = float(i) / float(steps)
      x = lerp(nx0, nx1, t)
      y = lerp(ny0, ny1, t) / aspectRatio  # De-normalize Y
      currentIndex  = round(y).int * buffer.width + round(x).int
    buffer.bufferChar[currentIndex] = ch
    buffer.bufferForegroundColor[currentIndex] = foregroundColor
    buffer.bufferBackgroundColor[currentIndex] = backgroundColor 
# func drawLineO*(buffer: var TerminalBuffer, x0,y0,x1,y1: int, ch: string, foregroundColor = white, backgroundColor = black) =
#   var 
#     x0 = x0  
#     x1 = x1 
#     y0 = y0 
#     y1 = y1 
#   let
#     dx = x1 - x0
#     dy = y1 - y0
#   var
#     D = 2*dy - dx
#     y = y0
#   for x in x0..x1:
#     buffer.buffer[y * buffer.width + x] = TerminalChar(character:ch, foregroundColor:foregroundColor, backgroundColor:backgroundColor)
#     if D > 0:
#       y += 1
#       D -= 2 * dx
#     D += 2 * dy

proc drawLineAspectCorrected1*(
  buffer: var TerminalBuffer,
  x0, y0, x1, y1: float,
  ch: Rune, 
  foregroundColor = white, backgroundColor = black,
  aspectRatio: float
) =

  {.pragma: simd.}
  let
    # Normalize for aspect ratio
    startX = x0
    startY = y0 
    endX   = x1
    endY   = y1

    dx = endX - startX
    dy = endY - startY
    steps = max(abs(dx), abs(dy)).int

    stepX = dx / float(steps)
    stepY = dy / float(steps)

  var
    x = startX
    y = startY

  for _ in 0 .. steps:
    {.pragma: simd.}
    let
      drawX = round(x).int
      drawY = round(y).int  # De-normalize to terminal coordinates
      currentIndex  = drawY * buffer.width + drawX
    buffer.bufferChar[currentIndex] = ch
    buffer.bufferForegroundColor[currentIndex] = foregroundColor
    buffer.bufferBackgroundColor[currentIndex] = backgroundColor 
  # <- You must implement this to write a char at (x,y)
    x += stepX
    y += stepY

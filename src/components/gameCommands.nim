import nico, sequtils, strformat, random, os

let wx* = 600
let wy* = 400

let resolution* = 10
let dx* = resolution
let dy* = resolution

let nx* = wx div dx
let ny* = wy div dy

var generation* = 0
var board* = newSeqWith(nx, newSeq[bool](ny))
var nextBoard* = newSeqWith(nx, newSeq[bool](ny))

proc toggleCell*(x, y: int) = 
  let i = x div dx
  let j = y div dy
  if i < 0 or i >= nx or j < 0 or j >= ny:
    return 
  board[i][j] = not board[i][j]

proc neighbourCount*(i,j: int): int =
  result = 0
  for di in -1..1:
    for dj in -1..1:
      let ii = (i + di + nx) mod nx
      let jj = (j + dj + ny) mod ny
      result += int(board[ii][jj])
  result -= int(board[i][j])

proc resetBoard*() =
  board = newSeqWith(nx, newSeq[bool](ny))
  nextBoard = newSeqWith(nx, newSeq[bool](ny))
  generation = 0

proc evolveBoard*() =
  generation += 1
  for i in 0..<nx:
    for j in 0..<ny:
      let n = neighbourCount(i,j)
      let isAlive = board[i][j]
      if (not isAlive and n==3):
        # come alive
        nextBoard[i][j] = true
      elif (isAlive and (n<2 or n>3)):
        nextBoard[i][j] = false
      else:
        nextBoard[i][j] = isAlive
  swap(board, nextBoard)

proc showGeneration*() =
  setColor(2)
  let msg = &"Generation: {generation}"
  print(msg, nx div 10, ny div 10, 3)

proc initBoard*() =
  for i in 0..<nx:
    for j in 0..<ny:
      let on = bool(rand(9) div 9)
      board[i][j] = on
  generation = 0

proc gameInit*() =
  loadFont(0, "font.png")
  initBoard()

proc gameUpdate*(dt: float32) =
  if mousebtn(0):
    let (x,y) = mouse()
    toggleCell(x,y)
  if key(K_SPACE):
    evolveBoard()
  if key(K_0) or key(K_KP_0):
    resetBoard()
  if key(K_RETURN) or key(K_KP_ENTER):
    initBoard()
  sleep(100)

proc drawBoard*() = 
  for i in 0..<nx:
    for j in 0..<ny:
      if board[i][j] == true:
        setColor(3)
        boxfill(i*dx,j*dy, dx, dy)
      else:
        setColor(7)
  showGeneration()

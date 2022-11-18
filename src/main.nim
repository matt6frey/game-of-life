import nico, components/gameCommands

const orgName = "mf"
const appName = "conway"

proc gameDraw() =
  cls()
  drawBoard()

nico.init(orgName, appName)
nico.createWindow(appName, wx, wy, 1, false)
nico.run(gameInit, gameUpdate, gameDraw)

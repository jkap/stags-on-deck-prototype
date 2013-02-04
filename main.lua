function love.load()
  require("LoveFrames")
  leftKeys = {
    "q", "w", "e", "r", "t",
    "a", "s", "d", "f", "g",
    "z", "x", "c", "v"
  }
  rightKeys = {
    "y", "u", "i", "o", "p",
    "h", "j", "k", "l", ";",
    "b", "n", "m", ","
  }

  love.physics.setMeter(64)
  world = love.physics.newWorld(0, 9.81*64, true)

  font = love.graphics.newFont(30)
  love.graphics.setFont(font)

  state = "starting"

  devMode = true

  objects = {}

  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, 650/2, 650-50/2)
  objects.ground.shape = love.physics.newRectangleShape(650,50)
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)

  player1 = {}
  player1.body = love.physics.newBody(world, 100, 650/2, "dynamic")
  player1.shape = love.physics.newRectangleShape(0,0,50,50)
  player1.fixture = love.physics.newFixture(player1.body, player1.shape, 1)
  player1.fixture:setRestitution(0)
  player1.name = "Player 1"

  player2 = {}
  player2.body = love.physics.newBody(world, 650-100, 650/2, "dynamic")
  player2.shape = love.physics.newRectangleShape(0,0,50,50)
  player2.fixture = love.physics.newFixture(player2.body, player2.shape, 1)
  player2.fixture:setRestitution(0)
  player2.name = "Player 2"

  startTime = love.timer.getTime()

  addPlayButton()

  love.graphics.setMode(650,650,false,true,0)


end

function addPlayButton()
  local button = loveframes.Create("button")
  button:SetText("play")
  button.OnClick = function(object)
    startGame()
    button:Remove()
  end
  button:SetPos(650/2, 650/2)
end


function love.update(dt)
  if state == "playing" then
    world:update(dt)
    time = love.timer.getTime() - startTime
    if player1.body:getX() < 0 then
      win(player2)
    end
    if player2.body:getX() > 650 then
      win(player1)
    end
  elseif state == "win" or state == "starting" then
  end

  loveframes.update(dt)
end

function movePlayer(player)
  if player == player1 then
    player1.body:applyForce(10000,0)
  elseif player == player2 then
    player2.body:applyForce(-10000,0)
  end
end

function startGame()
  state = "playing"  
  player1.body:setLinearVelocity(0,0)
  player2.body:setLinearVelocity(0,0)
  player1.body:setPosition(100, 650/2)
  player2.body:setPosition(650-100, 650/2)
  startTime = love.timer.getTime()
  setInitialKeys()
end

function win(winning_player)
  state = "win"
  print(winning_player.name.." wins after "..time)
  addPlayButton()
end

function setInitialKeys()
  player1.key = leftKeys[math.random(#leftKeys)]
  player2.key = rightKeys[math.random(#rightKeys)]
end

function setKeyForPlayer(player)
  if player == player1 then
    repeat
      if math.random(10) > 8 then
        player1.key = rightKeys[math.random(#rightKeys)]
      else
        player1.key = leftKeys[math.random(#leftKeys)]
      end
    until player1.key ~= player2.key
  elseif player == player2 then
    repeat
      if math.random(10) > 8 then
        player2.key = leftKeys[math.random(#rightKeys)]
      else
        player2.key = rightKeys[math.random(#leftKeys)]
      end
    until player1.key ~= player2.key
  end
end

function love.draw()
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))
  love.graphics.polygon("fill", player1.body:getWorldPoints(player1.shape:getPoints()))
  love.graphics.polygon("fill", player2.body:getWorldPoints(player2.shape:getPoints()))  

  if state == "playing" then
    love.graphics.print(player1.key, 100, 100)
    love.graphics.print(player2.key, 550, 100)
  end
  if time then
    love.graphics.print(time, 250, 100)
  end
  if devMode then
    love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 10)
  end

  loveframes.draw()
end

function love.mousepressed(x,y,button)

  loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  loveframes.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
  if state == "playing" then
    if key == player1.key then
      movePlayer(player1)
      setKeyForPlayer(player1)
    elseif key == player2.key then
      movePlayer(player2)
      setKeyForPlayer(player2)
    end
  end

  loveframes.keypressed(key, unicode)
end

function love.keyreleased(key)
  loveframes.keyreleased(key)
end

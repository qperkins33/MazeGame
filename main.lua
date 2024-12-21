function love.load()
  Object = require "libraries/classic"
  require "player"
  require "maps"
  
  --window size
  love.window.setMode(1225, 875, {resizable=false})
-------------------------------------------------------
  --image and image width/height
  tile_number = love.math.random(1,9)
  image = love.graphics.newImage("assets/images/maze_images/tile" .. tile_number .. ".jpg")
  width = image:getWidth()
  height = image:getHeight()
  
  --starting game with it not being gameover
  gameover = false
  
  --randomly chooses and creates tilemap
  tilemap()
  
  --loads player
  player = Player()
  
  --random background color
  red = love.math.random(0.3,0.6)
  green = love.math.random(0.6,1)
  blue = love.math.random(0.3,1)
  
  --sounds
  sounds = {
    music = love.audio.newSource("assets/sounds/lobby.mp3", "stream"),
    move = love.audio.newSource("assets/sounds/move.wav", "static"),
    ending = love.audio.newSource("assets/sounds/end.mp3", "stream")
  }
  
  --plays music
  sounds.music:setLooping(true)
  sounds.music:play()
  
  --fonts
  gamefont = love.graphics.newFont("assets/fonts/font.ttf", 135)
  gameoverfont = love.graphics.newFont("assets/fonts/font.ttf", 75)
  
  --gameover animation
  gameover_x_pic = 900
  gameover_y_pic = 500
end

--checks if player is out of the maze
function love.update(dt)
  if player.tile_x == 1 then
    new_game()
  elseif player.tile_x == 19 then 
    new_game()
  elseif player.tile_y == 1 then
    new_game()
  elseif player.tile_y == 19 then
    new_game()
  end
  
  --gameover animation
  if gameover == true then
    --gameover image
    gameover_x_pic = gameover_x_pic + 30 * dt
    gameover_y_pic = gameover_y_pic + 150 * dt
    --check if out of maze
    if gameover_x_pic > 2500 then
      gameover_x_pic = 900
    elseif gameover_y_pic > 3000 then
      gameover_y_pic = 500
    end
  end
end

function love.draw()
  --random background color
  love.graphics.setBackgroundColor(red,green,blue)

  --moves camera
  love.graphics.translate(-player.tile_x * 175 + 175 * 3, -player.tile_y * 175 + 175 * 2)
  
  --draws map and player
  if gameover == false then
    for i,row in ipairs(tilemap) do
      for j,tile in ipairs(row) do
        if tile == 1 then
          love.graphics.draw(image, j * width, i * height)
        end 
      end
    end
    player:draw()
  end
  
  ---scoreboard
  love.graphics.setColor(0, 0, 0) --font color is black
  if gameover == false then
    love.graphics.print(player.score, gamefont, player.tile_x * 175 - 520, player.tile_y * 175 - 350) 
  end
  
  --gameover screen
  if gameover == true then
    sounds.music:stop()
    sounds.ending:play()
    
    love.graphics.print("GAME OVER", gameoverfont, 1650, 1600)
    love.graphics.print("FINAL SCORE: " .. player.score, gameoverfont, 1595, 1750)
    love.graphics.print("PERFECT SCORE: " .. perfectscore, gameoverfont, 1555, 1825)
    love.graphics.print("PRESS 'return' TO PLAY AGAIN", gameoverfont, 1315, 2000)
    
    --gameover animation
    love.graphics.draw(player.image, gameover_x_pic, 2150)
    love.graphics.draw(player.image, 2250, gameover_y_pic)
  end
  
  --color back to normal
  love.graphics.setColor(1, 1, 1)
end
-----------------------------
--triggers gameover
--moves player back to the center of the maze 
--...because thats where the gameover screen is located
function new_game()
  player.tile_x = 10
  player.tile_y = 11
  gameover = true
end
Player = Object:extend()

function Player:new()
  face = love.math.random(1,4)
  self.image = love.graphics.newImage("assets/images/player_faces/player" .. face .. ".png")
  self.tile_x = 10
  self.tile_y = 11
  self.score = 0
end

function isEmpty(x, y)
  return not(tilemap[y][x] == 1)
end

function love.keypressed(key)
  local x = player.tile_x
  local y = player.tile_y

  if key == "left" then
    x = x - 1
  elseif key == "right" then
    x = x + 1
  elseif key == "up" then
    y = y - 1
  elseif key == "down" then
    y = y + 1
  end
  
  --only move while not gameover
  if gameover == false then
    if isEmpty(x, y) then
      player.tile_x = x
      player.tile_y = y
      --only adds score if arrows are used
      if (key == "left") or (key == "right") or (key == "up") or (key == "down") then
        player.score = player.score + 1
        --move sound effect
        sounds.move:play()
      end
    end
  end
    -------------
    --restarts game
  if gameover == true then
    if key == 'return' then
      love.event.quit("restart")
    end
  end
end

function Player:draw()
  love.graphics.draw(self.image, self.tile_x * width, self.tile_y * height)
end
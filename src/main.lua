local tictactoe = require("tictactoe")
local bot = require("bot")

local index = 0
local cell_width  = 120
local time_between_moves = 0.314

function pixel_to_cell(x,y)
  x = math.floor(x / cell_width) + 1
  y = math.floor(y / cell_width) + 1
  x = (0 < x and x < 4) and x or false
  y = (0 < y and y < 4) and y or false
  return x, y
end

function reset_state()
  tictactoe.reset()
  if index % 2 == 0 then
    bot.init_as(tictactoe.noughts)
    human = tictactoe.crosses
    current_player = "human"
  else
    bot.init_as(tictactoe.crosses)
    human = tictactoe.noughts
    current_player = "bot"
  end
  index = index + 1
end

function draw_noughts(x, y)
  x = x + cell_width * (x - 0.5)
  y = y + cell_width * (y - 0.5)
  
  love.graphics.setColor(0.90, 0.29, 0.23, 1.0)
  love.graphics.setLineWidth(15)
  love.graphics.circle("line", x,y, cell_width * 0.4, 64)
end

function draw_crosses(x, y)
  local dx = cell_width * 0.4
  x = x + cell_width * (x - 0.5)
  y = y + cell_width * (y - 0.5)
  
  love.graphics.setColor(0.20, 0.59, 0.85, 1.0)
  love.graphics.setLineWidth(15)
  love.graphics.line(x-dx, y-dx, x+dx, y+dx)
  love.graphics.line(x+dx, y-dx, x-dx, y+dx)
end

function love.load()
  reset_state()
end

function love.update(dt)
  local has_won, _ = tictactoe.has_winner()
  if has_won or tictactoe.is_complete() then
    if love.keyboard.isDown("space") then
      reset_state()
    end
    return
  end
  if current_player == "human" then
    if love.mouse.isDown(1) then
      local x, y = love.mouse.getPosition()
      local i, j = pixel_to_cell(x, y)
      if (i and j) and tictactoe.get(j, i) == tictactoe.empty then
        tictactoe.set(j, i, human)
        current_player = "bot"
      end
    end
  else
    time_between_moves = time_between_moves - dt
    if time_between_moves <= 0 then
      bot.best_move()
      current_player = "human"
      time_between_moves = 0.314
    end
  end
end

function love.draw()
  -- noughts and crosses:
  for i = 1, 3 do
    for j = 1, 3 do
      if tictactoe.get(i, j) == tictactoe.crosses then draw_crosses(j, i) end
      if tictactoe.get(i, j) == tictactoe.noughts then draw_noughts(j, i) end
    end
  end

  -- grid:
  love.graphics.setColor(0.92, 0.94, 0.94, 1.0)
  love.graphics.setLineWidth(2)
  for i = 1, 4 do
    love.graphics.line(0, (i-1)*cell_width, cell_width*3, (i-1)*cell_width)
    love.graphics.line((i-1)*cell_width, 0, (i-1)*cell_width, cell_width*3)
  end
end
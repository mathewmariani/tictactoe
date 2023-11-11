local tictactoe = require("tictactoe")

local bot = { _version = "0.0.1" }
bot.__index = bot

bot.random = math.random
bot.state = {
  symbol = tictactoe.noughts,
}

-- scores: tie, crosses, noughts
local scores = { 0, 20, -20 }

function bot:init_as(value)
  self.symbol = value
end

function bot:random_move()
  while true do
    for i = 1, 3 do
      for j = 1, 3 do
        if tictactoe.get(i, j) == tictactoe.empty then
          if bot.random() > 0.6 then
            tictactoe.set(i, j, self.symbol)
            return
          end
        end 
      end
    end
  end
end

function bot:minimax(is_maximizing, depth)
  local result, who = tictactoe.has_winner()
  if result or tictactoe.is_complete() then
    return scores[who+1]
  end

  local best_score = is_maximizing and -math.huge or math.huge

  for i = 1, 3 do
    for j = 1, 3 do
      if tictactoe.get(i, j) == tictactoe.empty then
        tictactoe.set(i, j, is_maximizing and tictactoe.crosses or tictactoe.noughts)
        local score = bot.minimax(self, not is_maximizing, depth + 1)
        best_score = is_maximizing
          and math.max(score - depth, best_score)
          or math.min(score + depth, best_score)

        tictactoe.set(i, j, tictactoe.empty)
      end
    end
  end
  return best_score
end

function bot:best_move()
  local is_maximizing = (self.symbol == tictactoe.crosses) 
  local best_score = is_maximizing and -math.huge or math.huge
  local initial_depth = 0
  local x, y = nil, nil

  for i = 1, 3 do
    for j = 1, 3 do
      if tictactoe.get(i, j) == tictactoe.empty then
        tictactoe.set(i, j, self.symbol)
        local score = bot.minimax(self, not is_maximizing, initial_depth)
        tictactoe.set(i, j, tictactoe.empty)

        local a = is_maximizing and (score > best_score)
        local b = not is_maximizing and (score < best_score)
        if a or b then
          best_score = score
          x, y = i, j
        end
      end
    end
  end
  if not (x and y) then
    return
  end
  tictactoe.set(x, y, self.symbol)
end

local bound = {
  init_as     = function(...) return bot.init_as(bot.state, ...) end,
  random_move = function(...) return bot.random_move(bot.state, ...) end,
  best_move   = function(...) return bot.best_move(bot.state, ...) end,
}
setmetatable(bound, bot)

return bound
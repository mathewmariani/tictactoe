local tictactoe = { _version = "0.1.0" }
tictactoe.__index = tictactoe

tictactoe.board = {{0,0,0},{0,0,0},{0,0,0}}

function tictactoe:reset()
  for i = 1, 3 do
    for j = 1, 3 do
      self[i][j] = 0
    end
  end 
end

function tictactoe:has_winner()
  local test = false
  local winner = 0
  
  do -- rows:
    for i = 1, 3 do
      test = test or (self[i][1] == self[i][2] and self[i][1] == self[i][3] and self[i][1]~=0)
      if test then
        winner = self[i][1]
        return true, winner
      end
    end
  end
  
  do -- colomns:
    for j = 1, 3 do
      test = test or (self[1][j] == self[2][j] and self[1][j] == self[3][j] and self[1][j]~=0)
      if test then
        winner = self[1][j]
        return true, winner
      end
    end
  end
  
  do -- diagonals:
    test = test or (self[1][1] == self[2][2] and self[3][3] == self[2][2] and self[2][2]~=0)
    test = test or (self[1][3] == self[2][2] and self[3][1] == self[2][2] and self[2][2]~=0)
    if test then
      winner = self[2][2]
      return true, winner
    end
  end
  
  return false, winner
end

function tictactoe:is_complete()
  local mul = 1
  for i = 1, 3 do
    for j = 1, 3 do
      if self[i][j] == 0 then return false end
    end
  end 
  return true
end

function tictactoe:get(x, y)
  return self[x][y]
end

function tictactoe:set(x, y, value)
  self[x][y] = value
end

local bound = {
  -- functions:
  reset       = function(...) return tictactoe.reset(tictactoe.board, ...) end,
  has_winner  = function(...) return tictactoe.has_winner(tictactoe.board, ...) end,
  is_complete = function(...) return tictactoe.is_complete(tictactoe.board, ...) end,
  get         = function(x, y) return tictactoe.get(tictactoe.board, x, y) end,
  set         = function(x, y, value) return tictactoe.set(tictactoe.board, x, y, value) end,

  -- values:
  empty       = 0,
  crosses     = 1,
  noughts     = 2,
}
setmetatable(bound, tictactoe)

return bound
-- TODO: fix spaces
-- TODO: fix newlines
local text = "Lorem   \nipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum" 
local cursor = 10
local hoverIndex = 0
local lines = {} -- text split up into lines 
local lineHeight = 1.5
local fontSize = 18
local width = 600
local selectionEnd = 100

function love.load()
  font = love.graphics.newFont("Verdana.ttf", fontSize)
  love.graphics.setFont(font)
  start = love.timer.getTime()
end

function love.textinput(t)
  text = string.sub(text, 1, cursor) .. t .. string.sub(text, cursor + 1)
  cursor = cursor + 1
end

function love.keypressed(key)
  if key == "left" then
    cursor = cursor - 1
  end

  if key == "right" then
    cursor = cursor + 1
  end

  if key == "backspace" then
    if selectionEnd then
       text = string.sub(text, 1, cursor - 1) .. string.sub(text, selectionEnd)
       cursor = cursor + 1
       selectionEnd = nil
    else
       text = string.sub(text, 1, cursor - 2) .. string.sub(text, cursor)
    end
    cursor = cursor - 1
  end
end

function love.mousemoved()
  if love.mouse.isDown(1) then
      selectionEnd = mouseToIndex()
  end
end

function mouseToIndex()
  x = love.mouse:getX()
  y = love.mouse:getY()
  -- TODO make this nicer to account for subtle area in line gap
  lineIndex = 1 + math.floor(y / (fontSize * lineHeight))
  local chars = 1

  if(lineIndex < table.getn(lines) + 1) then
    line = lines[lineIndex]
    offset = 0
    for i = 1, lineIndex - 1 do
      chars = chars + table.getn(lines[i])
    end

    for i, charData in ipairs(line) do
      if x < offset + charData.width then
        if x - offset < charData.width / 2 then
          return chars
        else 
          return chars + 1
        end
      end

      offset = offset + charData.width
      chars = chars + 1
    end

    return chars - 1
  end
  return nil
end

function love.mousepressed()
  newCursor = mouseToIndex()
  selectionEnd = nil
  if newCursor then
    cursor = newCursor
  end
end

function love.draw()
  love.graphics.clear()
  love.graphics.setColor(255, 255, 0)

  lineOffset = 0
  xOffset = 0
  local chars = 1
  local selStart = {}
  local selEnd= {}

  word = {}
  for i = 1, #text do
    char = text:sub(i, i)
    love.graphics.print(char, xOffset, lineOffset)
    xOffset = xOffset + font:getWidth(char)

--[[     if i == cursor then
      selStart = {charData = charData, line = i, x = charOffset, y = lineOffset, width = charData.width}
      if math.floor((love.timer.getTime() - start) * 2) % 2 == 0 then
      love.graphics.rectangle("fill", charOffset, lineOffset, 1, fontSize * 1.4)
    end ]]
  end
--  love.graphics.rectangle("fill", 0, 0, width, 10)

--[[   if selectionEnd then
      local numLines = selEnd.line - selStart.line
      love.graphics.setBlendMode("add")
      love.graphics.setColor(0, 0, 255)
      if numLines == 0 then
          love.graphics.rectangle("fill", selStart.x, selStart.y, selEnd.x - selStart.x, fontSize * lineHeight)
      else
          -- first line
          love.graphics.rectangle("fill", selStart.x, selStart.y, width - (selStart.x ), fontSize * lineHeight)
          -- intermediate lines
          local iy = selStart.y + (fontSize * lineHeight)
          love.graphics.rectangle("fill", 0, iy, width, selEnd.y - iy)
          -- last line
          love.graphics.rectangle("fill", 0, selEnd.y, selEnd.x , fontSize * lineHeight)
      end
      love.graphics.setBlendMode("alpha")
  end ]]
end

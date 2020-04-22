
yOffset = 0
start = love.timer.getTime()

local text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum" 
local cursor = 1
local lines = {} -- text split up into lines 
local lineHeight = 1.5 -- means
local fontSize = 18
local width = 600

function layoutText()
  -- go through text, generate lines based off of character width of each.
  -- ignore newlines for now!
  lineWidth = 0
  line = {}

  table.insert(lines, line)

  for i = 1, #text do
    char = text:sub(i, i)
    charWidth = font:getWidth(char)
    lineWidth = lineWidth + charWidth
    charData = {char = char, width = charWidth}

    if lineWidth > width then
      -- start new line
      lineWidth = charWidth
      line = {}
      table.insert(lines, line)
      table.insert(line, charData)
    else
      -- append char to current line
      table.insert(line, charData)
    end
  end
end

function love.load()
  font = love.graphics.newFont("Verdana.ttf", fontSize)
  love.graphics.setFont(font)
  layoutText()
end

function love.update(dt)
  yOffset = math.sin(love.timer.getTime() - start) * 20
end

function love.textinput(t)
  print(table.concat(text))
  table.insert(text, cursor + 1, t)
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
    table.remove(text, cursor)
    cursor = cursor - 1
  end
end

function love.draw()
  love.graphics.clear()
  love.graphics.setColor(255, 255, 0)

  lineOffset = 0
  for i, line in ipairs(lines) do
    charOffset = 0

    for j, charData in ipairs(line) do
      if i + j == cursor then
        love.graphics.rectangle("fill", charOffset, lineOffset, 3, 48)
      end
      love.graphics.print(charData.char, charOffset, lineOffset)

      charOffset = charOffset + charData.width
    end
    lineOffset = lineOffset + (fontSize * lineHeight)
  end
end
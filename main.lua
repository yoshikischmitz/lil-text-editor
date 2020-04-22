
local text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum" 
local cursor = 10
local hoverIndex = 0
local lines = {} -- text split up into lines 
local lineHeight = 1.5
local fontSize = 18
local width = 600

function wordWidth(string) 
  width = 0
  for i = 1, #string do
    char = string:sub(i, i)
    width = width + font:getWidth(char)
  end
  return width
end

function layoutText()
  -- go through text, generate lines based off of character width of each.
  -- ignore newlines for now!
  lines = {}
  lineWidth = 0
  line = {}

  table.insert(lines, line)
  spaceWidth = font:getWidth(" ")

  spaceLeft = width
  for word in string.gmatch(text, "%S+") do
    chars = {}
    wordWidth = 0

    for i = 1, #word do
      char = word:sub(i, i)
      charWidth = font:getWidth(char)
      charData = {char = char, width = charWidth}
      table.insert(chars, charData)
      wordWidth = wordWidth + charWidth
    end
    table.insert(chars, {char = " ", width = spaceWidth})

    if wordWidth + spaceWidth > spaceLeft then
      line = chars
      table.insert(lines, line)
      spaceLeft = width - wordWidth
    else
      for k, char in ipairs(chars) do
        table.insert(line, char)
      end
      spaceLeft = spaceLeft - wordWidth + spaceWidth
    end
  end
end

function love.load()
  font = love.graphics.newFont("Verdana.ttf", fontSize)
  love.graphics.setFont(font)
  layoutText()
end

function love.textinput(t)
  text = string.sub(text, 1, cursor - 1) .. t .. string.sub(text, cursor)
  layoutText()
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

function love.mousepressed()
  x = love.mouse:getX()
  y = love.mouse:getY()
  -- TODO make this nicer to account for subtle area in line gap
  lineIndex = 1 + math.floor(y / (fontSize * lineHeight))
  local chars = 1

  if(lineIndex < table.getn(lines) + 1) then
    line = lines[lineIndex]
    offset = 0
    for i, charData in ipairs(line) do
      if x < offset + charData.width then
        if x - offset < charData.width / 2 then
          cursor = chars 
        else 
          cursor = chars + 1
        end
        if lineIndex > 1 then
          for i = 1, lineIndex - 1 do
            cursor = cursor + table.getn(lines[i])
          end
        end
        break
      end
      offset = offset + charData.width
      chars = chars + 1
    end
  end
end

function love.draw()
  love.graphics.clear()
  love.graphics.setColor(255, 255, 0)

  lineOffset = 0
  local chars = 1
  for i, line in ipairs(lines) do
    charOffset = 0

    for j, charData in ipairs(line) do
      if chars == cursor then
        love.graphics.rectangle("fill", charOffset, lineOffset, 3, fontSize)
      end
      love.graphics.print(charData.char, charOffset, lineOffset)

      charOffset = charOffset + charData.width
      chars = chars + 1
    end
    lineOffset = lineOffset + (fontSize * lineHeight)
  end
end
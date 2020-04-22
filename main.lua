
local text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum" 
local cursor = 1
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
local Nyuu = {
  currentMenu = nil,
  menus = {},
}

function Nyuu.up()
  if Nyuu.currentMenu == nil then
    return
  end

  Nyuu.currentMenu:changeSelection(-1)
end

function Nyuu.down()
  if Nyuu.currentMenu == nil then
    return
  end

  Nyuu.currentMenu:changeSelection(1)
end

function Nyuu.left()
  if Nyuu.currentMenu == nil then
    return
  end

  Nyuu.currentMenu:changeSelection(-1)
end

function Nyuu.right()
  if Nyuu.currentMenu == nil then
    return
  end

  Nyuu.currentMenu:changeSelection(1)
end

function Nyuu.select()
  if Nyuu.currentMenu == nil then return end

  Nyuu.currentMenu:select()
end

function Nyuu.draw()
  lg.setLineWidth(1)

  for _, menu in ipairs(Nyuu.menus) do
    menu:draw()
  end
end



local Menu = {}
local MenuMetaTable = {__index = Menu}

function Nyuu.newMenu(...)
  return setmetatable({}, MenuMetaTable)
    :initialize(...)
end

function Menu:initialize(options, callback)
  self.options = options
  self.callback = callback

  self.selection = 1

  self.font = font["mono16"] -- todo: remove xxx
  self.uiX = 10
  self.uiY = 199
  self.uiMenuW = 200
  self.uiMenuH = 50
  self.uiMenuPad = 3

  table.insert(Nyuu.menus, self)
  Nyuu.currentMenu = self
end

function Menu:changeSelection(i)
  self:setSelection(self.selection + i)
end

function Menu:setSelection(selection)
  self.selection = selection

  if selection <= 0 then
    self.selection = #self.options
  elseif selection > #self.options then
    self.selection = 1
  end
end

function Menu:select()
  -- Current menu should be closed first, since we're removing the latest on the stack.
  self:close()

  local selection = self.options[self.selection]
  self.callback(unpack(selection))
end

function Menu:close()
  Nyuu.currentMenu = nil
  table.remove(Nyuu.menus, #Nyuu.menus)
end

function Menu:draw()
  local x = self.uiX
  local y = self.uiY
  local w = self.uiMenuW
  local h = self.uiMenuH
  -- Usable area
  local pad = self.uiMenuPad
  local u_w = self.uiMenuW - pad * 2
  local u_h = self.uiMenuH - pad * 2

  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle('line', x + 0.5, y + 0.5, w -1 , h - 1)

  for i,opt in ipairs(self.options) do
    local offset_x = 0 -- ((i + 1) % 2) * math.floor(u_w / 2)
    local offset_y = math.floor(i - 1) * math.floor(u_h / 4)

    self:drawOption(opt[1], self.selection == i, x + pad + offset_x, y + pad + offset_y)
  end
end

function Menu:drawOption(text, selected, x, y)
  love.graphics.setColor(255, 255, 255)

  if selected then
    local rectWidth = self.font:getWidth(text) + 2
    love.graphics.rectangle('fill', x, y, rectWidth, 10)

    love.graphics.setColor(0, 0, 0)
  end

  love.graphics.print(text, x + 1, y + 1)
end



return Nyuu

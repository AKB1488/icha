local Nyuu = {
  currentMenu = nil,
  menus = {},
}

function Nyuu.up()
  Nyuu.currentMenu:changeSelection(-1)
end

function Nyuu.down()
  Nyuu.currentMenu:changeSelection(1)
end

function Nyuu.left()
  Nyuu.currentMenu:changeSelection(-1)
end

function Nyuu.right()
  Nyuu.currentMenu:changeSelection(1)
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

function Menu:initialize()
  table.insert(Nyuu.menus, self)
  Nyuu.currentMenu = self

  self.selection = 1
  self.options = {
    {text = 'Attack', id = 'attack'},
    {text = 'Magic', id = 'magic'},
    {text = 'Item', id = 'item'},
    {text = 'Cute Pose', id = 'cute_pose'},
  }

  self.font = font["mono16"] -- todo: remove xxx
  self._ui_x = 10
  self._ui_y = 199
  self._ui_menu_w = 200
  self._ui_menu_h = 50
  self._ui_menu_pad = 3
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

function Menu:draw()
  local x = self._ui_x
  local y = self._ui_y
  local w = self._ui_menu_w
  local h = self._ui_menu_h
  -- Usable area
  local pad = self._ui_menu_pad
  local u_w = self._ui_menu_w - pad * 2
  local u_h = self._ui_menu_h - pad * 2

  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle('line', x + 0.5, y + 0.5, w -1 , h - 1)

  for i,opt in ipairs(self.options) do
    local offset_x = 0 -- ((i + 1) % 2) * math.floor(u_w / 2)
    local offset_y = math.floor(i - 1) * math.floor(u_h / 4)

    self:drawOption(opt.text, self.selection == i, x + pad + offset_x, y + pad + offset_y)
  end
end

function Menu:drawOption(text, selected, x, y)
  love.graphics.setColor(255, 255, 255)

  if selected then
    local rect_width = self.font:getWidth(text) + 2
    love.graphics.rectangle('fill', x, y, rect_width, 10)

    love.graphics.setColor(0, 0, 0)
  end

  love.graphics.print(text, x + 1, y + 1)
end


return Nyuu

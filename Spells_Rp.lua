-- Magias Rp
g_ui.loadUIFromString([[
ConfigWindow < MainWindow
  size: 150 200

  Label
    id: titleMagias
    text: SPELLS   PALADIN
    font: verdana-11px-rounded
    color: #a73ec1
    margin-top: -30
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

  Panel
    id: lista
    anchors.fill: parent
    anchors.bottom: closeButton.top
    layout:
      type: grid
      cell-size: 110 15
      cell-spacing: 2

  Button
    id: closeButton
    text: Close
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
]])

local panelName = "config"
if not storage[panelName] then
  storage[panelName] = {
    enabled = false,
  }
end

local config = storage[panelName]

local rootWidget = g_ui.getRootWidget()
local configWindow = UI.createWindow('ConfigWindow', rootWidget)
configWindow:hide()

local listaMacros = {}

-- aqui van los macros

-- Antipk
local singleTargetSpell = 'exori con'
local multiTargetSpell = 'exevo mas san'
local distance = 4
local amountOfMonsters = 3

local antipkrp = macro(2000, "Antipk", function()
    local isSafe = true
    local specAmount = 0
    if not g_game.isAttacking() then
        return
    end
for i,mob in ipairs(getSpectators()) do
        if (getDistanceBetween(player:getPosition(), mob:getPosition()) <= distance and mob:isMonster()) then
            specAmount = specAmount + 1
        end
        if (mob:isPlayer() and (player:getName() ~= mob:getName()) and g_game.isAttacking (storage.Spell1)) then
            isSafe = false
        end
    end
    if (specAmount >= amountOfMonsters) and isSafe then
        say( multiTargetSpell )
    else
        say( singleTargetSpell )
    end
end)

-- mspell no antipk
local singleTargetSpell = 'exori con'
local multiTargetSpell = 'exevo mas san'
local distance = 4
local amountOfMonsters = 3

local noantipkrp = macro(2000, "Mspell", function()
    if not g_game.isAttacking() then
        return
    end

    local specAmount = 0

    for _, mob in ipairs(getSpectators()) do
        if mob:isMonster() and getDistanceBetween(player:getPosition(), mob:getPosition()) <= distance then
            specAmount = specAmount + 1
        end
    end

    if specAmount >= amountOfMonsters then
        say(multiTargetSpell)
    else
        say(singleTargetSpell)
    end
end)

local exoricon = macro(2000, "Exori con", function()
    if g_game.isAttacking() then
        say("exori con")
    end
end)

local exorisan = macro(2000, "Exori san", function()
    if g_game.isAttacking() then
        say("exori san")
    end
end)

local exevomasan = macro(2000, "Exevo mas san", function()
    if g_game.isAttacking() then
        say("exevo mas san")
    end
end)

local UtitoTempoSan = macro(2000, "utito tempo san", function()
        say("utito tempo san")
    end)

local config = {
    distance = 2, -- Define la distancia maxima para contar monstruos
    spell = "utito tempo san" -- Define el hechizo a lanzar
}

local UtitoTempoPro = macro(300, "utito tempo pro", function()
    if hasPartyBuff() then return end

    local playerPosition = g_game.getLocalPlayer():getPosition()
    local monstersScreen = g_map.getSpectators(playerPosition, false) 
    local monsterCount = 0

    for _, creature in ipairs(monstersScreen) do
        if creature:isMonster() then
            local creaturePosition = creature:getPosition()
            local distance = math.max(math.abs(creaturePosition.x - playerPosition.x), 
                                      math.abs(creaturePosition.y - playerPosition.y))
            if distance <= config.distance then
                monsterCount = monsterCount + 1
            end
        end
    end

    if monsterCount >= 2 then
        say(config.spell)
    end
end, false)

-- aqui los agregas a la ventana 
table.insert(listaMacros, antipkrp)
table.insert(listaMacros, noantipkrp)
table.insert(listaMacros, exoricon)
table.insert(listaMacros, exorisan)
table.insert(listaMacros, exevomasan)
table.insert(listaMacros, UtitoTempoSan)
table.insert(listaMacros, UtitoTempoPro)

local checkboxes = {}

for _, mac in ipairs(listaMacros) do
    local checkbox = g_ui.createWidget("CheckBox", configWindow.lista)
    checkbox:setText(mac.switch:getText())
    checkbox.onCheckChange = function(wid, isChecked)
        mac.setOn(isChecked)
    end
    checkbox:setChecked(mac.isOn())
    mac.switch:setVisible(false)
    table.insert(checkboxes, checkbox)
    
     -- Tooltip para "Antipkrp"
    if mac.switch:getText() == "Antipk" then
        checkbox:setTooltip("Este spell lanza exori con y si hay mas de 3 monster lanza Mas san Cuidando no sacar Pk.")
    end  
     -- Tooltip para "Multispell"
    if mac.switch:getText() == "Mspell" then
        checkbox:setTooltip("Este spell lanza exori con y si hay mas de 3 monster lanza Mas san, No es antipk.")
   end
      -- Tooltip para "UtitoTempoPro"
    if mac.switch:getText() == "utito tempo pro" then
        checkbox:setTooltip("Este spell lanza utito tempo san,si hay mas de 2 monster en un rango de 2sqm.")
    end
end

configWindow.closeButton.onClick = function(widget)
    configWindow:hide()
end

-- Boton para abrir la ventana
local openButton = UI.Button("Magias Paladin", function()
    configWindow:show()
    configWindow:raise()
    configWindow:focus()
end)
openButton:setColor("#00FFFF") -- Color cian

-- Animacion de brillo para el titulo
local titleMagias = configWindow.titleMagias
local text = "SPELLS   PALADIN"
local glowPosition = 1
local glowDirection = 1

macro(50, function()
    local numChars = #text
    local glowRange = math.max(1, math.floor(numChars / 10)) 
    local coloredText = {}

    for i = 1, numChars do
        local char = text:sub(i, i)
        local color = "#a73ec1" -- Color base
        if math.abs(i - glowPosition) <= glowRange then
            color = "#dfbae9" -- Color de brillo
        end
        table.insert(coloredText, char)
        table.insert(coloredText, color)
    end

    glowPosition = glowPosition + glowDirection
    if glowPosition > numChars then
        glowPosition = numChars - 1
        glowDirection = -1
    elseif glowPosition < 1 then
        glowPosition = 2
        glowDirection = 1
    end

    titleMagias:setColoredText(coloredText)
end)
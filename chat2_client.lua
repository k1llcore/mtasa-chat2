local chatInstance
local chatInstanceLoading
local chatInstanceLoaded

addEvent("onChat2Loaded")
addEvent("onChat2Input")
addEvent("onChat2SendMessage")
addEvent("onChat2ReceiveMessage", true)
addEvent("onChat2Clear", true)
addEvent("onChat2Show", true)

function clear()
  local eval = "clear()"
  execute(eval)
end

function show(bool)
  if chatInstanceLoaded ~= true then
    if chatInstanceLoading ~= true then
      create()
      setTimer(show, 300, 1, bool)
    else
      setTimer(show, 300, 1, bool)
    end
  end

  local eval = "show(" .. tostring(bool) .. ");"
  execute(eval)
end

function execute(eval)
  executeBrowserJavascript(chatInstance, eval)
end

function create()
  chatInstance = guiGetBrowser(guiCreateBrowser(0.01, 0.01, 0.25, 0.4, true, true, true))
  chatInstanceLoading = true
  addEventHandler("onClientBrowserCreated", chatInstance, load)
end

function load()
  loadBrowserURL(chatInstance, "http://mta/local/index.html")
  -- TODO remove it
  -- setDevelopmentMode(true, true)
  -- toggleBrowserDevTools(chatInstance, true)
end

function onResourceStart()
  showChat(false)
  show(true)
end

function onChatLoaded()
  chatInstanceLoaded = true
  focusBrowser(chatInstance)
end

function onChatInput(isActive)
  if isActive == "true" then
    guiSetInputEnabled(true)
  else
    guiSetInputEnabled(false)
  end
end

function onChatSendMessage(message)
  triggerServerEvent("onChat2SendMessage", resourceRoot, message)
end

function onChatReceiveMessage(message)
  local eval = string.format("addMessage(%s)", toJSON(message))
  execute(eval)
end

addEventHandler("onClientResourceStart", resourceRoot, onResourceStart)
addEventHandler("onChat2Loaded", resourceRoot, onChatLoaded)
addEventHandler("onChat2Input", resourceRoot, onChatInput)
addEventHandler("onChat2SendMessage", resourceRoot, onChatSendMessage)
addEventHandler("onChat2ReceiveMessage", localPlayer, onChatReceiveMessage)
addEventHandler("onChat2Clear", localPlayer, clear)
addEventHandler("onChat2Show", localPlayer, show)

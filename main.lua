function love.load(arg)
  love.math.setRandomSeed(os.time() / os.clock() / os.time() / math.random(10, 10000000))
  print(love.filesystem.getWorkingDirectory( ))

  -- global used variables
  scene = {}
  scene.current = "start"

  font = {}
  font.normal = love.graphics.newFont("Roboto-Regular.ttf", 30)
  font.big = love.graphics.newFont("Roboto-Regular.ttf", 60)
  font.small = love.graphics.newFont("Roboto-Regular.ttf", 19)

  mouse = {}
  mouse.x = love.mouse.getX()
  mouse.y = love.mouse.getY()

  screen = {}
  screen.w = love.graphics.getWidth()
  screen.h = love.graphics.getHeight()

  sound = {}
  sound.shoot = love.audio.newSource("sounds/shoot.wav", "static")
  sound.gameOver = love.audio.newSource("sounds/gameOver.wav", "static")
  sound.wrong = love.audio.newSource("sounds/wrong.wav", "static")
  sound.ammo = love.audio.newSource("sounds/ammo.wav", "static")
  sound.hit = love.audio.newSource("sounds/hit.wav", "static")
  sound.click = love.audio.newSource("sounds/click.wav", "static")
  sound.levelUp = love.audio.newSource("sounds/levelUp.wav", "static")

  music = {}
  music.dir = "music/"
  music.files = love.filesystem.getDirectoryItems(music.dir)
  music.tracks = {}
  -- search music folder for audio files
  for i, file in ipairs(music.files) do
    local fileName = string.gsub(file, ".mp3", "")
    table.insert(music.tracks, {love.audio.newSource("music/"..file, "stream"), fileName})
  end
  music.n = 1
  music.current = music.tracks[music.n]
  music.rep = "off"
  -- set the volume for every track to 50%
  for i, m in ipairs(music.tracks) do
    m[1]:setVolume(0.5)
  end
  -- play audio
  love.audio.play(music.current[1])

  background = {}
  background.on = true
  background.objects = {}

  -- start scene variables
  start = {}
  start.startW = 200
  start.startH = 75
  start.startX = (screen.w / 2) - (200 / 2)
  start.startY = (screen.h / 2) - (75 / 2)
  start.startColor = {0 / 255, 0 / 255, 0 / 255}

  start.controlW = 200
  start.controlH = 75
  start.controlX = (screen.w / 2) - (200 / 2)
  start.controlY = (screen.h / 2) + (75)
  start.controlColor = {0 / 255, 0 / 255, 0 / 255}
  start.controlText =
  "\nPlayer controls"..
  "\nPoint & click   shoot"..
  "\nArrow up        move up"..
  "\nArrow down      move down"..
  "\nArrow right     move right"..
  "\nArrow left      move left"..
  "\n"..
  "\nGame controls"..
  "\nr               back to menu"..
  "\nEsc             exit game"..
  "\n"..
  "\nMusic controls"..
  "\n]               next song"..
  "\n[               previous song"..
  "\n+               volume up"..
  "\n-               volume down"..
  "\n0               toggle repeat"

  start.exitW = 200
  start.exitH = 75
  start.exitX = (screen.w / 2) - (200 / 2)
  start.exitY = (screen.h / 2) + (2 * 75 + (75 / 2))
  start.exitColor = {0 / 255, 0 / 255, 0 / 255}

  start.backColor = {255 / 255, 255 / 255, 255 / 255, 1}
  start.fade = false
  start.backFade = 2
  start.showControl = false

  -- game scene variables
  game = {}
  game.level = 0
  game.score = 0

  player = {}
  player.radius = 20
  player.x = love.graphics.getWidth() / 2
  player.y = love.graphics.getHeight() / 2
  player.speed = 225
  player.angle = 0
  player.LEx = 0
  player.LEy = 0
  player.LSx = 0
  player.LSy = 0
  player.LEr = 30
  player.LSr = 10
  player.color = {255 / 255, 255 / 255, 255 / 255}
  player.lives = 2
  player.ammo = 30

  enemy = {}
  enemy.radius = 20
  enemy.speed = 100
  enemy.color = {
    {51 / 255, 51 / 255, 255 / 255},
    {51 / 255, 102 / 255, 255 / 255},
    {51 / 255, 153 / 255, 255 / 255},
    {51 / 255, 204 / 255, 255 / 255},
    {51 / 255, 255 / 255, 255 / 255},
    {51 / 255, 255 / 255, 204 / 255},
    {51 / 255, 255 / 255, 153 / 255},
    {51 / 255, 255 / 255, 102 / 255},
    {51 / 255, 255 / 255, 51 / 255},
    {102 / 255, 255 / 255, 51 / 255},
    {153 / 255, 255 / 255, 51 / 255},
    {204 / 255, 255 / 255, 51 / 255},
    {255 / 255, 255 / 255, 51 / 255},
    {255 / 255, 204 / 255, 51 / 255},
    {255 / 255, 153 / 255, 51 / 255},
    {255 / 255, 102 / 255, 51 / 255},
    {255 / 255, 51 / 255, 51 / 255}
  }
  enemy.max = 3
  enemy.maxSegments = 3
  enemy.destroyed = 0
  enemy.cycle = 0
  enemies = {}

  bullet = {}
  bullet.speed = 600
  bullet.size = 2
  bullet.color = {255 / 255, 0, 0}
  bullets = {}

  ammo = {}
  ammo.size = 4
  ammo.minSpeed = 10
  ammo.maxSpeed = 300
  ammo.gFactor = 0.97
  ammo.color = {232 / 255, 209 / 255, 129 / 255, 1}
  ammo.fade = 4
  ammos = {}

  -- end scene variables
  gameOver = {}
  gameOver.x = 0
  gameOver.y = 0
  gameOver.text = ""
  gameOver.textColor = {0, 0, 0, 0}
  gameOver.textFade = 1
  gameOver.backColor = {200, 200, 200, 0}
  gameOver.backFade = 1.5
  gameOver.secondColor = {0, 0, 0, 0}
  gameOver.thirdColor = {0, 0, 0, 0}
end

function love.update(dt)
  -- update variables
  mouse.x = love.mouse.getX()
  mouse.y = love.mouse.getY()
  screen.w = love.graphics.getWidth()
  screen.h = love.graphics.getHeight()
  fps = love.timer.getFPS()

  -- quit game handler
  if (love.keyboard.isDown("escape")) then
    love.event.quit()
  end

  -- start scene
  if (scene.current == "start") then
    if not music.current[1]:isPlaying() then
      if music.rep == "on" then
        love.audio.play(music.current[1])
      else
        love.keypressed("]")
      end
    end

    if (start.fade) then
      if (start.backColor[4] >= 0) then
        start.backColor[4] = start.backColor[4] - (1 / start.backFade * dt)
      else
        scene.current = "game"
      end
    end
  end

  -- game scene
  if (scene.current == "game") then
    if not music.current[1]:isPlaying() then
      if music.rep == "on" then
        love.audio.play(music.current[1])
      else
        love.keypressed("]")
      end
    end

    -- controls handler
    -- right
    if (love.keyboard.isDown("right") and (player.x < screen.w - (player.radius))) then
      player.x = player.x + (player.speed * dt)
    end
    -- left
    if (love.keyboard.isDown("left") and (player.x > 0 + (player.radius))) then
      player.x = player.x - (player.speed * dt)
    end
    -- up
    if (love.keyboard.isDown("up") and (player.y > 0 + (player.radius))) then
      player.y = player.y - (player.speed * dt)
    end
    -- down
    if (love.keyboard.isDown("down") and (player.y < screen.h - (player.radius))) then
      player.y = player.y + (player.speed * dt)
    end

    -- player

    -- if player is out of lives..
    if ((player.lives <= 0)) then
      -- goto the end scene and...
      scene.current = "end"
      gameOver.text = "Game Over"
      -- pause the music and play gameOver sound.
      love.audio.pause(music.current[1])
      love.audio.play(sound.gameOver)
    end

    -- if player is out of ammo..
    if ((player.ammo <= 0)) then
      -- goto the end scene and...
      scene.current = "end"
      gameOver.text = "Out of Ammo"
      -- pause the music and play gameOver sound
      love.audio.pause(music.current[1])
      love.audio.play(sound.gameOver)
    end

    -- every time there are more then 10 destroyed enemies do..
    if (enemy.destroyed >= enemy.max) then
      -- reset destroyed amount of enemies
      enemy.destroyed = 0
      -- go to next cycle
      enemy.cycle = enemy.cycle + 1
      -- go to next level and add a segment to maxSegments
      game.level = game.level + 1
      enemy.maxSegments = enemy.maxSegments + 1
      -- play levelUp sound
      love.audio.play(sound.levelUp)
    end

    -- when 3 cycles have past..
    if (enemy.cycle >= 3) then
      -- reset amount of cycles
      enemy.cycle = 0
      -- add player level
      player.lives = player.lives + 1
      -- add a enemy
      enemy.max = enemy.max + 1
    end

    -- enemies

    -- if the amount of enemies is smaller then 1.
    if (#enemies < 1) then
      -- add a enemies
      while #enemies < enemy.max do
        addEnemy()
      end
    end

    -- update for every enemy
    for i, e in ipairs(enemies) do
      -- variables
      local remove = false

      -- calculate new position for enemy
      local angle = math.atan2((player.y - e.y), (player.x - e.x))
      local Dx = enemy.speed * math.cos(angle)
      local Dy = enemy.speed * math.sin(angle)
      e.x = e.x + (Dx * dt)
      e.y = e.y + (Dy * dt)

      -- check for bullet hit
      for i, b in ipairs(bullets) do
        -- if bullet is hit
        if (pointInCircle(b.x, b.y, e.x, e.y, enemy.radius)) then
          -- remove segment from enemy
          e.seg = e.seg - 1
          -- remove bullet
          table.remove(bullets, i)
          -- play hit sound
          love.audio.stop(sound.hit)
          love.audio.play(sound.hit)
          -- log to console
          print("Log: bullet Removed")
        end
      end

      -- check for collision with player
      if (checkCircularCollision(player.x, player.y, e.x, e.y, player.radius, enemy.radius)) then
        -- remove 1 live
        player.lives = player.lives - 1
        -- if level is greater then 1
        if (player.lives >= 1) then
          -- play wrong sound
          love.audio.play(sound.wrong)
        end
        -- set remove to true to remove enemy at the end of the loop
        remove = true
      end

      -- if enemy segments is smaller then 3
      if (e.seg < 3) then
        -- add points
        game.score = game.score + e.points
        -- add enemy destroyed
        enemy.destroyed = enemy.destroyed + 1
        -- add ammo based on the amount of segments
        for i = 1, e.points - round(love.math.random(-1, 1)) do
          table.insert(ammos, {x = (e.x + love.math.random(1, 50)), y = (e.y + love.math.random(1, 50)), speed = ammo.speed, color = {232 / 255, 209 / 255, 129 / 255, 1}})
        end
        -- log to console
        print("Log: ammo spawned")
        -- set remove to true to remove enemy at the end of the loop
        remove = true
      end

      -- if remove is true
      if remove then
        -- delete enemy
        table.remove(enemies, i)
        print("Log: enemy Removed from screen")
      end
    end

    -- ammo

    -- update for ammo
    for i, a in ipairs(ammos) do
      -- calculate new speed for ammo
      local x = distance(player.x, player.y, a.x, a.y)
      a.speed = ammo.maxSpeed * (ammo.gFactor^x) + ammo.minSpeed

      -- calculate new location for ammo
      local angle = math.atan2((player.y - a.y), (player.x - a.x))
      local Dx = a.speed * math.cos(angle)
      local Dy = a.speed * math.sin(angle)
      a.x = a.x + (Dx * dt)
      a.y = a.y + (Dy * dt)

      -- check for collision with the player
      if (pointInCircle(a.x, a.y, player.x, player.y, player.radius)) then
        -- add ammo to player
        player.ammo = player.ammo + 1
        -- play ammo sound
        love.audio.stop(sound.ammo)
        love.audio.play(sound.ammo)
        -- remove ammo from table
        table.remove(ammos, i)
        -- log to console
        print("Log: ammo Removed from screen")
      end

      -- calculate new color
      if (a.color[4] <= 1) then
        a.color[4] = a.color[4] - (1 / ammo.fade * dt)
      else
        -- remove ammo from table
        table.remove(ammos, i)
        -- log to console
        print("Log: ammo Removed from screen")
      end
    end

    -- bullets
    -- update for bullets
    for i, v in ipairs(bullets) do
      -- calculate new location
      v.x = v.x + (v.dx * dt)
      v.y = v.y + (v.dy * dt)
      -- if bullet is out of the render screen
      if ((v.x > screen.w) or (v.y > screen.h) or (v.x < 0) or (v.y < 0)) then
        -- remove bullet from table
        table.remove(bullets, i)
        -- log to console
        print("Log: bullet Removed from screen")
      end
    end

    -- players gun
    -- calculate player angle
    player.angle = math.atan2((mouse.y - player.y), (mouse.x - player.x))
    -- calculate gun line starting and ending position
    player.LEx, player.LEy = lineEndPoint(player.x, player.y, player.angle, player.LEr)
    player.LSx, player.LSy = lineEndPoint(player.x, player.y, player.angle, player.LSr)
  end

  -- end scene
  if (scene.current == "end") then
    -- fade in background
    if (gameOver.backColor[4] <= 1) then
      gameOver.backColor[4] = gameOver.backColor[4] + (1 / gameOver.backFade * dt)
    else
      -- fade in text
      if (gameOver.textColor[4] <= 1) then
        gameOver.textColor[4] = gameOver.textColor[4] + (1 / gameOver.textFade * dt)
      else
        -- fade in second text
        if (gameOver.secondColor[4] <= 1) then
          gameOver.secondColor[4] = gameOver.secondColor[4] + (1 / gameOver.textFade * dt)
        else
          -- fade in third text while second text is still fading
          if (gameOver.thirdColor[4] <= 1) then
            gameOver.thirdColor[4] = gameOver.thirdColor[4] + (1 / gameOver.textFade * dt)
          else
            love.timer.sleep(3)
            love.audio.play(music.current[1])
            restart()
          end
        end
      end
    end
  end
end

function love.draw()
  love.graphics.setBackgroundColor(0, 0, 0)
  if (scene.current == "start") then
    love.graphics.setColor(start.backColor)
    love.graphics.rectangle("fill", 0, 0, screen.w, screen.h)

    if start.showControl then
      -- set font to normal
      love.graphics.setFont(font.normal)
      -- set color
      love.graphics.setColor(0, 0, 0)
      -- print control text
      love.graphics.printf(start.controlText, 100, 100, screen.w - 200, "left")

      -- render back button
      -- draw rectangle
      love.graphics.rectangle("fill", screen.w - 300, screen.h - 100, 200, 75)
      -- set color
      love.graphics.setColor(1, 1, 1)
      -- print back button text
      love.graphics.printf("back", screen.w - 300, screen.h - 100 + ((75 / 2) - (font.normal:getHeight() / 2)), 200, "center")

      -- draw music info
      -- set color
      love.graphics.setColor(0, 0, 0)
      -- set font to small
      love.graphics.setFont(font.small)
      -- print music info text
      love.graphics.printf("Repeat: "..music.rep, 20, screen.h - (3 * font.normal:getHeight()) - 5, screen.w, "left")
      love.graphics.printf("Music: "..music.current[2], 20, screen.h - font.normal:getHeight() - 5, screen.w, "left")
      love.graphics.printf("Volume: ".. round(music.current[1]:getVolume() * 100) .."%", 20, screen.h - (2 * font.normal:getHeight()) - 5, screen.w, "left")
    else
      love.graphics.setFont(font.big)
      love.graphics.setColor(start.startColor)
      love.graphics.printf("Tshoot", 0, screen.h / 4, screen.w, "center")

      -- start button
      love.graphics.setFont(font.normal)
      love.graphics.setColor(start.startColor)
      love.graphics.rectangle("fill", start.startX, start.startY, start.startW, start.startH)
      love.graphics.setColor(1, 1, 1)
      love.graphics.printf("start", start.startX, start.startY + ((start.startH / 2) - (font.normal:getHeight() / 2)), start.startW, "center")
      -- controls button
      love.graphics.setColor(start.controlColor)
      love.graphics.rectangle("fill", start.controlX, start.controlY, start.controlW, start.controlH)
      love.graphics.setColor(1, 1, 1)
      love.graphics.printf("controls", start.controlX, start.controlY + ((start.controlH / 2) - (font.normal:getHeight() / 2)), start.controlW, "center")
      -- exit button
      love.graphics.setColor(start.exitColor)
      love.graphics.rectangle("fill", start.exitX, start.exitY, start.exitW, start.exitH)
      love.graphics.setColor(1, 1, 1)
      love.graphics.printf("exit", start.exitX, start.exitY + ((start.exitH / 2) - (font.normal:getHeight() / 2)), start.exitW, "center")

      love.graphics.setColor(0, 0, 0)
      love.graphics.setFont(font.small)
      love.graphics.printf("Repeat: "..music.rep, 20, screen.h - (3 * font.normal:getHeight()) - 5, screen.w, "left")
      love.graphics.printf("Music: "..music.current[2], 20, screen.h - font.normal:getHeight() - 5, screen.w, "left")
      love.graphics.printf("Volume: ".. round(music.current[1]:getVolume() * 100) .."%", 20, screen.h - (2 * font.normal:getHeight()) - 5, screen.w, "left")
    end
  end

  if (scene.current == "game") then
    -- draw player
    love.graphics.setLineWidth(1)
    love.graphics.setColor(player.color)
    love.graphics.circle("line", player.x, player.y, player.radius)
    love.graphics.line(player.LSx, player.LSy, player.LEx, player.LEy)

    -- draw bullets
    love.graphics.setColor(bullet.color)
    for i, b in ipairs(bullets) do
      love.graphics.circle("fill", b.x, b.y, bullet.size)
    end

    -- draw enemies
    love.graphics.setFont(font.small)
    for i, e in ipairs(enemies) do
      love.graphics.setColor(e.seg - 3, 255 - (e.seg - 3), 0)
      love.graphics.circle("line", e.x, e.y, enemy.radius, e.seg)
      love.graphics.print(e.seg - 2, e.x - (font.small:getWidth(e.seg - 2) / 2), e.y - (font.small:getHeight() / 2))
    end

    -- draw ammo
    for i, a in ipairs(ammos) do
      love.graphics.setColor(a.color)
      love.graphics.circle("fill", a.x, a.y, ammo.size)
    end

    -- draw score
    -- set font
    love.graphics.setFont(font.normal)
    -- set color
    love.graphics.setColor(1, 1, 1)

    -- print level and score
    love.graphics.printf("score: "..game.score, - 20, 20, screen.w, "right")
    love.graphics.printf("level: "..game.level, 20, 20, 200, "left")
    -- print level progression bar
    love.graphics.rectangle("line", 20, font.normal:getHeight() + 30, 100, 10)
    love.graphics.setLineWidth(10)
    love.graphics.line(20, font.normal:getHeight() + 35, 20 + ((enemy.destroyed / enemy.max) * 100), font.normal:getHeight() + 35)
    -- print amount of lives and ammo
    love.graphics.printf("lives: "..player.lives, 0, screen.h - (2 * font.normal:getHeight()) - 20, screen.w - 20, "right")
    love.graphics.printf("ammo: "..player.ammo, 0, screen.h - font.normal:getHeight() - 20, screen.w - 20, "right")
    -- sent font to small
    love.graphics.setFont(font.small)
    -- draw music info
    love.graphics.printf("Repeat: "..music.rep, 20, screen.h - (3 * font.normal:getHeight()) - 5, screen.w, "left")
    love.graphics.printf("Music: "..music.current[2], 20, screen.h - font.normal:getHeight() - 5, screen.w, "left")
    love.graphics.printf("Volume: ".. round(music.current[1]:getVolume() * 100) .."%", 20, screen.h - (2 * font.normal:getHeight()) - 5, screen.w, "left")
  end

  if (scene.current == "end") then
    love.graphics.setColor(gameOver.backColor)
    love.graphics.rectangle("fill", 0, 0, screen.w, screen.h)

    love.graphics.setFont(font.big)
    love.graphics.setColor(gameOver.textColor)
    love.graphics.printf(gameOver.text, (screen.w / 2) - 300, (screen.h / 2) - font.big:getHeight(), 600, "center")

    love.graphics.setFont(font.small)
    love.graphics.setColor(gameOver.secondColor)
    love.graphics.printf("You reached level "..game.level, (screen.w / 2) - 300, (screen.h / 2) - (1.4 * font.big:getHeight()), 600, "center")
    love.graphics.setColor(gameOver.thirdColor)
    love.graphics.printf("Your score: "..game.score, (screen.w / 2) - 300, (screen.h / 2) + 10, 600, "center")
  end
end

-- keyboard events
function love.keypressed(key)
  if key == "[" then
    -- stop music
    love.audio.stop(music.current[1])

    -- previous track
    if music.n > 1 then
      music.n = music.n - 1
      music.current = music.tracks[music.n]
    else
      music.n = #music.tracks
      music.current = music.tracks[music.n]
    end
    -- start music
    love.audio.play(music.current[1])
  end
  if key == "]" then
    -- stop music
    love.audio.stop(music.current[1])

    -- next track
    if music.n < #music.tracks then
      music.n = music.n + 1
      music.current = music.tracks[music.n]
    else
      music.n = 1
      music.current = music.tracks[music.n]
    end
    -- start playing music
    love.audio.play(music.current[1])
  end

  if (key == "=") and (music.current[1]:getVolume()) <= 1.4 then
    music.current[1]:setVolume(music.current[1]:getVolume() + 0.05)
  end

  if (key == "-") and (music.current[1]:getVolume() >= -1) then
    music.current[1]:setVolume(music.current[1]:getVolume() - 0.05)
  end

  if (key == "0") and music.rep == "on" then
    changeTo = "off"
  end

  if (key == "0") and music.rep == "off" then
    changeTo = "on"
  end

  if (key == "0") then
    music.rep = changeTo
  end

  if key == "r" then
    gameOver.text = "You gave up!?"
    scene.current = "end"
    love.audio.pause(music.current[1])
    love.audio.play(sound.gameOver)
  end
end

-- mouse events
function love.mousepressed(x, y, button)
  if ((button == 1) and (scene.current == "game")) then
    player.ammo = player.ammo - 1
    local startX = player.LSx
    local startY = player.LSy
    local mouseX = x
    local mouseY = y

    local angle = math.atan2((mouseY - startY), (mouseX - startX))

    local bulletDx = bullet.speed * math.cos(angle)
    local bulletDy = bullet.speed * math.sin(angle)

    table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy})
    love.audio.play(sound.shoot)
  end

  if ((button == 1) and (scene.current == "start")) then
    if CheckCollision(start.startX, start.startY, start.startW, start.startH, x, y, 1, 1) then
      love.audio.play(sound.click)
      start.fade = true
    end
    if CheckCollision(start.exitX, start.exitY, start.exitW, start.exitH, x, y, 1, 1) then
      love.audio.play(sound.click)
      love.event.quit()
    end
    if CheckCollision(start.controlX, start.controlY, start.controlW, start.controlH, x, y, 1, 1) then
      love.audio.play(sound.click)
      start.showControl = true
    end
    if start.showControl then
      if CheckCollision(screen.w - 300, screen.h - 100, 200, 75, x, y, 1, 1) then
        love.audio.play(sound.click)
        start.showControl = false
      end
    end
  end
end

-- add enemy
function addEnemy()
  local screenW = screen.w
  local screenH = screen.h

  -- choose wich side to spawn
  local side = round(love.math.random(1, 4))

  if side == 1 then
    startX = -50
    startY = love.math.random(0, screenH)
  end
  if side == 2 then
    startX = love.math.random(0, screenW)
    startY = -50
  end
  if side == 3 then
    startX = screenW + 50
    startY = love.math.random(0, screenH)
  end
  if side == 4 then
    startX = love.math.random(0, screenW)
    startY = screenH + 50
  end
  print("Log: spawned enemy "..startX..","..startY.." at side "..side)

  -- choose random amount of segments
  local s = love.math.random(3, enemy.maxSegments)
  local segments = s + 0.5 - (s + 0.5) % 1

  -- insert enemy in to table
  table.insert(enemies, {x = startX, y = startY, seg = segments, points = segments})
end

-- Functions
function lineEndPoint (x, y, a, r)
  xn = math.cos(a) * r
  yn = math.sin(a) * r
  return x + xn, y + yn
end

function pointInCircle(x, y, xCenter, yCenter, r)
  return (x - xCenter)^2 + (y - yCenter)^2 < r^2
end

function checkCircularCollision(ax, ay, bx, by, ar, br)
  local dx = bx - ax
  local dy = by - ay
  return dx^2 + dy^2 < (ar + br)^2
end

function round(x)
  return x + 0.5 - (x + 0.5) % 1
end

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
  return x1 < x2 + w2 and
  x2 < x1 + w1 and
  y1 < y2 + h2 and
  y2 < y1 + h1
end

function distance ( x1, y1, x2, y2 )
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end

function restart()
  -- start scene variables
  start.backColor = {255 / 255, 255 / 255, 255 / 255, 1}
  start.fade = false

  -- game scene variables
  game.level = 0
  game.score = 0

  player.x = love.graphics.getWidth() / 2
  player.y = love.graphics.getHeight() / 2
  player.angle = 0
  player.LEx = 0
  player.LEy = 0
  player.LSx = 0
  player.LSy = 0
  player.LEr = 30
  player.LSr = 10
  player.lives = 2
  player.ammo = 30

  enemy.max = 3
  enemy.maxSegments = 3
  enemy.destroyed = 0
  enemy.cycle = 0
  enemies = {}

  bullets = {}

  ammos = {}

  -- end scene variables
  gameOver = {}
  gameOver.x = 0
  gameOver.y = 0
  gameOver.text = ""
  gameOver.textColor = {0, 0, 0, 0}
  gameOver.textFade = 1
  gameOver.backColor = {200, 200, 200, 0}
  gameOver.backFade = 1.5
  gameOver.secondColor = {0, 0, 0, 0}
  gameOver.thirdColor = {0, 0, 0, 0}

  scene.current = "start"
end

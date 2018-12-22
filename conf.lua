function love.conf(t)
  t.version = "11.2"
  t.console = true

  t.releases = {
    title = "Tshoot", -- The project title (string)
    package = "tshoot", -- The project command and package name (string)
    loveVersion = "11.0", -- The project LÖVE version
    author = "Neo Hop", -- Your name (string)
    email = "neo@hopjes.net", -- Your email (string)
    description = "This little astroids inspired game. Turned out to be a lot of fun. yes, my name is really neo (from the matrix)", -- The project description (string)
    homepage = nil, -- The project homepage (string)
    identifier = nil, -- The project Uniform Type Identifier (string)
    excludeFileList = {}, -- File patterns to exclude. (string list)
    releaseDirectory = nil, -- Where to store the project releases (string)
  }

  t.window.title = "Tshoot"
  t.window.icon = "icon.png"
  t.window.fullscreen = false
  t.window.msaa = 4
  t.window.vsync = 0
end

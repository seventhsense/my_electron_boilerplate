electron = require 'electron'
app = electron.app
bw = electron.BrowserWindow

main_window = null

create_window = ->
  main_window = new bw
    width: 400
    height: 300
  main_window.loadURL("file://#{__dirname}/index.html")
  main_window.webContents.openDevTools()
  main_window.on 'closed', ->
    main_window = null

app.on 'ready', ->
  create_window()

app.on 'window-all-closed', ->
  app.quit()

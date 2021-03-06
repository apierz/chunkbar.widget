command: "sh ./scripts/status.sh"

refreshFrequency: 5000 # ms

render: (output) ->
  """
    <link rel="stylesheet" type="text/css" href="./colors.css" />
    <div class="compstatus"></div>
  """

style: """
  right: 55px
  top: 5px
  height: 13
  .wifi
    font: 14px FontAwesome
    top: 1px
    position: relative
    left: 10px
  .charging
    font: 13px FontAwesome
    position: relative
    top: 0px
    right: -11px
    z-index: 1
  """
timeAndDate: (date, time) ->
  # returns a formatted html string with the date and time
  return "<span class='white'><span class='ricon'>&nbsp</span>#{date}&nbsp<span class='ricon'></span>#{time}</span></span>"

batteryStatus: (battery, state) ->
  #returns a formatted html string current battery percentage, a representative icon and adds a lighting bolt if the
  # battery is plugged in and charging
  batnum = parseInt(battery)
  if state == 'AC' and batnum >= 90
    return "<span class='charging battery sicon'></span><span class='green icon '></span><span class='white'>#{batnum}%</span>"
  else if state == 'AC' and batnum >= 75 and batnum < 90
    return "<span class='charging battery icon'></span><span class='green icon'></span><span class='white'>#{batnum}%</span>"
  else if state == 'AC' and batnum < 75 and batnum >= 50
    return "<span class='charging battery icon'></span><span class='yellow icon'></span><span class='white'>#{batnum}%</span>"
  else if state == 'AC' and batnum < 50 and batnum >= 15
    return "<span class='charging battery icon'></span><span class='orange icon'></span><span class='white'>#{batnum}%</span>"
  else if state == 'AC' and batnum < 15
    return "<span class='charging battery icon'></span><span class='red icon'></span><span class='white'>#{batnum}%</span>"
  else if batnum >= 90
    return "<span class='green icon'>&nbsp</span><span class='white'>#{batnum}%</span>"
  else if batnum >= 75 and batnum < 90
    return "<span class='green icon'>&nbsp</span><span class='white'>#{batnum}%</span>"
  else if batnum >= 50 and batnum < 75
    return "<span class='yellow icon'>&nbsp</span><span class='white'>#{batnum}%</span>"
  else if batnum < 50 and batnum >= 15
    return "<span class='orange icon'>&nbsp</span><span class='white'>#{batnum}%</span>"
  else if batnum < 15
    return "<span class='red icon'>&nbsp</span><span class='white'>#{batnum}%</span>"

getWifiStatus: (status, netName, netIP) ->
  if status == "Wi-Fi"
    return "<span class='wifi '>&nbsp&nbsp&nbsp</span><span class='white'>#{netName}&nbsp</span>"
  if status == 'USB 10/100/1000 LAN' or status == 'Apple USB Ethernet Adapter'
    return "<span class='wifi '>&nbsp&nbsp&nbsp</span><span class='white'>#{netIP}</span>"
  else
    return "<span class='grey wifi'>&nbsp&nbsp&nbsp</span><span class='white'>--&nbsp&nbsp&nbsp</span>"

getMailCount: (count) ->
  return "<span class='ricon'></span><span class=white>#{count}</span>"

getReminders: (reminders) ->
  return "<span class='reminders'><span class='ricon'></span></span><span class='white'>#{reminders}&nbsp</span>"


update: (output, domEl) ->

  # split the output of the script
  values = output.split('@')

  time = values[0].replace /^\s+|\s+$/g, ""
  date = values[1]
  battery = values[2]
  isCharging = values[3]
  netStatus = values[4].replace /^\s+|\s+$/g, ""
  netName = values[5]
  netIP = values[6]
  mail = values[7]
  reminders = values[8].replace /^\s+|\s+$/g, ""

  # create an HTML string to be displayed by the widget
  htmlString = @getWifiStatus(netStatus, netName, netIP) +
               @batteryStatus(battery, isCharging) + "<span class='cyan'>" + " ⎢ " + "</span>" +
               @getMailCount(mail) + "&nbsp&nbsp" +
               @getReminders(reminders) + "<span class='cyan'>⎢</span>" +
               @timeAndDate(date,time) + "<span class ='cyan'> ⎢</span>"

  $(domEl).find('.compstatus').html(htmlString)

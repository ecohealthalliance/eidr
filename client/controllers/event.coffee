Template.event.isEID = () ->
  @event?.eidVal is "1"

Template.event.rendered = () ->
  checkPosition = () -> 
    if($(this.$element).offset().top - $(window).scrollTop() < 150)
      'bottom'
    else 
      'top'
  makeTemplate = (className) ->
    template: 
      '<div class="popover" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content #{className}"></div><a href="#" class="close-popover"><span class="glyphicon glyphicon-remove-sign"></span></a></div>'
  baseOpts = 
    viewport:
      selector: 'body'
      padding: 10
    trigger: 'hover'
    placement: checkPosition
    animation: true
  $('[data-toggle="popover"]').popover(_.extend(baseOpts, makeTemplate('')))
  $('[data-toggle="popover-quote"]').popover(_.extend(baseOpts, makeTemplate('quote')))
  return

formatDate = (dateString) ->
  if dateString
    if dateString.length < 7
      dateString
    else
      year = dateString.substring(0, 4)
      month = parseInt(dateString.substring(5, 7), 10) - 1
      months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
      "#{months[month]} #{year}"

Template.event.helpers 
  simpleTitle : ->
    @eventNameVal.replace(/\(([^)]+)\)/, '')
  displayDates : ->
    if @startDateISOVal isnt "Not Found"
      startDate = @startDateISOVal
    if @endDateISOVal isnt "Not Found"
      endDate = @endDateISOVal

    if startDate
      formatDate startDate
    else if !startDate and endDate
      formatDate endDate
    else
      "Date not found"

  locationList : (locations) ->
    locations?.map (location) ->
      if location.fieldUsed is 'emergenceHospitalVal'
        "#{location.emergenceHospitalVal}, #{location.locationCityVal}, #{location.locationNationVal}"
      else if location.fieldUsed is 'locationCityVal'
        "#{location.locationCityVal}, #{location.locationNationVal}"
      else if location.fieldUsed is 'locationSubnationalRegionVal'
        "#{location.locationSubnationalRegionVal}, #{location.locationNationVal}"
      else if location.fieldUsed is 'locationNationVal'
        "#{location.locationNationVal}"
      else
        "Location Not Found"

Template.facts.helpers
  icons : ->
    @eventTransmissionVal.split(',').map (icon) ->
      console.log icon
      icon = icon.trim()
      if icon is 'Not Found'
        description = 'Transmission method not found'
        fullName = 'Not Found: ' + description
        icon = 'unknown'
      else
        description = @grid.Fields.findOne({"displayName" : "General Transmission"})['dropdownExplanations'][icon]
        fullName = icon.charAt(0).toUpperCase()+icon.substr(1)+': ' + description
      className: "type-"+icon.split(" ")[0].toLowerCase()
      fullName: fullName

Template.registerHelper 'getDescription', (event, field) ->
  info = grid.Fields.findOne({"spreadsheetName" : field})
  vals = Template.statsTable.getVal(info.spreadsheetName, event).trim().split(", ")
  explanations = ("#{val}: #{info.dropdownExplanations[val]}" for val in vals when info.dropdownExplanations[val]).join("; ")
  if explanations
    "#{info.description} (#{explanations})"
  else
    info.description

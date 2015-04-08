Template.event.isEID = () ->
  @event?.eidVal is "1"

Template.event.rendered = () ->
  checkPosition = () -> 
    if($(this.$element).offset().top - $(window).scrollTop() < 150)
      'bottom'
    else 
      'top'
  baseOpts = 
    viewport:
      selector: 'body'
      padding: 10
    trigger: 'hover'
    placement: checkPosition
    animation: true
  $('[data-toggle="popover"]').popover(baseOpts)
  $('[data-toggle="popover-quote"]').popover(_.extend(baseOpts, {template: '<div class="popover" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content quote-text"></div></div>'}))
  return

Template.event.helpers 
  simpleTitle : ->
    @eventNameVal.replace(/\(([^)]+)\)/, '')
  displayDates : ->
    if @startDateISOVal isnt "Not Found"
      startYear = @startDateISOVal.substring(0,4)
    if @endDateISOVal isnt "Not Found"
      endDate = @endDateISOVal.substring(0,4)

    if stateDate and endDate and startDate == endDate
      startDate
    else if startDate and !endDate
      startDate
    else if !startDate and endDate
      endDate
    else 
      "Date not found"

  locationList : (locations) ->
    if locations
      prefix = if locations?.length > 1 then 'Locations: ' else 'Location: '
      list = (location[location.fieldUsed] for location in locations).join(", ")
      "#{prefix}#{list}"

Template.facts.helpers
  icons : ->
    @eventTransmissionVal.split(',').map (icon) ->
      icon = icon.trim()
      if icon is 'Not Found'
        description = 'Transmission method not found'
        fullName = 'Not Found: ' + description
        icon = 'unknown'
      else
        description = @grid.Fields.findOne({"displayName" : "Event Transmission"})['dropdownExplanations'][icon]
        fullName = icon.charAt(0).toUpperCase()+icon.substr(1)+': ' + description
      className: "type-"+icon.split(" ")[0]
      fullName: fullName

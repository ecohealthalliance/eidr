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
      startYear = @startDateISOVal.substring(0,4)
      endYear = @endDateISOVal.substring(0,4)
      if startYear == endYear and startYear isnt "NF"
        startYear
      else if startYear isnt "NF" and endYear isnt "NF"
        startYear + " - " + endYear
      else if startYear and startYear isnt "NF" and (!endYear or endYear == "NF")
        startYear
      else if endYear and endYear isnt "NF" and (!startYear or startYear is "NF")
        endYear
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
      if icon is 'NF'
        description = 'Transmission method not found'
        fullName = icon+': ' + description
      else
        description = @grid.Fields.findOne({"displayName" : "Event Transmission"})['dropdownExplanations'][icon]
        fullName = icon.charAt(0).toUpperCase()+icon.substr(1)+': ' + description
      className: "type-"+icon.split(" ")[0]
      fullName: fullName

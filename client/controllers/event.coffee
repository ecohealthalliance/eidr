Template.event.isEID = () ->
  @event?.eidVal is "1"

Template.event.rendered = () ->
  $('[data-toggle="tooltip"]').tooltip(container: 'body', placement: 'bottom')
  $('[data-toggle="popover"]').popover(container: 'body', placement: 'auto right')
  $('[data-toggle="popover-quote"]').popover
    template: '<div class="popover" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content quote-text"></div></div>'
    container: 'body'
    placement: 'auto right'
  return

Template.event.helpers 
	simpleTitle : ->
		reg = /\(([^)]+)\)/
		@approxDate = reg.exec(@eventNameVal)[1].split(',')[1].trim()
		@eventNameVal.replace(reg, '')
	displayDates : ->
		if @startDateISOVal and @startDateISOVal isnt "NF" and @endDateISOVal and @endDateISOVal isnt "NF"
			startYear = @startDateISOVal.substring(0,4)
			endYear = @endDateISOVal.substring(0,4)
			if @startDateISOVal.substring(0,4) == @endDateISOVal.substring(0,4)
				startYear
			else 
				startYear + " - " + endYear
		else if @startDateISOValVal
			"Approximate date: "+ @startDateISOVal.substring(0,4)
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

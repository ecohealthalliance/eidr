Template.event.isEID = () ->
  @event?.eidVal is "1"

Template.event.rendered = () ->
	$('[data-toggle="tooltip"]').tooltip(container: 'body', placement: 'bottom')
	$('[data-toggle="popover"]').popover(container: 'body', placement: 'bottom')
	return

Template.event.helpers 
	simpleTitle : ->
		reg = /\(([^)]+)\)/
		@approxDate = reg.exec(@eventNameVal)[1].split(',')[1].trim()
		@eventNameVal.replace(reg, '')
	displayDates : ->
		if @startDateISO and @startDateISO isnt "NF" and @endDateISO and @endDateISO isnt "NF"
			startYear = @startDateISO.substring(0,4)
			endYear = @endDateISO.substring(0,4)
			if @startDateISO.substring(0,4) == @endDateISO.substring(0,4)
				startYear
			else 
				startYear + " - " + endYear
		else
			"Approximate date: "+ @approxDate.substring(0,4)
	locationList : (locations) ->
    if locations
      prefix = if locations?.length > 1 then 'Locations: ' else 'Location: '
      list = (location[location.fieldUsed] for location in locations).join(", ")
      "#{prefix}#{list}"

Template.facts.helpers
	icons : ->
		@eventTransmissionVal.split(',').map (icon) ->
			if icon is 'NF'
				description = 'Transmission method not found'
			else
				description = @grid.Fields.findOne({"displayName" : "Event Transmission"})['dropdownExplanations'][icon]
			console.log @grid.Fields.findOne({"displayName" : "Event Transmission"})
			iconName = icon.trim().split(" ")[0]
			className: "type-"+iconName
			fullName: iconName.charAt(0).toUpperCase()+iconName.substr(1).toLowerCase()+': ' + description

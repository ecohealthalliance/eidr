Template.event.isEID = () ->
  @event?.eidVal is "1"

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
			if icon is 'NF'
				description = 'Transmission method not found'
			else
				description = @grid.Fields.findOne({"displayName" : "Event Transmission"})['dropdownExplanations'][icon]
			className: "type-"+icon.trim().split(" ")[0]
			fullName: icon + ': ' + description

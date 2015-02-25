Template.event.isEID = () ->
  @event?.eidVal is "1"

Template.event.helpers 
	simpleTitle : ->
		reg = /\(([^)]+)\)/
		@approxDate = reg.exec(@eventName)[1].split(',')[1].trim()
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

Template.facts.showIcon = () ->
	@typeIcons = @eventTransmissionVal.split(',')
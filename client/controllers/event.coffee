Template.event.isEID = () ->
  @event?.eidVal is "1"

Template.event.helpers simpleTitle : ->
		console.log(this)
		reg = /\(([^)]+)\)/
		@approxDate = reg.exec(@eventName)[1].split(',')[1].trim()
		@eventName.replace(reg, '')

Template.event.helpers displayDates : ->
		if @startDateISO and @startDateISO isnt "NF" and @endDateISO and @endDateISO isnt "NF"
			"#{@startDateISO} - #{@endDateISO}"
		else
			"Approximate date: #{@approxDate}"
Template.event.isEID = () ->
  @event?.eidVal is "1"

Template.event.helpers simpleTitle : () ->
	reg = /\(([^)]+)\)/
	this.approxDate = reg.exec(this.eventNameVal)[1].split(',')[1].trim()
	this.eventName.replace(reg, '')
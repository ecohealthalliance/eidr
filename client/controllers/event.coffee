getEvent = () =>
  @grid.Events.findOne({eidID: Session.get('eidID')})

Template.event.isEID = () ->
  getEvent()?.eidVal is "1"

Template.event.event = () ->
  getEvent()

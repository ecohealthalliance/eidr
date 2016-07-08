Template.createEvent.helpers
  currentCount: () ->
    return grid.UserEvents.find().count()
		
Template.createEvent.events
  "submit #add-event": (e) ->
    e.preventDefault()
    newEvent = e.target.eventName.value
    if newEvent.trim().length isnt 0
      grid.UserEvents.insert
        eventName: newEvent
    e.target.eventName.value = ''
Template.userEvent.onCreated ->
  @editState = new ReactiveVar(false)

Template.userEvent.helpers
  isEditing: () ->
    return Template.instance().editState.get()

Template.userEvent.events
  "click #edit, click #cancel-edit": (event, template) ->
    template.editState.set(not template.editState.get())
  
  "submit #editEvent": (event, template) ->
    event.preventDefault()
    updatedName = event.target.eventName.value.trim()
    if updatedName.length isnt 0
      grid.UserEvents.update(@_id, {$set: {eventName: updatedName}})
      template.editState.set(false)

Template.createEvent.onCreated ->
  @locationSequence = 0
  @tempLocations = new ReactiveVar([])

Template.createEvent.helpers
  tempLocations: () ->
    return Template.instance().tempLocations.get()

Template.createEvent.events
  "click #add-location": (e, template) ->
    template.locationSequence++
    locations = template.tempLocations.get()
    locations.push(template.locationSequence)
    template.tempLocations.set(locations)
    
  "click .remove-location": (e, template) ->
    $target = $(e.target)
    if $target.hasClass("fa")
      $target = $target.parent()
    
    locationId = $target.data("location-id")
    locations = template.tempLocations.get()
    counter = locations.length - 1
    
    for i in [counter..0]
      if locations[i] is locationId
        locations.splice(i, 1)
    
    template.tempLocations.set(locations)
    
  "submit #add-event": (e) ->
    e.preventDefault()
    newEvent = e.target.eventName.value
    locationFields = $(e.target).find("input.location-input")
    locations = []
    locations.push({url: $(input).val()}) for input in locationFields
    
    Meteor.call("addUserEvent", newEvent, locations, (error, result) ->
      if result
        Router.go('user-event', {_id: result})
    )
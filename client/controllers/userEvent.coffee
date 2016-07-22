#Allow multiple modals or the suggested locations list won't show after the loading modal is hidden
Modal.allowMultiple = true

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

Template.createEvent.events
  "submit #add-event": (e) ->
    e.preventDefault()
    newEvent = e.target.eventName.value
    
    $new = $("#location-select2")
    locations = []
    
    for option in $new.select2("data")
      locations.push({
        geonameId: option.item.geonameId,
        name: option.item.name,
        countryCode: option.item.countryCode,
        latitude: option.item.latitude,
        longitude: option.item.longitude
      })
    
    
    Meteor.call("addUserEvent", newEvent, locations, (error, result) ->
      if result
        Router.go('user-event', {_id: result})
    )
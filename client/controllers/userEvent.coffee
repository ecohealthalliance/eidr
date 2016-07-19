Template.userEvent.onCreated ->
  @editState = new ReactiveVar(false)
  @currentLocations = []
  for location in @data.locations
    @currentLocations.push(location.geonameId)

Template.userEvent.onRendered ->
  $(document).ready(() ->
    $("#new-location").select2({
      createSearchChoice: (term, data) ->
        return {url: term}
      multiple: false
    })
  )

Template.userEvent.helpers
  isEditing: () ->
    return Template.instance().editState.get()
  suggestLocations: () ->
    for article in @articles
      for location in article.locations
        if Template.instance().currentLocations.indexOf(location.geonameId) is -1 and location.name.match(regex) and uniqueIds.indexOf(location.geonameId) is -1
          uniqueIds.push(location.geonameId)
          suggested.push(location)
    return suggested

Template.userEvent.events
  "click #edit, click #cancel-edit": (event, template) ->
    template.editState.set(not template.editState.get())
  
  "submit #editEvent": (event, template) ->
    event.preventDefault()
    updatedName = event.target.eventName.value.trim()
    if updatedName.length isnt 0
      grid.UserEvents.update(@_id, {$set: {eventName: updatedName}})
      template.editState.set(false)
  
  "click #add-location": (event, template) ->
    $input = $("#new-location")
    Meteor.call("addEventLocations", template.data.userEvent._id, [{url: $input.val()}], (error, result) ->
      if not error
        console.log(grid.Geolocations.find({_id: result}).fetch())
        $input.val("")
    )
  
  "click .remove-location": (event, template) ->
    if confirm("Do you want to delete the selected location?")
      Meteor.call("removeEventLocation", @_id)

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
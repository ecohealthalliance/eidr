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
Template.admins.rendered = () ->
  Template.admins.users = @data.users

Template.admins.helpers
  isAdmin : (userId) ->
    Roles.userIsInRole(userId, ['admin'])
  isCurrentUser : (userId) ->
    userId == Meteor.userId()

Template.admins.events
  'click .make-admin' : (event) ->
    userId = event.target.getAttribute('user-id')
    Meteor.call('makeAdmin', userId)

  'click .remove-admin' : (event) ->
    userId = event.target.getAttribute('user-id')
    Meteor.call('removeAdmin', userId)

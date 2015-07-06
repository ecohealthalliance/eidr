Template.adminUser.helpers
  isCurrentUser : () ->
    this._id == Meteor.userId()

  isAdmin : () ->
    Roles.userIsInRole(this._id, ["admin"])

  name : () ->
    this.profile.name

  email : () ->
    this.services.google.email

Template.adminUser.events
  'click .make-admin' : (event) ->
    userId = event.target.getAttribute('user-id')
    Meteor.call('makeAdmin', userId)

  'click .remove-admin' : (event) ->
    userId = event.target.getAttribute('user-id')
    Meteor.call('removeAdmin', userId)

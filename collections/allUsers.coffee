if Meteor.isServer
  Meteor.publish "allUsers", () ->
    if Roles.userIsInRole(this.userId, ['admin'])
      Meteor.users.find({}, {fields: {'_id': 1, 'services.google.email': 1, 'roles': 1}})
    else
      this.ready()

  Meteor.methods
    makeAdmin : (userId) ->
      Roles.addUsersToRoles(userId, ['admin'])

    removeAdmin : (userId) ->
      Roles.removeUsersFromRoles(userId, 'admin')

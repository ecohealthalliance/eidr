if Meteor.isServer
  Meteor.publish "allUsers", () ->
    if Roles.userIsInRole(this.userId, ['admin'])
      Meteor.users.find({}, {fields: {'_id': 1, 'services.google.email': 1, 'roles': 1, 'profile.name': 1}})
    else
      this.ready()

  Meteor.methods
    makeAdmin : (userId) ->
      currentUserId = Meteor.userId()
      if Roles.userIsInRole(currentUserId, ['admin'])
        Roles.addUsersToRoles(userId, ['admin'])
      else
        throw new Meteor.Error(403, "Not authorized")

    removeAdmin : (userId) ->
      currentUserId = Meteor.userId()
      if Roles.userIsInRole(currentUserId, ['admin'])
        Roles.removeUsersFromRoles(userId, 'admin')
      else
        throw new Meteor.Error(403, "Not authorized")

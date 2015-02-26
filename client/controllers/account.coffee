Template.account.auth = () ->
  Meteor.user()

Template.account.events
  "click #logOut" : () ->
    Meteor.logout()

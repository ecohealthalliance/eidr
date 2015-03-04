Template.header.helpers
  checkUser : () ->
    Meteor.user().emails[0].address.search("ecohealthalliance.org") > 0
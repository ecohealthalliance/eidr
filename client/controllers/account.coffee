Template.account.events
  "click #logOut" : () ->
    Meteor.logout()

AccountsTemplates.configureRoute 'signIn', redirect: () ->

AccountsTemplates.configureRoute 'enrollAccount', redirect: () ->

AccountsTemplates.configure
  showForgotPasswordLink: true

AccountsTemplates.addFields [
  {
    _id: 'username'
    type: 'text'
    placeholder:
      signUp: "Username"
    required: true,
    minLength: 4
  }
  {
    _id: 'email'
    type: 'email'
    required: true
    displayName: "email"
    re: /.+@(.+){2,}\.(.+){2,}/
    errStr: 'Invalid email'
  }
]
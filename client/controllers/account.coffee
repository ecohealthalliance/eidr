Template.account.events
  "click #logOut" : () ->
    Meteor.logout()

AccountsTemplates.configureRoute 'signIn',
  redirect: () ->
    if window.location.pathname == '/sign-in'
      Router.go '/' 

AccountsTemplates.configure
  hideSignUpLink: true

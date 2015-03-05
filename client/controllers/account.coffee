Template.account.events
  "click #logOut" : () ->
    Meteor.logout()

checkPage = () ->
  if window.location.pathname == '/sign-in'
        Router.go '/'

AccountsTemplates.configureRoute 'signIn',
  redirect: checkPage

AccountsTemplates.configureRoute 'enrollAccount',
  redirect: checkPage
    

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
]
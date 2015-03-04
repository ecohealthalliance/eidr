Template.account.events
  "click #logOut" : () ->
    Meteor.logout()

AccountsTemplates.configureRoute('signIn', {
    redirect: () ->
})

AccountsTemplates.configureRoute('enrollAccount', {
    redirect: () ->
})

AccountsTemplates.configure
  showForgotPasswordLink: true

AccountsTemplates.addField({
    _id: 'username',
    type: 'text',
    placeholder: {
        signUp: "Username"
    },
    required: true,
    minLength: 4
});

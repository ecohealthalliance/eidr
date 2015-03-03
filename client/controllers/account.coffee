Template.account.events
  "click #logOut" : () ->
    Meteor.logout()

AccountsTemplates.configureRoute('signIn', {
    redirect: false
})

AccountsTemplates.configureRoute('enrollAccount', {
    redirect: false
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

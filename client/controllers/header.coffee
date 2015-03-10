Template.navLinks.events
  'click' : () ->
    if($('.navbar-toggle').is(':visible'))
      $('.navbar-collapse').collapse('toggle')
Template.varDefs.helpers
  groupValues: (fields) ->
    catagories = 
      _.chain(fields.fetch())
      .filter((field) -> field.webVariable is '1')
      .groupBy('tab')
      .omit('')
      .value()
    for key, value of catagories
      value
  addTitle: (v) ->
    if v[0].tab is 'Stats'
      'Descriptive Epidemiology Variables'     
    else
      v[0].tab
  displayValues: (values) ->
    for key, value of values
      type: key
      explanation: value

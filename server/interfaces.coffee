Meteor.methods
  getArticleLocations: (url) ->
    HTTP.call("POST", "http://grits.eha.io:80/api/v1/public_diagnose", {params: {api_key: "grits28754", content: url}}, (error, response) ->
      console.log(response.data)
    )
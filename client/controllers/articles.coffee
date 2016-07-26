Template.articles.events
  "submit #add-article": (e) ->
    event.preventDefault()
    article = e.target.article.value.trim()
    if article.length isnt 0
      existingArticle = grid.Articles.find({url: article, userEventId: @userEvent._id}).fetch()

      if existingArticle.length is 0
        grid.Articles.insert
          url: article
          userEventId: @userEvent._id
      e.target.article.value = ''

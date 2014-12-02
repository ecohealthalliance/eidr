search = () ->
  request = @request
  response = @response
  queryString = @request.body.query || ""
  options = @request.body.options || {size: 10}
  result = HTTP.post(
    "http://localhost:9200/item_index/_search",
    data:
      query:
        query_string:
          query: queryString
    params: options
  )
  if result?.content
    hits = JSON.parse(result.content).hits
    gridEvents = ({
      score: hit._score
      id: hit._source.eidID
      name: hit._source.eventName
    } for hit in hits.hits)
    response.end(JSON.stringify({results: gridEvents, total: hits.total}))
  else
    response.end(JSON.stringify([]))

Router.route "/search", search,
  where: 'server'

getEvent = () =>
  @grid.Events.findOne({eidID: Session.get('eidID')})

Template.map.rendered = () ->
  w = 400
  h = 230

  eid = getEvent()?.eidID

  projection = d3.geo.mercator()
    .translate([w/2, h/2])
    .scale([50])

  path = d3.geo.path()
    .projection(projection)
    .pointRadius(4)

  svg = d3.select('.map')
    .append('svg')
    .attr('width', w)
    .attr('height', h)

  world = svg.append('g')
  centroids = svg.append('g')


  d3.json '/world-110m2.json', (error, topology) ->
    world.selectAll("path")
      .data(topojson.object(topology, topology.objects.countries).geometries)
    .enter()
      .append("path")
      .attr("d", path)
      .style("fill", "steelblue")

    d3.json '/centroids.json', (eids) ->

      features = []

      for feature in eids.features
        if feature.properties.id is 'HED_' + eid
          features.push(feature)
          break

      centroids.selectAll("path")
        .data(features)
        .enter()
        .append("path")
        .attr("d", path)
        .style "fill", (d) ->
            type = d.geometry.type
            if type is "Point"
              return "crimson"
            else
              return "steelblue"

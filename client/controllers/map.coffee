Template.map.rendered = () ->
  eventMap = L.map('map').setView([0, -0], 1);
  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', 
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors')
    .addTo eventMap
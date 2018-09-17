if ($('#map_holder')) {
  var map = L.map('map_holder').setView([-36.878167, 175.041337], 13);

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);

  L.marker([-36.878167, 175.041337]).addTo(map)
    .bindPopup('Maraetai Sailing Club')
    .openPopup();

  map.dragging.disable();
  map.scrollWheelZoom.disable();
};

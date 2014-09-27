function setupVenueMap(mapOptions) {
  var venue_map = new google.maps.Map(document.getElementById("venue-map"),
    mapOptions);

  var ceremony_content = '<div id="content">' +
    '<h3>Mount Zion Baptist Church</h3>' +
    '<div>228 Mount Zion Road, Huntsville, AL 35806</div>' +
    '</div>';

  var reception_content = '<div id="content">' +
    '<h3>The Ledges</h3>' +
    '<div>Huntsville, AL</div>' +
    '</div>';

  var ceremony_infoWindow = new google.maps.InfoWindow({
    content: ceremony_content,
    maxWidth: 400
  });

  var reception_infoWindow = new google.maps.InfoWindow({
    content: reception_content,
    maxWidth: 400
  });

  var ceremony = new google.maps.LatLng(34.786525, -86.718898);
  var ceremony_marker = new google.maps.Marker({
    position: ceremony,
    map: venue_map,
    title: "Ceremony",
    icon: 'assets/ceremony-icon.png'
  });

  var reception = new google.maps.LatLng(34.671306, -86.518896);
  var reception_marker = new google.maps.Marker({
    position: reception,
    map: venue_map,
    title: "Reception",
    icon: 'assets/reception-icon.png'
  });

  google.maps.event.addListener(ceremony_marker, 'click', function () {
    ceremony_infoWindow.open(venue_map, ceremony_marker);
  });

  google.maps.event.addListener(reception_marker, 'click', function () {
    reception_infoWindow.open(venue_map, reception_marker);
  });

  $('#ceremony').click(function() {
    venue_map.setCenter(ceremony_marker.getPosition());
    venue_map.setZoom(15);
  });

  $('#reception').click(function() {
    venue_map.setCenter(reception_marker.getPosition());
    venue_map.setZoom(15);
  });
}

function initialize() {
  var vMapOptions = {
    center: new google.maps.LatLng(34.730369, -86.586104),
    zoom: 11
  };

  setupVenueMap(vMapOptions);
}
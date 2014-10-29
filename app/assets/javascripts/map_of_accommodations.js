function setupAccommodationMap(mapOptions) {
  var accommodation_map = new google.maps.Map(document.getElementById("accommodation-map"),
    mapOptions);

  var hotel = new google.maps.LatLng(34.754552, -86.694173);
  var hotel_marker = new google.maps.Marker({
    position: hotel,
    map: accommodation_map,
    title: "Homewood Suites by Hilton"
  });

  var airport = new google.maps.LatLng(34.648412, -86.775272);
  var airport_marker = new google.maps.Marker({
    position: airport,
    map: accommodation_map,
    title: "Airport"
  });

  $('#hotel').click(function() {
    accommodation_map.setCenter(hotel_marker.getPosition());
    accommodation_map.setZoom(15);
  });

  $('#airport').click(function() {
    accommodation_map.setCenter(airport_marker.getPosition());
    accommodation_map.setZoom(15);
  });
}
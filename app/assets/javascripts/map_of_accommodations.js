function setupAccommodationMap(mapOptions) {
    var accommodation_map = new google.maps.Map(document.getElementById("accommodation-map"),
        mapOptions);

    var hotel_content = '<div id="content">' +
        '<h4>Homewood Suites by Hilton</h4>' +
        '<div>Village of Providence<br>15 Town Center Drive<br>Huntsville, AL 35806<br>256-895-9511</div>' +
        '<div><a href="http://tinyurl.com/BrazeltonKazembereservations" target="_blank">http://tinyurl.com/BrazeltonKazembereservations</a></div>' +
        '</div>';

    var airport_content = '<div id="content">' +
        '<h4>Huntsville International Airport (HSV)</h4>' +
        '<div>1000 Glenn Hearn Blvd SW<br>Huntsville, AL 35824</div>' +
        '</div>';

    var hotel_infoWindow = new google.maps.InfoWindow({
        content: hotel_content,
        maxWidth: 400
    });

    var airport_infoWindow = new google.maps.InfoWindow({
        content: airport_content,
        maxWidth: 400
    });

    var hotel = new google.maps.LatLng(34.754552, -86.694173);
    var hotel_marker = new MarkerWithLabel({
        position: hotel,
        map: accommodation_map,
        title: "Homewood Suites by Hilton",
        icon: ' ',
        labelContent: '<i class="fa fa-bed fa-3x" style="color:rgb(127,0,127);"></i>',
        labelAnchor: new google.maps.Point(22, 50)
    });

    var airport = new google.maps.LatLng(34.648412, -86.775272);
    var airport_marker = new MarkerWithLabel({
        position: airport,
        map: accommodation_map,
        icon: ' ',
        labelContent: '<i class="fa fa-plane fa-3x" style="color:rgb(127,0,127);"></i>',
        labelAnchor: new google.maps.Point(22, 50)
    });

    google.maps.event.addListener(hotel_marker, 'click', function () {
        hotel_infoWindow.open(accommodation_map, hotel_marker);
    });

    google.maps.event.addListener(airport_marker, 'click', function () {
        airport_infoWindow.open(accommodation_map, airport_marker);
    });

    $('#hotel').click(function () {
        accommodation_map.setCenter(hotel_marker.getPosition());
        accommodation_map.setZoom(15);
    });

    $('#airport').click(function () {
        accommodation_map.setCenter(airport_marker.getPosition());
        accommodation_map.setZoom(15);
    });
}

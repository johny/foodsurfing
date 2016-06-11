
var FoodSurfing = {

  _options: {
    center: {
      lat: 50.06,
      lng: 19.98
    },
    zoom: 12,
    scrollwheel: false,
    styles: [{"featureType":"road","elementType":"geometry","stylers":[{"lightness":100},{"visibility":"simplified"}]},{"featureType":"water","elementType":"geometry","stylers":[{"visibility":"on"},{"color":"#C6E2FF"}]},{"featureType":"poi","elementType":"geometry.fill","stylers":[{"color":"#C5E3BF"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#D1D1B8"}]}]
  },

  init: function(){

    this.initLargeMap();
    this.initGeocodeMap();
    this.initMarkerMap();

    this.initErrors();

    this.initFB();

    this.setupFilters();
  },

  initErrors: function(){
    $('.formError').each(function(index, item){
      $(item).parents('.form-group').addClass('has-error');
    });
  },

  setupFilters: function(){
    $('.filters a').on('click', function(event){
      event.preventDefault();
      $(this).toggleClass('active');

      window.google_map.setZoom(13);
    });
  },

  initFB: function(){
    $('.js-button-share').on('click', function(event){
      event.preventDefault();

      FB.ui({
          method: 'share',
          href: $(this).data('uri')
        }, function(response){

        });
      });
  },

  initLargeMap: function(){

    var map = $("#map");
    if(map.length === 0) return;

    this._options.mapTypeId = google.maps.MapTypeId.ROADMAP;

    window.google_map = new google.maps.Map(map.get(0), this._options);

    if(typeof Meals !== "undefined"){
      for(var i = 0; i < Meals.length; i++){

        var meal = Meals[i];

        var marker = new google.maps.Marker({
          map: google_map,
          url: meal.url,
          position: new google.maps.LatLng(meal.lat, meal.lng)
        });

        // store the reference
        meal.marker = marker;

        google.maps.event.addListener(marker, 'click', function() {
          window.location.href = this.url;
        });
      }
    }

  },

  initGeocodeMap: function(){
    var minimap = $("#minimap");
    if(minimap.length === 0) return;

    // init geocoder
    var geocoder = new google.maps.Geocoder();

    // init map
    var google_minimap = new google.maps.Map(minimap.get(0), this._options);

    // on blur
    $('#user_street_address').on('blur', function(event){

      var street = $("#user_street_address").val();
      var city = $("#user_city").val();

      var address = street + ", " + city;

      // geocode the address
      geocoder.geocode({'address': address}, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {

          var pos = results[0].geometry.location;

          google_minimap.setCenter(pos);



          var marker = new google.maps.Marker({
            map: google_minimap,
            position: pos
          });

          google_minimap.setZoom(16)

          $("#user_latitude").val(pos.lat());
          $("#user_longitude").val(pos.lng());



        } else {
          console.log('Geocode was not successful for the following reason: ' + status);
        }
      });
    });

  },

  initMarkerMap: function(){
    var map = $("#markermap");
    if(map.length === 0) return;

    var google_map = new google.maps.Map(map.get(0), {zoom: 14, scrollwheel: false, disableDefaultUI: true});


    if(typeof MealMarker !== "undefined"){

        var marker = new google.maps.Marker({
          map: google_map,
          position: new google.maps.LatLng(MealMarker.lat, MealMarker.lng)
        });

        // store the reference
        MealMarker.marker = marker;
        google_map.setCenter(marker.position)

        // google.maps.event.addListener(marker, 'click', function() {
        //   window.location.href = marker.url;
        // });
    }

  }


};

$(document).ready(function($){
  $(document).on('page:change', $.proxy(FoodSurfing.init, FoodSurfing));
});

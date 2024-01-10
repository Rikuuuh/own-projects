<?php
// Start session
session_start();
$title = "Huntshop | Contact";
require('templates/header.php');

?>
<section id="cart-header">
	<h2><i class="fa-solid fa-globe"></i>   Contact Us</h2>
</section>
<section id="contact-details" class="section-p1">
	<div class="details">
		<span>GET IN TOUCH</span>
		<h2>Visit one of  our agency locations or contact us today!</h2>
		<h3>Head Office</h3>
		<div>
			<li>
				<i class="fa-solid fa-map-location-dot"></i>
				<p>Microkatu 1, 70210 Kuopio</p>
			</li>
			<li>
				<i class="fa-solid fa-envelope"></i>
				<p>contact@huntshop.com</p>
			</li>
			<li>
				<i class="fa-solid fa-phone"></i>
				<p>(+358) 044999996</p>
			</li>
			<li>
				<i class="fa-solid fa-clock"></i>
				<p>Monday to Saturday 4.00pm to 9pm</p>
			</li>
		</div>
	</div>
	<div class="map" id="map">
  <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAsU9qD7YD1YuRRw7dgEcv6Bcd1zWHGmsQ&callback=initMap"></script>
  <script>
    function initMap() {
      var map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: 62.888883827703395, lng: 27.624686316552207},
        zoom: 15,
        styles: [
          {
            "featureType": "all",
            "elementType": "all",
            "stylers": [
              {
                "invert_lightness": true
              },
              {
                "saturation": 20
              },
              {
                "lightness": 50
              },
              {
                "gamma": 0.4
              },
              {
                "hue": "#00ffee"
              }
            ]
          },
          {
            "featureType": "all",
            "elementType": "geometry",
            "stylers": [
              {
                "visibility": "simplified"
              }
            ]
          },
          {
            "featureType": "all",
            "elementType": "labels",
            "stylers": [
              {
                "visibility": "on"
              }
            ]
          },
          {
            "featureType": "administrative",
            "elementType": "all",
            "stylers": [
              {
                "color": "#ffffff"
              },
              {
                "visibility": "simplified"
              }
            ]
          },
          {
            "featureType": "administrative.land_parcel",
            "elementType": "geometry.stroke",
            "stylers": [
              {
                "visibility": "simplified"
              }
            ]
          },
          {
            "featureType": "landscape",
            "elementType": "all",
            "stylers": [
              {
                "color": "#405769"
              }
            ]
          },
          {
            "featureType": "water",
            "elementType": "geometry.fill",
            "stylers": [
              {
                "color": "#232f3a"
              }
            ]
          }
        ]
      });
      var marker = new google.maps.Marker({
      position: {lat: 62.888883827703395, lng: 27.624686316552207},
      map: map,
      title: 'Location',
      icon: 'https://maps.google.com/mapfiles/ms/icons/orange-dot.png'
  });
    }
  </script>
</div>
</section>
<section id="form-details">
	<form action="sendmail.php" method="POST">
		<h2>Leave a message</h2>
		<input type="text" name="name" placeholder="Your Name" class="form-control" required>
		<input type="text" name="phone" placeholder="Your Phone Num" class="form-control" required>
		<textarea name="message" class="form-control" cols="30" rows="10" placeholder="Your Message"></textarea required>
		<button class="normal" type="submit">Submit</button>
	</form>
	<div class="people">
		<div>
			<img src="https://www.looper.com/img/gallery/the-untold-truth-of-john-wick/intro-1554306903.jpg" alt="">
			<p><span>John W.</span>Huntroad Marketing Manager<br>Phone : +358 044999994<br>Email : contact@huntshop.com</p>
		</div>
	</div>
</section>
<?php require('templates/newsletter.php'); ?>
<?php require('templates/footer.php'); ?>
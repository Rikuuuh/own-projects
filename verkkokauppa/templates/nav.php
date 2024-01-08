<?php
require_once('lib/db.php');
require_once('lib/class.base.php');
require_once('lib/class.AllInOne.php');
$database = new AllInOne($sql, 'cart');
?>
<div id="message-container"></div>

<?php
if (isset($_SESSION['success_message'])) {
  echo '<div class="message">' . $_SESSION['success_message'] . '</div>';
  unset($_SESSION['success_message']);
}
?>
<?php
if($_GET['messagesent'] == 1) { // sendmail.php:eesta tulee messagesent1
	echo '<h2 class="message">Thank you for your message. Expect to hear from us shortly!</h2>';
}

if($_GET['sendletter'] == 1) { // sendletter.php:eesta tulee sendletter1 
	echo '<h2 class="message">Thank you for signing up. Expect to hear from us shortly!</h2>';
}
//Näytetään errorit login kohdasta
if(isset($_GET['error']) && $_GET['error'] === 'login_failed') { 
    echo '<h2 class="messagee">Login failed. Please try again.</h5>';
    } else if(isset($_GET['error']) && $_GET['error'] === 'empty_fields') { 
    echo '<h2 class="messagee">Please fill in both fields.</h5>';
    }       
?>
<section id="header">
  <a href="index.php"><img src="images/taaa.png" class="logo" alt=""></a>
  <div class="center">
  <?php
    // Tsekataan onko käyttäjä jo sisäänkirjautunut
    if(isset($_SESSION['logged_id'])) { 
      ?>
      <?php 
        echo tervehdi(); // Näytetään terve ja nimi
      ?>
      <a href="modifyUser.php" style="text-decoration:none; color:#2A3132;"><button id="show-logout" style="margin-bottom: 5px;"><i class="fa-solid fa-gear"></i>Customer Info</button></a>
      <!-- Jos logannut sisään, näytetään logout buttoni -->
      <form action="do-logout.php" method="POST">
        <button id="show-logout">Logout <i class="fa-solid fa-right-from-bracket"></i></button>
      </form>
    <?php 
    } else { 
      ?>
      <!-- Jos ei ole sisäänkirjautunut -> näytetään login buttoni -->
      <button id="show-login"><i class="fa-solid fa-right-to-bracket"></i> Login</button>
    <?php 
    } 
  ?>
</div>
  <div class="popup">
    <div class="close-btn">&times;</div>
    <div class="form">
      <form action="do-login.php" method="POST">
        <h2>Log in</h2>
        <div class="form-element">
          <label for="email">Email</label>
          <input type="text" id="username" name="username" placeholder="Enter Your Email" required>
        </div>
        <div class="form-element">
          <label for="password">Password</label>
          <input type="password" id="password" name="password" placeholder="Enter Your Password" required>
        </div>
        <div class="form-element">
          <input type="checkbox" id="remember-me">
          <label for="remember-me">Remember Me</label>
        </div>
        <div class="form-element">
          <button>Sign In</button>
        </div>
      </form>
      <div class="form-element">
        <h4>Not yet member of Huntshop?<a href="register.php">Register Here</a></h4>
      </div>
    </div>
  </div>
    <div>
        <ul id="navbar">
            <li><a <?php if(strpos($_SERVER['PHP_SELF'], 'index.php') !== false) echo 'class="active"'; ?> href="index.php">Home</a></li>
            <li><a <?php if(strpos($_SERVER['PHP_SELF'], 'aboutUs.php') !== false) echo 'class="active"'; ?> href="aboutUs.php">About</a></li>
            <li><a <?php if(strpos($_SERVER['PHP_SELF'], 'contact.php') !== false) echo 'class="active"'; ?> href="contact.php">Contact</a></li>
            <li><a <?php if(strpos($_SERVER['PHP_SELF'], 'shop.php') !== false) echo 'class="active"'; ?> href="shop.php?category=Hunting Guns">Shop</a></li>
            <li id="lg-bag">
                <a <?php if(strpos($_SERVER['PHP_SELF'], 'cart.php') !== false) echo 'class="active"'; ?> href="cart.php">
                    <i class="fas fa-shopping-cart <?php if(strpos($_SERVER['PHP_SELF'], 'cart.php') !== false) echo 'active'; ?>"></i>
                    <span class="cart-item-count" id="cart-count"><?php echo $database->getCartItemCount(session_id()); ?></span>
                </a>
            </li>
            <a href="#" id="close"> <i class="fa fa-times"></i></a>
        </ul>
    </div>
    <div id="mobile">
        <a <?php if(strpos($_SERVER['PHP_SELF'], 'cart.php') !== false) echo ' class="active"'; ?> href="cart.php"><i class="fas fa-shopping-cart"></i></a>
        <span class="cart-item-count" id="cart-count" style="font-size: 1.5em; color: red;"><?php echo $database->getCartItemCount(session_id()); ?></span>
        <i id="bar" class="fas fa-outdent"></i>
    </div>
</section>
<script>
function getCartCount(sessionid) {
$.ajax({
  url: 'getCartCount.php',
  method: 'POST',
  data: {sessionid: sessionid},
  success: function(response) {
    $('#cart-count').html(response);
  }
});
}
// Call the function when the document is ready
$(document).ready(function() {
  getCartCount("<?php echo session_id(); ?>");
});
</script>
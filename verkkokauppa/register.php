<?php
// Start session
session_start();
$title = "Huntshop | Register";
require('templates/header.php');

?>
<section id="cart-header">
  <h2><i class="fa-solid fa-id-card"></i>    Register</h2>
</section>

<section id="form-details">
  <form action="do-register.php" method="POST">
    <h2>Register Now!</h2>
    <input type="text" name="firstname" placeholder="Your First Name" class="form-control"required>
	<input type="text" name="lastname" placeholder="Your Last Name" class="form-control"required>
	<input type="text" name="country" placeholder="Your Country" class="form-control"required>
	<input type="text" name="city" placeholder="Your City" class="form-control"required>
	<input type="text" name="address" placeholder="Your Address" class="form-control"required>
	<input type="text" name="zip" placeholder="Your Zip" class="form-control"required>
	<input type="text" name="phone" placeholder="Your Phone Number" class="form-control"required>
    <input type="email" name="email" placeholder="Your Email" class="form-control"required>
	<input type="password" name="password" placeholder="Your Password" class="form-control"required>
    <input type="password" name="repeat_password" placeholder="Repeat Your Password" class="form-control"required>
    <button class="normal" type="submit">Register</button>
  </form>
  <?php
	// Katsotaan löytyykö sessiosta virheitä
	if(is_array($_SESSION['errors']) && count ($_SESSION['errors']) > 0) {	
		// Loopataan virheet läpi ja tulostetaan ne
		foreach($_SESSION['errors'] as $error) {
			echo $error . '<br>';
		}
		// Virheet näytetty, poistetaan ne
		unset($_SESSION['errors']);
	}		
  ?>
</section>


<?php require('templates/footer.php'); ?>
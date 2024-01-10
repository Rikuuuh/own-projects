<?php
// Start session
session_start();
$title = "Huntshop | Modify User";
require('templates/header.php');

if (isset($_SESSION['logged_id'])) {
  $customer_id = $_SESSION['logged_id'];
  $database = new AllInOne($sql, 'customer');
  $customer = $database->getCustomer($customer_id);
}
if (isset($_POST['changeInfo'])) {

    $customer_id = $_SESSION['logged_id'];
    $database = new AllInOne($sql, 'customer');
    $customer = $database->getCustomer($customer_id);

    // Haetaan uusi email ja uusi password
    $new_email = trim($_POST['newEmail']);
    $new_password = trim($_POST['newPassword']);
    if (empty($new_email) || empty($new_password)) {
      echo "Please enter a new email and password";
      exit();
    }

    // Tsekataan onko uusi email valid
    if (!filter_var($new_email, FILTER_VALIDATE_EMAIL)) {
      echo '<script>alert ("Please enter a valid email address");</script>';
      echo '<script>window.location = "modifyUser.php"</script>';
      exit();
    }
    //Jos uusi salasana on alle yhden tai yli kymmenen merkkiä pitkä tai siinä ei ole yhtään numeroa, tulostetaan virheilmoitus ja lopetetaan koodin suoritus.
    if (strlen($new_password) < 4 || strlen($new_password) > 10 || !preg_match('/\d/', $new_password)) {
      echo '<script>alert ("Please enter a new password between 4 and 10 characters long and containing at least one number");</script>';
      echo '<script>window.location = "modifyUser.php"</script>';
      exit();
    }
    // Updatetaan customer tietokantaan käyttämällä updateCustomer funktiota
    if ($database->updateCustomer($customer_id, $new_email, $new_password)) {
      echo "User information updated successfully.";
    } else {
      echo "Error updating user information.";
    }
}

  
if (isset($_POST['changePassword'])) {
    $customer_id = $_SESSION['logged_id'];
    $database = new AllInOne($sql, 'customer');
    $customer = $database->getCustomer($customer_id);
  
    // Haetaan uusi salasana ja tehdään sille $new_password muuttuja
    $new_password = trim($_POST['newPassword']);
    if (empty($new_password)) { // Jos uusi salasana on tyhjä, tulostetaan virheilmoitus ja lopetetaan koodin suoritus.
      echo "Please enter a new password.";
      exit();
    }
    //Jos uusi salasana on alle yhden tai yli kymmenen merkkiä pitkä tai siinä ei ole yhtään numeroa, tulostetaan virheilmoitus ja lopetetaan koodin suoritus.
    if (strlen($new_password) < 4 || strlen($new_password) > 10 || !preg_match('/\d/', $new_password)) {
      echo '<script>alert ("Please enter a new password between 4 and 10 characters long and containing at least one number");</script>';
      echo '<script>window.location = "modifyUser.php"</script>';
      exit();
    }
  
    // Päivitetään käyttäjän salasana.
    if ($database->changePassword($customer_id, $new_password)) {
      echo "Password updated successfully."; // Jos salasanan päivitys onnistuu, tulostetaan onnistumisilmoitus.
    } else { // Näytetään error message
      echo "Error updating password.";
    }
}
if(isset($_POST['changeContact'])){
  $customer_id = $_SESSION['logged_id'];
  $database = new AllInOne($sql, 'customer');
  $customer = $database->getCustomer($customer_id);

  //Haetaan uudet tiedot ja trimmataan niistä pois turhat välilyönnit ja tehdään niille omat muuttujat
  $new_country = trim($_POST['newCountry']);
  $new_zip = trim($_POST['newZip']);
  $new_city = trim($_POST['newCity']);
  $new_phone = trim($_POST['newPhone']);
  
  // Päivitetään käyttäjän uudet kontakti tiedot käyttämällä changeContact funktiota class.AllInOne.php:eessa
  if($database->changeContact($customer_id, $new_country, $new_zip, $new_city, $new_phone)) {
    echo "Your contact information has been updated succesfully"; // Jos contact infon vaihto onnistuu
  }else {
    echo "Error updating your contact information"; // errormessage jos failaa
  }
}
?>
<?php
// Haetaan username näkymään käyttäjälle tällä sivulla käyttämällä getUsername funtkiota class.AllInOne.php:eessa
$customer = new AllInOne($sql, 'customer');
?>
<section id="cart-header">
  <h2><i class="fa-solid fa-id-card"></i> Update details - <?php echo strtoupper($customer->getName($_SESSION['logged_id'])); ?>
</section>
<section id="form-details" style="display:block; text-align: -webkit-center;">

  <form action="" method="POST">
    <h2>Change your contact information here</h2>
    <input type="text" style="width: 80%;" name="newCountry" placeholder="Country" class="form-control" required>
    <input type="text" style="width: 80%;" name="newZip" placeholder="Zip Code" class="form-control" required>
    <input type="text" style="width: 80%;" name="newCity" placeholder="City" class="form-control" required>
    <input type="tel" style="width: 80%;" name="newPhone" placeholder="Phone Number" class="form-control" required>
    <button class="normal" name="changeContact" type="submit">Submit</button>
  </form>

  <br>
  <br>

  <form action="" method="POST">
    <h2>Change your Email and Password here</h2>
    <input type="text" style="width: 80%;" name="newEmail" placeholder="New Email" class="form-control" required>
	  <input type="password" style="width: 80%;" name="newPassword" placeholder="New Password" class="form-control" required>
    <button class="normal" name="changeInfo" type="submit">Submit</button>
  </form>

    <br>
    <br>

  <form action="" method="POST">
    <h2>Change only password</h2>
    <input type="password" style="width: 80%;" name="newPassword" placeholder="New Password" class="form-control" required>
    <button class="normal" name="changePassword" type="submit">Submit</button>
  </form>

</section>


<?php require('templates/footer.php'); ?>
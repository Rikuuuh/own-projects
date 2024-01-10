<?php
session_start();

require('lib/db.php');
require('lib/class.base.php');
require('lib/class.AllInOne.php');
require('lib/functions.php');

// Otetaan tiedot talteen saadusta lomakedatasta
$firstname = $sql->real_escape_string($_POST['firstname']);
$lastname = $sql->real_escape_string($_POST['lastname']);
$country = $sql->real_escape_string($_POST['country']);
$city = $sql->real_escape_string($_POST['city']);
$address = $sql->real_escape_string($_POST['address']);
$zip = $sql->real_escape_string($_POST['zip']);
$phone = $sql->real_escape_string($_POST['phone']);
$email = $sql->real_escape_string($_POST['email']);
$password = $sql->real_escape_string($_POST['password']);
$repeatPassword = $sql->real_escape_string($_POST['repeat_password']);

$errors = [];

//salasanan turvallisuusehtoja
if (strlen($password) < 5) { 
    $errors[] = "The password must be at least five characters long";
} else if (!(preg_match('#[0-9]#', $password))){
        $errors[] = "The password must contain numbers";
}


if($password !== $repeatPassword) {
	$errors[] = "The passwords you entered do not match";
}

// Laitetaan kaikki emailit muuttujaan, jotka käyttäjä valitsee tunnuksiin
$queryCheck = $sql->query("SELECT * FROM customer WHERE email='$email'");

// tarkastetaan löytyykö querycheck-muuttujassa tavaraa, jos on niin antaa virheilmoituksen
if ($queryCheck->num_rows > 0) {

    $errors[] = "An account with that email already exists!";

}

// Jos ei virheitä, lisätään kantaan
if(count($errors) === 0) {
	
	// Lisätään tietokantaan uusi käyttäjä
	$sql->query("INSERT INTO customer (firstname, lastname, country, city, address, zip, phone, password, email)
	VALUES ('".$firstname."', '".$lastname."', '".$country."', '".$city."', '".$address."', '".$zip."', '".$phone."', '".$password."', '".$email."')");
	
	// Tee automaattinen sisäänkirjautuminen
	// eli kirjaa juuri luotu käyttäjä sisään
	if(login($email, $password)){
		header ("Location: index.php");
	} else {
		echo "Adding the user to the database failed!";
	}
	
	
	
} else {
	// Virheitä löytyi, lisätään ne sessioon
	$_SESSION['errors'] = $errors;
	
	// Ohjataan takaisin rekisteröintilomakkeelle
	header ("Location: register.php");
}

?>
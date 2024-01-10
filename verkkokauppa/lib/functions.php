<?php
function tervehdi() : string {
    global $sql;

    // Tsekataan onko user logged in
    if (isset($_SESSION['logged_id'])) {
        // Haetaan logged userin logged id
        $logged_id = $_SESSION['logged_id'];

        // Haetaan databasesta users taulusta username jossa id on logged id
        $result = $sql->query("SELECT firstname FROM customer WHERE id = '".$logged_id."'");
        
        // Jos löytyy user niin näytetään viesti
        if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $firstname = $row['firstname'];
			$firstname_uppercase = strtoupper($firstname);
            return "<p><strong>Welcome back ".$firstname_uppercase."</strong></p>";
        }
    }
    exit;
}

function login($email, $password): bool {
	
	// global arvolla saadaan käyttöön muuttuja funktion ulkopuolelta
	// Tässä otetaan käyttöön db.php:ssä tehty sql-objekti
	
	global $sql;
	
	// Putsataan lomakkeelta saadut muuttujat
	$email = $sql->real_escape_string($email);
	$password = $sql->real_escape_string($password);
	
	// Haetaan kannasta käyttäjän ja salasanan perusteet
	$result = $sql->query("SELECT id FROM customer WHERE email = '".$email."' AND password = '".$password."'");
	
	
	// Jos rivejä löytyy
	if($result->num_rows) {
		
		// Haetaan resultsetin rivi
		$row = $result->fetch_assoc();
		
		// Tallennetaan sessioon sisäänkirjautuneen ID
		$_SESSION['logged_id'] = $row['id'];

		
		return true;
	}else {
		//Ei löytynyt käyttäjää, palautetaan false
		return false;
	}
}
?>
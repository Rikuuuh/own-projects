<?php
session_start();

require ('lib/db.php');
require ('lib/functions.php');

$error = isset($_GET['error']) ? $_GET['error'] : ''; // Tsekataan onko urlissa error messagee (näytetään navin yläpuolella jos on)

if(isset($_SESSION['logged_id'])) { 
  // Jos user on jo logannu sisään, viedään hänet homepagelle
  header("Location: index.php");
  exit();
} else if(isset($_POST['username']) && isset($_POST['password'])) {
  // Jos username ja pw on laitettu, yritetään kirjata sisään
  $username = trim($_POST['username']); // Poistetaan ylimääräiset välilyönnit (whitespace) username fieldistä
  $password = trim($_POST['password']); // Poistetaan ylimääräiset välilyönnit (whitespace) password fieldistä

  if (!empty($username) && !empty($password)) { 
    // Jos kumpikaan ei ole tyhjä, yritetään kirjata sisään
    if(login($username, $password)) {
      // Onnistui -> homepagelle
      header("Location: index.php");
      exit();
    } else {
      // Login failed, viedään käyttäjä index.php ja näytetään teksti login failed
      header("Location: index.php?error=login_failed");
      exit("Error: " . $error);
    }
  } else {
    // Jos formin fieldit on tai jompikumpi on tyhjänä näytetään error käyttäjälle
    header("Location: index.php?error=empty_fields");
    exit("Error: " . $error);
  }
}
?>
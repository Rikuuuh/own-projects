<?php
session_start();
include ("lib/functions.php");

$_SESSION = array();

// Forcetaan käyttäjän cookies nollaantumaan (Kirjaa ulos käyttäjän)
if (isset($_COOKIE[session_name()])) {
    setcookie(session_name(), '', time()-42000, '/');
}

// Deletoidaan sessio
session_destroy();

// Takas homepagelle (index.php)
header("Location: index.php");
?>
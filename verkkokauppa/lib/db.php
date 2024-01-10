<?php

$sql = new mysqli("localhost", "riku", "Lolled123!", "sakky_riku");

if ($sql->connect_errno) {
	die("Ongelmia tietokannan kanssa " . $sql->connect_error);
}
?>
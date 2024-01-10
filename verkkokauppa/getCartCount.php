<?php
session_start();
require_once('lib/db.php');
require_once('lib/class.base.php');
require_once('lib/class.AllInOne.php');
require_once('lib/component.php');

if (isset($_POST['sessionid'])) {
    $sessionid = $_POST['sessionid'];
    $database = new AllInOne($sql, 'cart');
    $CartCount = $database->getCartItemCount($sessionid);
    echo htmlspecialchars($CartCount, ENT_QUOTES);
}
?>
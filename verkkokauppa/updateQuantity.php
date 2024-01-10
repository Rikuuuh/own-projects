<?php
session_start();
require_once('lib/db.php');
require_once('lib/class.base.php');
require_once('lib/class.AllInOne.php');

if (isset($_POST['productId']) && isset($_POST['quantity'])) {
  $productId = $_POST['productId'];
  $quantity = $_POST['quantity'];

  // Update the quantity in the database
  try {
    $database = new AllInOne($sql, 'cart');
    $sessionid = session_id();
    $database->updateCart($productId, $quantity, $sessionid);
    echo 'Quantity updated successfully.';
  } catch (Exception $e) {
    echo 'Error: ' . $e->getMessage();
  }

  // Update the quantity in the session variable
  $_SESSION['cart'][$productId]['quantity'] = $quantity;
}
?>
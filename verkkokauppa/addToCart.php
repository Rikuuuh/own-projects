<?php
session_start();
require_once('lib/db.php');
require_once('lib/class.base.php');
require_once('lib/class.AllInOne.php');
if (isset($_POST['product_id']) && isset($_POST['product_name']) && isset($_POST['product_price']) && isset($_POST['product_image'])) {
    $product_id = $_POST['product_id'];
    $product_name = $_POST['product_name'];
    $product_price = $_POST['product_price'];
    $product_image = $_POST['product_image'];
    $sessionid = session_id();
    $db = new AllInOne($sql,'cart');
    $db->addToCart($product_id, $product_name, $product_price, $product_image, $sessionid);
    $_SESSION['success_message'] = "Your product has been added to the cart!";

    header("Location: " . $_SERVER['HTTP_REFERER']);
    exit;
} else {
    return false;
}
?>
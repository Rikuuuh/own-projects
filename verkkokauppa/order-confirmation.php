<?php
session_start();
$title = "Huntshop | Order Confirmation";
require('templates/header.php');
?>
<section id="confirmation">
    <h2>Order Confirmation</h2>
    <h1>Thank you for your order!<br> Your order number is <?php echo htmlspecialchars($_GET['id'], ENT_QUOTES); ?>.</h1>
    <h4>We have sent you a confirmation email with the details of your order.</h4>
    <h5>Get ready to hunt!</h5>
</section>
<?php require('templates/footer.php'); ?>
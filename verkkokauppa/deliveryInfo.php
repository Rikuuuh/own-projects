<?php
session_start();
$title = "Huntshop | Delivery Information";
require('templates/header.php');


?>
<section id="cart-header">
    <h2><i class="fa-solid fa-truck"></i></h2>
</section>
<section class="delivery-info">
    <div class="section-p1">
        <h2>Delivery Information</h2>
        <p>At HuntShop, we offer tax-free products and free delivery for all orders. We believe that shopping for your favorite products should be an enjoyable and stress-free experience,<br>
        which is why we've made delivery as simple and convenient as possible.</p>
        <h2>Shipping Information</h2>
        <p>All orders placed on our website are shipped from our warehouse within 5 business days of your purchase.
        Once your order is shipped, you will receive an email notification with your tracking information.<br> We offer free shipping on all orders, so you don't need to worry about any extra fees or charges.</p>
        <h2>Delivery Times</h2>
        <p>Delivery times vary depending on your location and shipping method, but most orders are delivered within 7 business days after being shipped.<br>
        If you have any concerns about the delivery time for your order, please feel free to contact our customer support team.</p>
        <h2>International Orders</h2>
        <p>We are proud to offer international shipping to our customers around the world.
        However, please note that shipping times may be longer for international orders. <br>Additionally, you may be responsible for paying any customs duties or taxes that are required for your order to be delivered.</p>
        <h2>Returns</h2>
        <p>If you are not completely satisfied with your purchase, we offer a hassle-free returns policy.
        You can return your item(s) within 30 days of receiving your order for a full refund.<br> Please contact our customer support team for instructions on how to initiate a return.</p>
        <h3>Thank you for shopping at HuntShop. If you have any questions or concerns, please don't hesitate to contact us! </h3>
    </div>
</section>

<?php require('templates/newsletter.php'); ?>
<?php require('templates/footer.php'); ?>
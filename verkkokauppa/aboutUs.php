<?php
session_start();
$title = "Huntshop | About Us";
require('templates/header.php');


?>
<section id="cart-header">
    <h2><i class="fa-solid fa-users"></i>   Get to know us</h2>
</section>
<section id="about-head" class="section-p1">
    <img src="images/a.png" alt="">
    <div>
        <h2>Who We Are?</h2>
        <p>At HuntShop, we are passionate about providing our customers with high-quality, tax-free products at affordable prices.<br>
        Our mission is to offer a seamless and enjoyable shopping experience, which is why we've created a wide selection of products that cater to every need.<br>
        Our team is dedicated to providing exceptional customer service and support, so if you have any questions or concerns, please don't hesitate to contact us.<br>
        We are constantly updating our inventory to ensure that we offer the latest and greatest products in the market.<br>
        We take pride in offering high-quality products that are powerful and reliable.
        </p>
        <abbr title="">At HuntShop, we also believe in giving back to the community. We regularly donate a portion of our profits to local charities and organizations that are making a positive impact on the world.</abbr>
        <br><br>
        <marquee bgcolor="#FFF" loop="-1" scrollamount="7" width="100%">At HuntShop, we also believe in giving back to the community. 
        We regularly donate a portion of our profits to local charities and organizations that are making a positive impact on the world.
        </marquee>
    </div>
</section>
<section id="about-vid" class="section-p1">
    <h2>HuntShop Introduction Video</h2>
    <div class="video">
        <video autoplay muted loop src="videos/Huntshop.mp4"></video>
    </div>
    <h6>DISCLAIMER<br>
    I do NOT own this video nor the image featured in the video.<br>
    All rights belong to it's rightful owner/owner's.<br>
    No copyright infringement intended.<br>
    Video is purely for entertainment purposes only.
    </h6>
</section>

<?php require('templates/feature.php'); ?>
<?php require('templates/newsletter.php'); ?>
<?php require('templates/footer.php'); ?>
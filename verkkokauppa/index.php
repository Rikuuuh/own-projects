<?php
// Start session
session_start();
$title = "Huntshop | Home";
require('templates/header.php');
$database = new AllInOne($sql, "products");
$_SESSION['prev_page'] = $_SERVER['REQUEST_URI'];
?>
<section id="hero">
    <video autoplay loop muted>
        <source src="videos/index.mp4" type="video/mp4">
        Your browser does not support the video tag.
    </video>
    <div class="hero-content">
        <h4>Trade-in-offer</h4>
        <h2>Super value deals</h2>
        <h1>On all products</h1>
        <p><strong>Shop now tax-free!</strong></p>
        <a href="shop.php?category=Hunting Guns"><button>Shop now</button></a>
    </div>
</section>
<section id="product1" class="section-p1">
    <h2>Featured Products</h2>
    <p>Superior accuracy and precision</p>
    <div class="pro-container" id="Here">
        <?php
        // Tehdään $result muuttuja hakemaan tuotteita getTwo() funktion avulla
        $result = $database->getTwo();
        while($row = $result->fetch_assoc()){ 
            component($row['product_name'],$row['product_price'],$row['product_image'],$row['id'], $row['product_title'], $row['tax_price']);
        }
        ?>
    </div>
</section>

<?php require('templates/newsletter.php'); ?>
<?php require('templates/footer.php'); ?>
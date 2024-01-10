<?php
// Start session
session_start();
$title = "Huntshop | Shop";
require('templates/header.php');
?>
<section id="shop-header">
    <h2>HuntShop</h2>
</section>
<div class="container-fluid carousel" id="Here">
    <a href="shop.php?category=Hunting Guns#Here"><img src="images/ase.jpg" alt="" class="carousel-img"></a>
    <a href="shop.php?category=Rifle Scopes#Here"><img src="images/scope.jpg" alt="" class="carousel-img"></a>
    <a href="shop.php?category=Cartridges#Here"><img src="images/ammus.jpg" alt="" class="carousel-img"></a>
    <a href="shop.php?category=Assault Rifles#Here"><img src="images/Rifle.jpg" alt="" class="carousel-img"></a>
</div>
<section id="product1" class="section-p1">
    <h2><?= ucfirst($_GET['category']) ?></h2>
    <div class="pro-container">
        <?php
        $category = $_GET['category'] ?? ''; // Haetaan categorian mukaan tietokannasta tuotteet
        $database = new AllInOne($sql, "products"); // Alustetaan database muuttuja products taululle
        $result = $database->getByCategory($category); // Käytetään AllInOnesta löytyvää getByCategory funktiota tuomaan tuotteet
        while ($row = $result->fetch_assoc()) { // Tulostetaan näkyviin käyttämällä componenttia jossa on valmiit <div setit yms nimelle hinnalle kuvalle titlelle (hidden id)
            component($row['product_name'], $row['product_price'], $row['product_image'], $row['id'], $row['product_title'], $row['tax_price']);
        }
        $_SESSION['prev_page'] = $_SERVER['REQUEST_URI'];
        ?>
    </div>
</section>
<?php require('templates/feature.php'); ?>
<?php require('templates/newsletter.php'); ?>
<?php require('templates/footer.php'); ?>
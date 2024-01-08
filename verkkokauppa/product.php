<?php
session_start();
$title = "Huntshop";
require('templates/header.php');

?>
<section id="cart-header" style="align-items: center">
    <a href="<?php echo $_SESSION['prev_page']; ?>#Here"><i class="fa-brands fa-shopify"></i>Continue shopping</a>
</section>
<section id="product1" class="section-p1">
    <div class="pro-container">
        <?php
            $database = new AllInOne($sql, "products"); // Käytetään AllInOne-luokkaa tietokannan käsittelyyn
            if (isset($_GET['product_id'])) {  // Tarkistaa onko product_id-parametri määritelty URL:ssa
                $product_id = $_GET['product_id']; // Tallentaa product_id:n muuttujaan
                $database->product_id = $product_id; // Asettaa product_id:n AllInOne-luokan product_id-muuttujaan
                $result = $database->getOne();  // Hakee yhden tuoteen tietokannasta
                if (mysqli_num_rows($result) > 0) { // Jos löytyy tuloksia näytetään ne, jos ei löydy return false;
                    while($row = mysqli_fetch_assoc($result)){
                        product($row['product_name'],$row['product_price'],$row['product_image'],$row['id'],$row['product_description'], $row['product_title'], $row['tax_price']);
                    }
                }
            } else {
                return false;
            }
        ?>
    </div>
</section>



<?php require('templates/footer.php'); ?>
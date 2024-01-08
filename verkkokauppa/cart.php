<?php
session_start();
$title = "Huntshop | Cart";
require('templates/header.php');
$_SESSION['prev_page'] = $_SERVER['REQUEST_URI'];
$database = new AllInOne($sql, 'cart');

// Haetaan session id
$sessionid = session_id();

// Tsekataan onko formi lähetetty
if(isset($_POST['update'])) {
  // Käydään läpi jokainen tuote ostoskorissa
    foreach($_POST['quantity'] as $key => $value) {
        $product_id = $_POST['product_id'][$key];
        $quantity = (int)$value;
        // Päivitetään tuotteen määrä(quantity) ostoskorissa tietokannassa
        $database->updateCart($product_id, $quantity, $sessionid);
    }
}

// Poistetaan tuote ostoskorista
if (isset($_GET['action']) && $_GET['action'] == 'remove' && isset($_GET['id'])) {
    $id = $_GET['id'];
    $database->removeFromCart($id, $sessionid);
}

// haetaan ostoskori data cart tablesta
$result = $database->getData($sessionid);

?>
<section id="cart-header">
  <h2><i class="fa fa-shopping-cart" aria-hidden="true"></i>   My Cart</h2>
</section>

<section id="cart" class="section-p1">
  <table width="100%">
    <thead>
      <tr>
        <td>Remove</td>
        <td>Image</td>
        <td>Product</td>
        <td>Price</td>
        <td>Quantity</td>
      </tr>
    </thead>
    <tbody>
      <?php
      // Tarkistetaan, onko tietokannasta löydetty ostoskorin tuotteita. Jos löytyy, käydään jokainen tuote läpi while-silmukan avulla
      // ja tulostetaan sen tiedot cartElement-funktion avulla. Jos ei löydy, näytetään viesti, että ostoskori on tyhjä.
      if (mysqli_num_rows($result) > 0) {
          while ($row = mysqli_fetch_assoc($result)) {
              $product_name = $row['product_name'];
              $product_price = $row['product_price'];
              $product_image = $row['product_image'];
              $product_id = $row['product_id'];
              $quantity = $row['quantity'];
              cartElement($product_image, $product_name, $product_price, $product_id, $quantity);
          }
      } else {
          echo '<tr><td colspan="6" class="empty-cart">Your cart is empty.</td></tr>';
      }
      ?>
    </tbody>
  </table>
</section>
<h2 style="text-align:center; color:#FFF; margin:30px; padding-bottom:15px;">Here are some products you might have missed</h2>
<div class="slider">
    <div class="slide-track" id="Here">
    <?php
            $karuselli = new AllInOne($sql, 'products');
            $resul = $karuselli->getProducts();
            while ($row = $resul->fetch_assoc()){
                karuselli($row['product_name'],$row['product_price'],$row['product_image'],$row['id'], $row['product_title'], $row['tax_price']);
            }
    ?>
  </div>
</div>

<?php
// Näytetään cartTotal-hinta käyttämällä cartTotal funktiota class.AllInOnesta
cartTotal($result, $sessionid);

// !MUISTA! scriptit
echo '<script src="updateQuantity.php"></script>';
?>
<script>
// Päivitetään ostoskorin kokonaissumma näyttämään oikeaa määrää. (Käytännössä sama kuin välisumma koska ei ole käytössä tax & kuljetus)
function updateCartTotal(sessionid) {
  $.ajax({
    url: 'getCartTotal.php',
    method: 'POST',
    data: {sessionid: sessionid},
    success: function(response) {
      $('#cart-total').html(response);
    }
  });
}
// Päivitetään ostoskorin välisumma näyttämään oikeaa määrää.
function updateSubtotal(sessionid) {
  $.ajax({
    url: 'getSubTotal.php',
    method: 'POST',
    data: {sessionid: sessionid},
    success: function(response) {
      $('#cart-subtotal').html('€ ' + response);
    }
  });
}
// Jos asiakas painaa "plus" tai "miinus" -painikkeita ostoskori päivittyy niiden mukaan
$(document).on('click', '.plus, .minus', function() {
  var productId = $(this).data('product-id');
  var quantityInput = $('.quantity-input[data-product-id="' + productId + '"]');
  var quantity = parseInt(quantityInput.val());

  if ($(this).hasClass('plus')) {
    quantity++;
  } else {
    quantity--;
  }
  
  // Updatetaan inputfield quantitylla
  quantityInput.val(quantity);

  // Updatetaan sessionid uudella quantityllä (+1 tai -1)
  $.ajax({
    url: 'updateQuantity.php',
    method: 'POST',
    data: {
      productId: productId,
      quantity: quantity
    },
    success: function(response) {
      console.log(response);
      updateCartTotal("<?php echo $sessionid; ?>");
      updateSubtotal("<?php echo $sessionid; ?>");
      getCartCount("<?php echo $sessionid; ?>");
    }
  });
});
</script>

<?php require('templates/footer.php');?>
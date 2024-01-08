<?php
session_start();
$title = "Huntshop | Checkout";
require('templates/header.php');

$sessionid = session_id();
$database = new AllInOne($sql, 'cart');
$result = $database->getData($sessionid);

// Tsekataan onko user logged in (logged_id niminen sessio jos on)
if (isset($_SESSION['logged_id'])) {
  $customer_id = $_SESSION['logged_id'];
  $database = new AllInOne($sql, 'customer');
  $customer = $database->getCustomer($customer_id); //Haetaan customer id ja näytetään alla fieldeille jokainen kohta mysql taulusta

  $fields = array(
    array('name' => 'firstname', 'placeholder' => 'Your Firstname', 'value' => $customer['firstname']),
    array('name' => 'lastname', 'placeholder' => 'Your Lastname', 'value' => $customer['lastname']),
    array('name' => 'address', 'placeholder' => 'Your Address', 'value' => $customer['address']),
    array('name' => 'country', 'placeholder' => 'Your Country', 'value' => $customer['country']),
    array('name' => 'zip', 'placeholder' => 'Your Zip', 'value' => $customer['zip']),
    array('name' => 'city', 'placeholder' => 'Your City', 'value' => $customer['city']),
    array('name' => 'phone', 'placeholder' => 'Your Phone', 'value' => $customer['phone']),
    array('name' => 'email', 'placeholder' => 'Your Email', 'value' => $customer['email']),
  );
} else {
  // User is not logged in, display empty fields
  $fields = array(
    array('name' => 'firstname', 'placeholder' => 'Your Firstname'),
    array('name' => 'lastname', 'placeholder' => 'Your Lastname'),
    array('name' => 'address', 'placeholder' => 'Your Address'),
    array('name' => 'country', 'placeholder' => 'Your Country'),
    array('name' => 'zip', 'placeholder' => 'Your Zip'),
    array('name' => 'city', 'placeholder' => 'Your City'),
    array('name' => 'phone', 'placeholder' => 'Your Phone'),
    array('name' => 'email', 'placeholder' => 'Your Email'),
  );
}

?>
<section id="cart-header">
  <h2><i class="fa-solid fa-money-check-dollar"></i>Checkout</h2>
</section>

<section id="form-details">
  <form action="checkout-process.php" method="POST">
    <h2>Enter your details</h2>

    <?php foreach ($fields as $field): ?>
      <!-- Tehdään input fieldit jokaiselle fieldille $field arrayssa -->
      <input type="text" name="<?php echo $field['name']; ?>" id="<?php echo $field['name']; ?>" placeholder="<?php echo $field['placeholder']; ?>" class="form-control <?php echo isset($_SESSION['error_fields']) && in_array($field['name'], $_SESSION['error_fields']) ? 'error' : ''; ?>" value="<?php echo isset($_SESSION['user_input'][$field['name']]) ? htmlspecialchars($_SESSION['user_input'][$field['name']]) : $field['value']; ?>">
    <?php endforeach; ?>
    <h2>Payment</h2>

    <div class="form-check">
      <input class="form-check-input" type="radio" name="Inquiry" id="flexRadioDefault1" checked>
      <label class="form-check-label" for="flexRadioDefault1">Inquiry</label>
    </div>

    <h2>Choose your preferred shipping method</h2>

    <div class="form-check">
      <input class="form-check-input" type="radio" name="shipping_method" id="Posti" value="Posti" checked>
      <label class="form-check-label" for="Posti">Posti</label>
    </div>

    <div class="form-check">
      <input class="form-check-input" type="radio" name="shipping_method" id="Dhl" value="DHL">
      <label class="form-check-label" for="DHL">DHL</label>
    </div>

    <div class="form-check">
      <input class="form-check-input" type="radio" name="shipping_method" id="Matkahuolto" value="Matkahuolto">
      <label class="form-check-label" for="Matkahuolto">Matkahuolto</label>
    </div>

    <?php if (isset($_SESSION['error_msg'])): ?>
      <div class="error-msg"><?php echo $_SESSION['error_msg']; ?></div>
      <?php unset($_SESSION['error_msg']); ?>
    <?php endif; ?>
    <button class="normal" type="submit">Place order</button>
  </form>


  <div class="people">
      <?php
          if (mysqli_num_rows($result) > 0) {
              while ($row = mysqli_fetch_assoc($result)) { // Haetaan $result muuttujaan jokainen tuote cart taulusta sessionID mukaan / $result muuttuja asetettu ylhäällä valmiiksi
                  $product_name = $row['product_name']; 
                  $product_price = $row['product_price'];
                  $product_image = $row['product_image'];
                  $quantity = $row['quantity'];
                  checkOut($product_image, $product_name, $product_price, $quantity);
              }
          } else {
              // Näytetään viesti jos "cart" on tyhjä
              echo '<tr><td colspan="6" class="empty-cart">Your cart is empty.</td></tr>';
          }
      ?>
      <?php
// Näytetään checkoutTotal
checkoutTotal($result, $sessionid);

echo '<script src="updateQuantity.php"></script>';
?>
  </div>
</section>
<?php require('templates/footer.php'); ?>
<?php
session_start();
require('lib/class.base.php');
require('lib/class.AllInOne.php');
require('lib/db.php');
$allinone = new AllInOne($sql, 'order_items');

// Tsekataan onko asiakas kirjautunut
if (isset($_SESSION['logged_id'])) {
    // Asiakas on kirjautunut joten UPDATETAAN customer table
    $customer_id = $_SESSION['logged_id'];
    $sql = "UPDATE customer SET firstname=?, lastname=?, address=?, country=?, zip=?, city=?, phone=?, email=? WHERE id=?";
    $stmt = $allinone->getSql()->prepare($sql);
    $stmt->bind_param("ssssssssi", $firstname, $lastname, $address, $country, $zip, $city, $phone, $email, $customer_id);
} else {
    // Asiakas ei ole kirjautunut, INSERT customer table
    $sql = "INSERT INTO customer (firstname, lastname, address, country, zip, city, phone, email) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    $stmt = $allinone->getSql()->prepare($sql);
    $stmt->bind_param("ssssssss", $firstname, $lastname, $address, $country, $zip, $city, $phone, $email);
}

// Asetetaan parametrit POST-datasta
$firstname = $_POST['firstname'];
$lastname = $_POST['lastname'];
$address = $_POST['address'];
$country = $_POST['country'];
$zip = $_POST['zip'];
$city = $_POST['city'];
$phone = $_POST['phone'];
$email = $_POST['email'];
// Jos löytyy erroreita joka kohta yksitellen läpi
$error_fields = array();
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $error_fields[] = 'email';
}
if (empty($firstname)) {
    $error_fields[] = 'firstname';
}
if (empty($lastname)) {
    $error_fields[] = 'lastname';
}
if (empty($address)) {
    $error_fields[] = 'country';
}
if (empty($address)) {
    $error_fields[] = 'address';
}
if (empty($zip)) {
    $error_fields[] = 'zip';
}
if (empty($city)) {
    $error_fields[] = 'city';
}
if (empty($phone)) {
    $error_fields[] = 'phone';
}
// näytetään jos errorit jos niitä on löytynyt jostain formin kohdasta
if (!empty($error_fields)) {
    $_SESSION['user_input'] = $_POST;
    $_SESSION['error_fields'] = $error_fields;
    $_SESSION['error_msg'] = "The order could not be completed. Please check that all information is correct and that the email address is valid.";
    header("Location: checkout.php");
    exit;
}

// Suoritetaan SQL-lausunto
if (!$stmt->execute()) {
    echo "Error: " . $stmt->error;
    exit;
}

// Haetaan asiakkaan ID, tätä muuttujaa käytetään alempana, kun tallennetaan tilaustiedot tietokantaan.
// Tsekataan onko asiakas kirjautunut
if (isset($_SESSION['logged_id'])) {
    $customer_id = $_SESSION['logged_id'];
} else {
    // Jos ei ole niin haetaan viimeisimmän asiakkaan ID
    $customer_id = $allinone->getSql()->insert_id;
}

// Laitetaan orders tableen tiedot orderista
$sql = "INSERT INTO orders (customer_id, createdate, finishdate, price_notax, status)
        VALUES ($customer_id, now(), now(), 0, 'pending')";
$result = $allinone->getSql()->query($sql);
if (!$result) {
    echo "Error: " . mysqli_error($allinone->getSql());
    exit;
}

// Haetaan session id
$sessionid = session_id();

// Haetaan viimeisin order ID
$order_id = $allinone->getSql()->insert_id;

// Haetaan cart_items
$cart_items = $allinone->getData($sessionid);

// Laitetaan ostoskorin tuotteet order_items tableen ja updatetaan orderin hinta
$order_price_notax = 0;
while ($row = mysqli_fetch_assoc($cart_items)) {
    $product_id = $row['product_id'];
    $product_name = $row['product_name'];
    $product_price = $row['product_price'];
    $quantity = $row['quantity'];
    $tax = $product_price * 0;
    $subtotal = $product_price * $quantity;
    $sql = "INSERT INTO order_items (order_id, customer_id, product_id, product_name, product_price, quantity, tax, createdate)
            VALUES ($order_id, $customer_id, $product_id, '$product_name', $product_price, $quantity, $tax, now())";
    $result = $allinone->getSql()->query($sql);
    if (!$result) {
        echo "Error: " . mysqli_error($allinone->getSql());
        exit;
    }
    $order_price_notax += $subtotal;
}

// Updatetaan order hinta orders tablessa
$order_price_tax = $order_price_notax * 0; 
$order_price = $order_price_notax + $order_price_tax;
$sql = "UPDATE orders SET price = $order_price, price_notax = $order_price_notax WHERE id = $order_id";
$result = $allinone->getSql()->query($sql);
if (!$result) {
    echo "Error: " . mysqli_error($allinone->getSql());
    exit;
}

// Haetaan session id
$sessionid = session_id();
// Haetaan cart_items
$cart_items = $allinone->getData($sessionid);
// Tehdään allproducts tyhjäksi arrayksi
$allproducts = array();

// Täytetään allproducts-taulukko ostoskorin tuotteilla
while ($row = mysqli_fetch_assoc($cart_items)) {
    $product_name = $row['product_name'];
    $product_price = $row['product_price'];
    $quantity = $row['quantity'];
    $subtotal = $product_price * $quantity;

    $product = array(
        'product_name' => $product_name,
        'product_price' => $product_price,
        'quantity' => $quantity
    );

    array_push($allproducts, $product);
}
$shipping_method = $_POST['shipping_method'];
// Luodaan tuotelista nimi-, määrä- ja hinnan kanssa (euroissa)
$productList = '';
foreach ($allproducts as $product) {
    $productList .= '- ' . $product['product_name'] . ' (' . $product['quantity'] . ' x ' . $product['product_price'] . '€)' . "\r\n";
}

$email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);

if ($email) {
  $to = 'rikuuuuh@gmail.com'; //VIESTI ITSELLE
  $subject = 'Order Confirmation from HuntShop';
  $message = 'A new customer has made order on your website HuntShop. Customer ID: ' . $customer_id . ' Order ID: ' . $order_id . ' Total Price: ' . $order_price . '€.
Products in this order are:
' . $productList . '
Customer is using ' . $shipping_method . ' as his/her shipping method.';
  $headers = 'From: ' . $email . "\r\n" .
             'Reply-To: ' . $email . "\r\n" .
             'X-Mailer: PHP/' . phpversion();

  if (mail($to, $subject, $message, $headers)) {
    $to = $email; // VIESTI ASIAKKAALLE
    $subject = 'Thank you for your order!';
    $message = 'Dear ' . $firstname . ',
Thank you for your recent order with HuntShop. We are pleased to confirm that your order has been received and is currently being processed. Your order ID is: ' . $order_id . ' and the total price of your order is: ' . $order_price . '€.

Your ordered products are:
' . $productList . '

You have selected ' . $shipping_method . ' as your shipping method.

We appreciate your business and would like to assure you that we are committed to providing the highest level of customer satisfaction.
Please note that your order will be shipped within the next 2-3 business days.
Once your order has been shipped, you will receive an email confirmation with tracking information.

Please also note that your invoice will be emailed to you separately within the next 24-48 hours.
If you have any questions or concerns about your order or invoice, please do not hesitate to contact us.
    
Thank you again for choosing HuntShop, and we look forward to serving you again soon!
    
Best regards,
John W.
Huntshop';
    $headers = 'From: rikuuuuh@gmail.com' . "\r\n" .
               'Reply-To: rikuuuuh@gmail.com' . "\r\n" .
               'X-Mailer: PHP/' . phpversion();

    mail($to, $subject, $message, $headers);

    header("Location: order-confirmation.php?id=$order_id"); // VIEDÄÄN ORDER-confirmation sivulle ja näytetään siellä orderid ja teksti nönnönnöö
  }
}
// Tyhjennetään ostoskori lopuksi tältä sessionideeltä
$sql = "DELETE FROM cart WHERE sessionid = '$sessionid'";
$result = $allinone->getSql()->query($sql);
if (!$result) {
    echo "Error: " . mysqli_error($allinone->getSql());
    exit;
}
exit;
?>
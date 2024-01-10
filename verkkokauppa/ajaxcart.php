<?php
session_start();
require('lib/db.php');
require('lib/class.AllInOne.php');
$json = file_get_contents('php://input'); 
$data = json_decode($json, true);
$sessionid = session_id();
$result = $sql->query("SELECT * FROM cart WHERE sessionid = '$sessionid'");

$output = array();
while ($row = mysqli_fetch_assoc($result)) {
    $output[] = $row;
}

session_start();

if (!empty($data)) {
    $id = $data['id'];
    $sessionid = session_id();
    $sql->query("DELETE FROM cart WHERE id = $id AND sessionid = '$sessionid'");
}

echo json_encode($output);
?>


<?php 
  /*/$(document).ready(function(){
    $("#show_cart").load("ajaxcart.php", {"load_cart":"1"});
    $(".addToCart").click(function(){
      var product_id = $(this).data("productid");
      var product_name = $(this).data("productname");
      var product_price = $(this).data("productprice");
      var product_image = $(this).data("productimage");
      var quantity = 1;
      $.ajax({
        url: "addToCart.php",
        method: "POST",
        data: {product_id: product_id, product_name: product_name, product_price: product_price, product_image: product_image, quantity: quantity},
        success: function(data){
          var cart_data = JSON.parse(data);
          
          var output = "";
          for (var i in cart_data) {
            output += "<tr>";
            output += "<td>" + cart_data[i].product_name + "</td>";
            output += "<td>" + cart_data[i].product_price + "</td>";
            output += "<td>" + cart_data[i].quantity + "</td>";
            output += "<td><a href='removeFromCart.php?id=" + cart_data[i].id + "'>Remove</a></td>";
            output += "</tr>";
          }

          $("#show_cart tbody").html(output);
        }
      });
    });
});*/
?>
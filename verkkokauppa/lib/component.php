<?php
function component($productname,$productprice,$productimage,$productid,$producttitle,$taxprice){
    $element = 
    '<div class="pro">
    <form action="addToCart.php" method="POST">
    <img src="' . htmlspecialchars($productimage, ENT_QUOTES) . '" alt="">
    <div class="des">
        <span>' . htmlspecialchars($productname, ENT_QUOTES) . '</span>
        <h5>' . htmlspecialchars($producttitle, ENT_QUOTES) . '</h5>
        <div class="star">
        <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
            <i class="fas fa-star"></i>
        <i class="fas fa-star"></i>
        </div>
        <small><s>' . htmlspecialchars($taxprice, ENT_QUOTES) . '€</s></small>
        <h4>' . htmlspecialchars($productprice, ENT_QUOTES) . '€</h4>
    </div>
    <a href="product.php?product_id='.$productid.'" style="text-decoration:none; color:white;"><i class="fa-solid fa-circle-info"></i>Click here for more info</a>
    <button type="submit" class="btn my-3" name="add"><i class="fa fa-shopping-cart cart"></i></button>
    <input type="hidden" name="product_id" value="' . htmlspecialchars($productid, ENT_QUOTES) . '" >
    <input type="hidden" name="product_name" value="' . htmlspecialchars($productname, ENT_QUOTES) . '">
    <input type="hidden" name="product_price" value="' . htmlspecialchars($productprice, ENT_QUOTES) . '">
    <input type="hidden" name="product_image" value="' . htmlspecialchars($productimage, ENT_QUOTES) . '">
    </form>
</div>';
    echo $element;
}

function product($productname, $productprice, $productimage, $productid, $productdescription, $producttitle, $taxprice){
    $element = 
    '<div class="row proo">
    <form action="addToCart.php" method="post">
     <img src="' . htmlspecialchars($productimage, ENT_QUOTES) . '" alt="">
     <div class="des">
         <span>' . htmlspecialchars($productname, ENT_QUOTES) . '</span>
         <h5>' . htmlspecialchars($producttitle, ENT_QUOTES) . '</h5>
         <div class="star">
          <i class="fas fa-star"></i>
             <i class="fas fa-star"></i>
             <i class="fas fa-star"></i>
             <i class="fas fa-star"></i>
          <i class="fas fa-star"></i>
         </div>
         <small><s>' . htmlspecialchars($taxprice, ENT_QUOTES) . '€</s></small>
         <h4>' . htmlspecialchars($productprice, ENT_QUOTES) . '€</h4>
         <h5>' . $productdescription . '</h5>
     </div>
     <button type="submit" class="btn my-3" name="add"><i class="fa fa-shopping-cart cart"></i></button>
     <input type="hidden" name="product_id" value="' . htmlspecialchars($productid, ENT_QUOTES) . '">
    <input type="hidden" name="product_name" value="' . htmlspecialchars($productname, ENT_QUOTES) . '">
    <input type="hidden" name="product_price" value="' . htmlspecialchars($productprice, ENT_QUOTES) . '">
    <input type="hidden" name="product_image" value="' . htmlspecialchars($productimage, ENT_QUOTES) . '">
   </form>
 </div>';
    echo $element;
}



function cartElement($productimage, $productname, $productprice, $productid, $quantity) {

    echo '<tr>
            <td><a href="cart.php?action=remove&id=' . htmlspecialchars($productid, ENT_QUOTES) . '"><span style="font-size: 1.5em; color: red;"><i class="far fa-times-circle"></i></span></a></td>
            <td><img src="' . htmlspecialchars($productimage, ENT_QUOTES) . '" alt=""></td>
            <td>' . htmlspecialchars($productname, ENT_QUOTES) . '</td>
            <td>' . htmlspecialchars($productprice, ENT_QUOTES) . ' €</td>
            <td>
            <div class="btn-group">
                <button type="button" class="btn rounded-circle minus" data-product-id="' . htmlspecialchars($productid, ENT_QUOTES) . '"><span style="color: red;"><i class="fa-solid fa-minus"></i></span></button>
                <input type="text" value="' . htmlspecialchars($quantity, ENT_QUOTES) . '" class="form-control w-10 d-inline quantity-input" data-product-id="' . htmlspecialchars($productid, ENT_QUOTES) . '" readonly>
                <button type="button" class="btn rounded-circle plus" data-product-id="' . htmlspecialchars($productid, ENT_QUOTES) . '"><span style="color: #006400;"><i class="fa-solid fa-plus"></i></span></button>
            </div>
            </td>
        </tr>';
}

function checkOut($productimage, $productname, $productprice, $quantity) {

    $element = '<div>
            <img src="' . htmlspecialchars($productimage, ENT_QUOTES) . '" alt="">
            <p><span>' . htmlspecialchars($productname, ENT_QUOTES) . '</span><br>
            <span>' . htmlspecialchars($productprice, ENT_QUOTES) . '€</span><br>
            <span>Quantity ' . htmlspecialchars($quantity, ENT_QUOTES) . ' </span></p><br>
            </div>';
    echo $element;
}

function cartTotal($cartItems, $sessionid) {
    $subtotal = 0;
    foreach ($cartItems as $item) {
        $subtotal += $item['product_price'] * $item['quantity'];
    }

    $shipping = 0; // Free shipping 24/7 :)

    $total = $subtotal + $shipping;

    $element = '
        <section id="cart-add" class="section-p1">
          <form action="checkout.php" method="POST">
            <div id="subtotal">
                <h3>Cart Totals</h3>
                <table>
                    <tr>
                        <td>Cart Subtotal</td>
                        <td><strong id="cart-subtotal">€ ' . htmlspecialchars($subtotal, ENT_QUOTES) . '</strong></td>
                    </tr>
                    <tr>
                        <td>Shipping</td>
                        <td>Free</td>
                    </tr>
                    <tr>
                        <td><strong>Total</strong></td>
                        <td><strong id="cart-total">€ ' . htmlspecialchars($total, ENT_QUOTES) . '</strong></td>
                    </tr>
                </table>
                <button type="submit" class="normal">Proceed to checkout</button>
            </div>
          </form>
        </section>';

    echo $element;
}
function checkoutTotal($cartItems, $sessionid) {
    $subtotal = 0;
    foreach ($cartItems as $item) {
        $subtotal += $item['product_price'] * $item['quantity'];
    }

    $shipping = 0; // Free shipping 24/7 :)

    $total = $subtotal + $shipping;

    $element = '
        <section id="cart-add" class="section-m1">
                <table>
                    <tr>
                        <td>Cart Subtotal</td>
                        <td><strong id="cart-subtotal">€ ' . htmlspecialchars($subtotal, ENT_QUOTES) . '</strong></td>
                    </tr>
                    <tr>
                        <td>Shipping</td>
                        <td>Free</td>
                    </tr>
                    <tr>
                        <td><strong>Total</strong></td>
                        <td><strong id="cart-total">€ ' . htmlspecialchars($total, ENT_QUOTES) . '</strong></td>
                    </tr>
                </table>
        </section>';

    echo $element;
}
function karuselli($productname, $productprice, $productimage, $productid, $producttitle) {
    $element = '<form action="addToCart.php" method="POST">
    <div class="slide">
        <img src="' . htmlspecialchars($productimage, ENT_QUOTES) . '">
        <input type="hidden" name="product_id" value="' . htmlspecialchars($productid, ENT_QUOTES) . '">
        <input type="hidden" name="product_name" value="' . htmlspecialchars($productname, ENT_QUOTES) . '">
        <input type="hidden" name="product_price" value="' . htmlspecialchars($productprice, ENT_QUOTES) . '">
        <input type="hidden" name="product_image" value="' . htmlspecialchars($productimage, ENT_QUOTES) . '">
        <div class="slide-overlay">
            <h2>' . htmlspecialchars($productname, ENT_QUOTES) . '</h2>
            <h2>' . htmlspecialchars($producttitle, ENT_QUOTES) . '</h2>
            <h2 style="margin-bottom: 25px;">' . htmlspecialchars($productprice, ENT_QUOTES) . ' €</h2>
            <a href="product.php?product_id='.$productid.'" style="text-decoration:none; color:white; padding-top:5px;"><i class="fa-solid fa-circle-info"></i>Click here for more info</a>
            <button type="submit" class="btn my-3" name="add" style="color: green; padding:0;"><i class="fa fa-shopping-cart cart"></i>Add To Cart</button>
        </div>
    </div>
    </form>';
    echo $element;
}
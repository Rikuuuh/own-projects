<?php
$name = filter_input(INPUT_POST, 'name', FILTER_SANITIZE_FULL_SPECIAL_CHARS);
$phone = filter_input(INPUT_POST, 'phone', FILTER_SANITIZE_FULL_SPECIAL_CHARS);
$message = filter_input(INPUT_POST, 'message', FILTER_SANITIZE_FULL_SPECIAL_CHARS);

if (empty($name) || empty($phone) || empty($message)) {
    echo '<script> alert ("Please check that you have inserted your Name, Phone Number, and Message correctly!")</script>';
    echo '<script> window.location = "contact.php"</script>';
    exit;
}

$email_body = "Henkilö nimeltä ".$name." puhelinnumero ".$phone." otti yhteyttä web-sivujen kautta. Hän lähetti viestin: ".$message;
$email_subject = "New Contact From HuntShop";
$to_email = "rikuuuuh@gmail.com";
$headers = "From: ".$name." <".$to_email.">"."\r\n";
$headers .= "Reply-To: ".$to_email."\r\n";
$headers .= "MIME-Version: 1.0\r\n";
$headers .= "Content-Type: text/html; charset=UTF-8\r\n";

if (mail($to_email, $email_subject, $email_body, $headers)) {
    header("Location: contact.php?messagesent=1");
    exit;
} else {
    echo 'Something went wrong, try again!';
}

?>
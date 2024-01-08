<?php
$email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);

if ($email) {
  $to = 'rikuuuuh@gmail.com'; 
  $subject = 'Newsletter Sign-Up';
  $message = 'A new user has signed up for the newsletter. Email: ' . $email;
  $headers = 'From: ' . $email . "\r\n" .
             'Reply-To: ' . $email . "\r\n" .
             'X-Mailer: PHP/' . phpversion();

  if (mail($to, $subject, $message, $headers)) {
    $to = $email;
    $subject = 'Newsletter Sign-Up Confirmation';
    $message = 'Thank you for signing up for our newsletter! You will receive our latest updates and special offers in your email inbox.';
    $headers = 'From: rikuuuuh@gmail.com' . "\r\n" .
               'Reply-To: rikuuuuh@gmail.com' . "\r\n" .
               'X-Mailer: PHP/' . phpversion();

    mail($to, $subject, $message, $headers);

    header("Location: index.php?sendletter=1");
  } else {
    echo 'There was an error sending your message. Please try again later.';
  }
} else {
  echo '<script> alert ("Please enter a valid email address!");</script>';
  echo '<script> window.location = "index.php"</script>';
}
?>
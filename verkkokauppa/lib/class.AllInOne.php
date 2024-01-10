<?php

class AllInOne extends base
{
    public $product_id;
    public $product_name;
    public $product_price;
    public $product_image;
    public $adddate;
    public $sessionid;
    public $firstname;
    public $lastname;
    public $address;
    public $country;
    public $zip;
    public $city;
    public $phone;
	public $password;
	public $email;

    public function init($sql, $tablename, $id)
    {
        $this->id = $id;
        $this->sql = $sql;
        $this->tablename = $tablename;

        $result = $this->sql->query("SELECT * FROM $this->tablename WHERE id = '" . $id . "'");
        $row = $result->fetch_assoc();

        $this->product_id = $row['product_id'];
        $this->product_name = $row['product_name'];
        $this->product_price = $row['product_price'];
        $this->product_image = $row['product_image'];
        $this->adddate = $row['adddate'];
        $this->sessionid = $row['sessionid'];
        $this->firstname = $row['firstname'];
        $this->lastname = $row['lastname'];
        $this->address = $row['address'];
        $this->country = $row['country'];
        $this->zip = $row['zip'];
        $this->city = $row['city'];
        $this->phone = $row['phone'];
		$this->email = $row['email'];
		$this->password = $row['password'];
    }
    //Tällä funktiolla haetaan dataa cart tablesta missä sessionid on session_id(); // Callaan $sessionid = session_id() sivulla itsessään
    public function getData($sessionid)
    {
        $sql = "SELECT * FROM cart WHERE sessionid = '" . $sessionid . "'";
        $result = $this->sql->query($sql);
        if (!$result) {
            echo "Error: " . mysqli_error($this->sql);
        }

        return $result;
    }
    //Haetaan products taulusta kaikki (tätä voi käyttää mille vain taululle jos haluaa)
    public function getProducts(){
    
    $sql = "SELECT * FROM $this->tablename";
    $result = $this->sql->query($sql);

    if (!$result) {
        echo "Error: " . mysqli_error($this->sql);
    }

    return $result; 
    }
    // Tällä funktiolla haen kaksi productia näkyviin "Featured products" home-pagelle.
    public function getTwo()
    {
        $sql = "SELECT * FROM $this->tablename WHERE id in (4,10,18)";
        $result = $this->sql->query($sql);

        if (!$result) {
            echo "Error: " . mysqli_error($this->sql);
        }

        return $result; 
    }
    // Tällä funktiolla otan mistä vaan tablesta minkä vaan id:n, käytössä single product sivulla
    public function getOne()
    {
        $sql = "SELECT * FROM $this->tablename WHERE id = $this->product_id";
        $result = $this->sql->query($sql);

        if (!$result) {
            echo "Error: " . mysqli_error($this->sql);
        }

        return $result;
    }
    // Funktio, jolla saadaan shop pagelle categorian mukaan näkymään tuotteet
    public function getByCategory($category) {
        $category = $this->sql->real_escape_string($category);
        $query = "SELECT * FROM products WHERE category = '$category'";
        $result = $this->sql->query($query);
        return $result;
    }
    // Funktio jolla saa kaikki tiedot mistä vaan tablesta SQL-tietokannasta
    public function getAll()
    {
        $sql = "SELECT * FROM $this->tablename";
        $result = $this->sql->query($sql);

        if (!$result) {
            echo "Error: " . mysqli_error($this->sql);
        }

        return $result;
    }
    // Funktio, joka lisää tuotteen ostoskoriin käyttäjän session id:n perusteella
    public function addToCart($product_id, $product_name, $product_price, $product_image, $sessionid) {
        $tablename = "cart"; // Ostoskorin taulun nimi tietokannassa
        $customer_id = 0; // Asetetaan asiakkaan id-arvo nollaksi !!!Koska ei ole sisäänkirjattua asiakasta!!!
        
        // Tarkistetaan, onko tuote jo lisätty ostoskoriin
        $sql = "SELECT * FROM $tablename WHERE sessionid = '$sessionid' AND product_id = $product_id";
        $result = $this->sql->query($sql);
        if (mysqli_num_rows($result) > 0) { // Jos tuote on jo lisätty ostoskoriin
            $row = mysqli_fetch_assoc($result); // Haetaan tuotteen tiedot taulusta
            $quantity = $row['quantity'] + 1; // Kasvatetaan tuotteen määrää yhdellä
            $sql = "UPDATE $tablename SET quantity = $quantity WHERE sessionid = '$sessionid' AND product_id = $product_id"; // Päivitetään tuotteen määrä tauluun
        } else { // Jos tuotetta ei ole vielä lisätty ostoskoriin
            $quantity = 1; // Asetetaan tuotteen määrä yhdeksi
            $sql = "INSERT INTO $tablename (customer_id, product_id, product_name, product_price, product_image, adddate, sessionid, quantity)
            VALUES ($customer_id, $product_id, '$product_name', $product_price, '$product_image', now(), '$sessionid', 1)"; // Lisätään uusi rivi tauluun
        }
        
        $result = $this->sql->query($sql); // Suoritetaan kysely
        if (!$result) { // Jos kysely epäonnistuu
            echo "Error: " . mysqli_error($this->sql); // Näytetään virheilmoitus
        }
    }

    
    // Funktio, joka poistaa tuotteen ostoskorista käyttäjän session id:n perusteella
    public function removeFromCart($product_id, $sessionid){
        $tablename = "cart";
        $sql = "DELETE FROM $tablename WHERE product_id = $product_id AND sessionid = '$sessionid'"; // Poistetaan tuote ostoskorista, jossa on käyttäjän oma session id
        $result = $this->sql->query($sql);
        if (!$result) {
            //echo "Error: " . mysqli_error($this->sql);
        } else {
            return false;
        }
    }
    // Funktio, joka palauttaa tietokantayhteyden
    public function getSql() {
        return $this->sql;
    }
    // Funktio, joka päivittää tuotteen määrän ostoskorissa käyttäjän session id:n perusteella
    public function updateCart($product_id, $quantity, $sessionid) {
        $tablename = "cart"; // Ostoskorin taulun nimi tietokannassa
        $sql = "UPDATE $tablename SET quantity=$quantity WHERE sessionid='$sessionid' AND product_id=$product_id"; // Päivitetään ostoskorin tuotteen määrä, jossa on käyttäjän oma session id
        $result = $this->sql->query($sql);
        if (!$result) {
            echo "Error: " . mysqli_error($this->sql);
        } else {
            header("Location: cart.php");
            exit;
        }
    }
    // Funktio, joka laskee, kuinka monta tuotetta käyttäjä on lisännyt ostoskoriin
    // Palauttaa lukumäärän
    public function getCartItemCount($sessionid) {
        $tablename = "cart"; // Ostoskorin taulun nimi tietokannassa
        $sql = "SELECT SUM(quantity) as item_count FROM $tablename WHERE sessionid='$sessionid'"; // Hae kaikkien lisättyjen tuotteiden määrä ostoskorista, jossa on käyttäjän oma session id
        $result = $this->sql->query($sql); 
        if ($result) { 
            $row = mysqli_fetch_assoc($result);
            return $row['item_count']; // Palauta tuotteiden määrä
        } else {
            return 0;
        }
    }

    // Funktio, joka laskee ostoskorin kokonaissumman
    // Palauttaa summan
    public function getCartTotal($sessionid) {
        $tablename = "cart"; // Ostoskorin taulun nimi tietokannassa
        $sql = "SELECT SUM(product_price * quantity) AS cart_total FROM $tablename WHERE sessionid = '$sessionid'"; // Hae ostoskorin tuotteiden kokonaishinta, jossa on käyttäjän oma session id
        $result = $this->sql->query($sql); 
        if (!$result) { 
            echo "Error: " . mysqli_error($this->sql);
        } else {
            $row = mysqli_fetch_assoc($result);
            return $row['cart_total']; // Palauta ostoskorin kokonaissumma
        }
    }

    // Funktio, joka laskee ostoskorin välisumman
    // Palauttaa välisumman
    public function getSubTotal($sessionid) {
        $tablename = "cart"; // Ostoskorin taulun nimi tietokannassa
        $sql = "SELECT SUM(product_price * quantity) AS cart_subtotal FROM $tablename WHERE sessionid = '$sessionid'"; // Hae ostoskorin tuotteiden välisumma, jossa on käyttäjän oma session id
        $result = $this->sql->query($sql);
        if (!$result) {
            echo "Error: " . mysqli_error($this->sql); 
        } else {
            $row = mysqli_fetch_assoc($result);
            return $row['cart_subtotal']; // Palauta ostoskorin välisumma
        }
    }
    //Funktio jolla haetaan customer name ideeellä
    function getName($customer_id) {
        global $sql; // globaali database-objekti, jotta sitä voidaan käyttää tässä funktiossa
        
        $query = "SELECT firstname FROM customer WHERE id = ?"; // valmisteilla oleva SQL-kysely
        $stmt = $sql->prepare($query); // käytetään prepare()-funktiota valmistelemaan kysely
        $stmt->bind_param("i", $customer_id); // liitetään käyttäjän id-parametri SQL-kyselyyn
        $stmt->execute(); // suoritetaan SQL-kysely
        $result = $stmt->get_result(); // tallennetaan SQL-kyselyn tulos muuttujaan $result
        
        if ($result->num_rows > 0) { // jos tuloksia on enemmän kuin 0
          $row = $result->fetch_assoc(); // käydään läpi tulokset ja tallennetaan ne taulukkoon
          return $row['firstname']; 
        } else {
          return false; // palautetaan epätosi, jos tuloksia ei ole
        }
    }
    // Funktio, joka hakee käyttäjän tietokannasta id:n perusteella.
    function getCustomer($customer_id) {
        global $sql;
    
        $query = "SELECT * FROM customer WHERE id = ?";
        $stmt = $sql->prepare($query);
        $stmt->bind_param("i", $customer_id);
        $stmt->execute();
        $result = $stmt->get_result();
    
        if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            return $row;
        } else {
            return false;
        }
    }
    //Muokkaa käyttääjää tietokannassa (Customer taulu sql)
	public function updateCustomer($customer_id, $email, $password){
        $query = "UPDATE $this->tablename SET email = '$email', password = '$password' WHERE id = $customer_id";
        $result = $this->sql->query($query);
        return $result;
    }
    // Vaihtaa käyttäjän salasanan PELKÄSTÄÄN
    public function changePassword($customer_id, $password): bool {
		if($this->sql->query("UPDATE customer SET password = '$password' WHERE id = $customer_id")) { // Jos tämä SQL-kysely menee läpi updatetaan customer taulussa salasanaa jossa id on logged in ID
			return true;
		} else {
			return false;
		}
	}
    // Vaihtaa käyttäjän tietoja customer taulussa
    public function changeContact($customer_id, $country, $zip, $city, $phone){
        // Valmistellaan SQL-lauseke, jossa käytetään ?-merkkejä paikkamerkkeinä
        $query = "UPDATE $this->tablename SET country = ?, zip = ?, city = ?, phone = ? WHERE id = ?";
    
        // Valmistellaan valmisteltu lauseke
        $stmt = $this->sql->prepare($query);
    
        // Liitetään muuttujat paikkamerkkeihin käyttäen bind_param-metodia
        // "ssssi" kertoo, että muuttujat ovat string, string, string, string, integer -tyyppisiä
        $stmt->bind_param("ssssi", $country, $zip, $city, $phone, $customer_id);
    
        // Suoritetaan lauseke ja tallennetaan tulosmuuttujaan
        $result = $stmt->execute();
    
        // Suljetaan valmisteltu lauseke
        $stmt->close();
    
        // Palautetaan tulos (true, jos päivitys onnistui, false muutoin)
        return $result;
    }     
}

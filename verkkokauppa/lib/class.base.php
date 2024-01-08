<?php

/**
* base-luokkakirjasto, tästä luokasta periytyy tiedot AllInOne.php:seen
* 
*/

class base {
	
	protected $id;
	protected $sql;
	protected $tablename;
	
	public function __construct($sql, $tablename, $id = null) {
		
		//tallennetaan saatu muuttuja olioon muuttujaksi, joka toimii muissakin metodeissa
		$this->id = $id;
		$this->sql = $sql;
		$this->tablename = $tablename;
		
	}
}
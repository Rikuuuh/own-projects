//Navbar mobile
const bar = document.getElementById('bar');
const close = document.getElementById('close');
const nav = document.getElementById('navbar');

if (bar) {
    bar.addEventListener('click', () => {
        nav.classList.add('active');
    })
}

if (close) {
    close.addEventListener('click', () => {
        nav.classList.remove('active');
    })
}

//Login popup
document.querySelector("#show-login").addEventListener("click", function(){
    document.querySelector(".popup").classList.add("active");
});
document.querySelector(".popup .close-btn").addEventListener("click", function(){
    document.querySelector(".popup").classList.remove("active");
});




const modalContainer = document.getElementById('modal-container');
const modalProductName = document.getElementById('modal-product-name');
const modalProductDescription = document.getElementById('modal-product-description');
const modalProductPrice = document.getElementById('modal-product-price');


const slides = document.querySelectorAll('.slide');
slides.forEach(slide => {
  // Haetaan slide data
  const productName = slide.querySelector('[name="product_name"]').value;
  const productDescription = slide.querySelector('[name="product_description"]').value;
  const productPrice = slide.querySelector('[name="product_price"]').value;

  // Lisätään addEventListener mouselle
  slide.addEventListener('mouseenter', () => {

    modalProductName.textContent = productName;
    modalProductDescription.textContent = productDescription;
    modalProductPrice.textContent = productPrice;

    // Näytä modal
    modalContainer.style.display = 'block';
  });

  // Piilotetaan modal kun hiiri lähtee pois sen päältä
  slide.addEventListener('mouseleave', () => {
    modalContainer.style.display = 'none';
  });
});

// Funktio jolla näytetään viesti "Your product has been added to the cart!"
function showMessage(message) {
    var messageEl = document.createElement("h2");
    messageEl.classList.add("message");
    messageEl.innerText = message;
    document.getElementById("message-container").appendChild(messageEl);
}
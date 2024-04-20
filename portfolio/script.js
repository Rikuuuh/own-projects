function toggleMenu() {
    const menu = document.querySelector(".menu-links");
    const icon = document.querySelector(".hamburger-icon");
    menu.classList.toggle("open");
    icon.classList.toggle("open");
  }

function openModal(modalId) {
    var modal = document.getElementById(modalId);
    modal.style.display = "block";
  }
  
function closeModal(modalId) {
    var modal = document.getElementById(modalId);
    modal.style.display = "none";
  }

  var slideIndexes = {
    modal1: 1,
    modal2: 1,
    modal3: 1
  };
  
  function plusSlides(n, modalId) {
    showSlides(slideIndexes[modalId] += n, modalId);
  }
  
  function showSlides(n, modalId) {
    var i;
    var slides = document.querySelectorAll("#" + modalId + " .slide");
    if (n > slides.length) { slideIndexes[modalId] = 1; }
    if (n < 1) { slideIndexes[modalId] = slides.length; }
    for (i = 0; i < slides.length; i++) {
        slides[i].style.display = "none";  
    }
    slides[slideIndexes[modalId] - 1].style.display = "block";  
  }


  function toggleDropdown() {
    var dropdown = document.querySelector('.lang-dropdown');
    dropdown.style.display = dropdown.style.display === 'none' ? 'block' : 'none';
  }
  
  function switchLanguage(lang) {
    var elements = document.querySelectorAll('[data-lang]');
    elements.forEach(function(el) {
        el.textContent = el.getAttribute('data-' + lang);
    });
    
    // Päivitä "Select Language" teksti valitun kielen mukaan
    var languageText = document.querySelector('.current-lang');
    if (lang === 'eng') {
        languageText.innerHTML = '<img src="assets/Englandflag.png" alt="UK Flag"> ENG';
    } else if (lang === 'fi') {
        languageText.innerHTML = '<img src="assets/Finlandflag.png" alt="Finland Flag"> FIN';
    }

    // Piilota dropdown-valikko kielen vaihdon jälkeen
    document.querySelector('.lang-dropdown').style.display = 'none';
}

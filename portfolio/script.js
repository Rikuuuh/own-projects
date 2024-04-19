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
  function switchLanguage(lang) {
    var elements = document.querySelectorAll('[data-lang]');
    elements.forEach(function(el) {
      el.textContent = el.getAttribute('data-' + lang);
    });
  }
  
  
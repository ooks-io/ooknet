function initToggleMenu() {
  const menuToggle = document.querySelector(".menu-toggle");
  const notebook = document.querySelector(".notebook");

  menuToggle.addEventListener("click", function (e) {
    e.preventDefault();
    notebook.classList.toggle("notebook--menu-toggled");
  });
}

document.addEventListener("DOMContentLoaded", initToggleMenu);

document.addEventListener("DOMContentLoaded", function () {
  const toggles = document.querySelectorAll('[data-toggle="collapse"]');

  toggles.forEach((toggle) => {
    toggle.addEventListener("click", function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute("data-target"));
      if (target) {
        target.classList.toggle("show");
        this.classList.toggle("collapsed");
        this.setAttribute(
          "aria-expanded",
          this.classList.contains("collapsed") ? "false" : "true",
        );
      }
    });
  });
});

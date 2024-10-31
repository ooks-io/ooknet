let checkbox = document.querySelector("input[name=theme-switch]");

function setTheme(isDark) {
  if (isDark) {
    document.documentElement.classList.add("dark-theme");
    document.documentElement.classList.remove("light-theme");
    checkbox.checked = true;
  } else {
    document.documentElement.classList.remove("dark-theme");
    document.documentElement.classList.add("light-theme");
    checkbox.checked = false;
  }
  // save the theme preference to local storage
  localStorage.setItem("darkTheme", isDark);
}

// check for saved theme preference
let savedTheme = localStorage.getItem("darkTheme");

if (savedTheme !== null) {
  // use the saved theme if it exists
  setTheme(savedTheme === "true");
} else if (window.matchMedia("(prefers-color-scheme: dark)").matches) {
  // if no saved preference, check system preference
  setTheme(true);
} else {
  setTheme(false);
}

// switch theme if checkbox is toggled
checkbox.addEventListener("change", (event) => {
  console.log("button clicked");
  setTheme(event.target.checked);
});

// listen for system color-scheme changes
window
  .matchMedia("(prefers-color-scheme: dark)")
  .addEventListener("change", (e) => {
    setTheme(e.matches);
  });

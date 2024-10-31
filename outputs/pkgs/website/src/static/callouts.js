function processCallouts() {
  console.log("Processing callouts");
  const content = document.querySelector(".content");
  if (content) {
    const blockquotes = content.querySelectorAll("blockquote");
    blockquotes.forEach((blockquote) => {
      const firstParagraph = blockquote.querySelector("p");
      if (firstParagraph && firstParagraph.textContent.startsWith("[!")) {
        const match = firstParagraph.textContent.match(/\[!(\w+)\]/);
        if (match) {
          const type = match[1].toLowerCase();
          console.log(`Matched callout: ${type}`);

          // remove the [!type] from the first paragraph
          firstParagraph.textContent = firstParagraph.textContent.replace(
            /\[!\w+\]\s*/,
            "",
          );

          // create the callout structure
          const callout = document.createElement("div");
          callout.className = `callout callout--${type}`;

          const title = document.createElement("div");
          title.className = "callout__title";

          const icon = document.createElement("span");
          icon.className = `icon icon--medium icon__${type}`;

          const titleText = document.createElement("span");
          titleText.textContent = type.charAt(0).toUpperCase() + type.slice(1);

          title.appendChild(icon);
          title.appendChild(titleText);

          callout.appendChild(title);

          // move blockquote contents to the callout
          callout.appendChild(title);
          while (blockquote.firstChild) {
            callout.appendChild(blockquote.firstChild);
          }

          // replace the blockquote with the callout
          blockquote.parentNode.replaceChild(callout, blockquote);
        }
      }
    });
  }
}

document.addEventListener("DOMContentLoaded", processCallouts);
window.addEventListener("load", processCallouts);

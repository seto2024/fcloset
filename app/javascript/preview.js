document.addEventListener("turbo:load", () => {
    console.log("✅ preview.js loaded");
    const input = document.getElementById("image_input");
    const preview = document.getElementById("preview_image");
  
    if (input && preview) {
      input.addEventListener("change", () => {
        const file = input.files[0];
        if (file && file.type.match("image.*")) {
          const reader = new FileReader();
          reader.onload = (e) => {
            preview.src = e.target.result;
            preview.classList.remove("hidden");
          };
          reader.readAsDataURL(file);
        } else {
          preview.classList.add("hidden");
          preview.src = "#";
        }
      });
    }
  });

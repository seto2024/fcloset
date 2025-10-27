// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "preview"


document.addEventListener("DOMContentLoaded", () => {
    const input = document.getElementById("image_input");
    const preview = document.getElementById("preview_image");
    const removeBtn = document.getElementById("remove_image_btn");
  
    if (input && preview && removeBtn) {
      input.addEventListener("change", () => {
        const file = input.files[0];
        if (file) {
          preview.src = URL.createObjectURL(file);
          preview.classList.remove("hidden");
          removeBtn.classList.remove("hidden");
        }
      });
  
      removeBtn.addEventListener("click", () => {
        input.value = ""; // 選択をクリア
        preview.src = "#";
        preview.classList.add("hidden");
        removeBtn.classList.add("hidden");
      });
    }
  });

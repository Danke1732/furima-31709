if (document.URL.match( /items/ ) && document.URL.match( /new/ ) || document.URL.match( /items/ ) && document.URL.match( /[0-9]/ ) && document.URL.match( /edit/ ) || document.URL.match( /items/ ) && document.URL.match( /[0-9]/ ) || document.URL.match( /items/ )) {
  window.addEventListener('DOMContentLoaded', function() {
    const ImageList = document.getElementById('image-content');
  
    document.getElementById('item-image').addEventListener('change', (e) => {
      const imageBefore = document.querySelector('.review-image');
      if (imageBefore) {
        imageBefore.remove();
      }

      function createImageHTML(blob) {
        const imageDisplay = document.createElement('div');
        const image = document.createElement('img');
        image.setAttribute('src', blob);
        image.setAttribute('class', 'review-image');
        imageDisplay.appendChild(image);
        ImageList.appendChild(imageDisplay);
      }

      const file = e.target.files[0];
      const blob = window.URL.createObjectURL(file);
      
      createImageHTML(blob);
    });
  });
}
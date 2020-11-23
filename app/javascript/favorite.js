if (document.URL.match( /items/ ) && document.URL.match( /[0-9]/ )) {
  function like() { 
    const favoriteBtn = document.querySelector('.favorite-btn');
    const favoriteCount = document.querySelector('.favorite-count');
    if (favoriteBtn.getAttribute('data-load') != null) {
      return null;
    }
    favoriteBtn.setAttribute('data-load', 'true');
    favoriteBtn.addEventListener('click', () => {
      const itemId = favoriteBtn.getAttribute('data-num');
      const XHR = new XMLHttpRequest();
      XHR.open('GET', `/favorites/${itemId}`, true);
      XHR.responseType = 'json';
      XHR.send();
      XHR.onload = () => {
        if (XHR.status !== 200) {
          alert(`Error ${XHR.status}: ${XHR.statusText}`);
          return null;
        }
        const favoriteAfter = XHR.response.favorite;
        let count = XHR.response.count;
        if (favoriteAfter != null) {
          favoriteBtn.setAttribute('data-check', 'true');
          favoriteCount.innerHTML = `お気に入り ${count}`
        } else if (favoriteAfter == null) {
          favoriteBtn.removeAttribute('data-check');
          favoriteCount.innerHTML = `お気に入り ${count}`
        }
      }
    });
  };
  setInterval(like, 1000);
}
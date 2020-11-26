if (document.URL.match( /items/ ) && document.URL.match( /[0-9]/ )) {
  function commentDelete() {
    let deletes = document.querySelectorAll('.comment-delete');
    for (let i = 0; i < deletes.length; i++) {
      deletes[i].addEventListener('click', (e) => {
        if (deletes[i].getAttribute('data-load') != null) {
          return null;
        }
        deletes[i].setAttribute('data-load', 'true');
        const commentBox = document.querySelector('.comment-box');
        const itemId = commentBox.getAttribute('id');
        const getId = e.target.id;
        const XHR = new XMLHttpRequest();
        XHR.open('DELETE', `/items/${itemId}/comments/${getId}`, true)
        XHR.responseType = 'json';
        XHR.send();
        XHR.onload = () => {
          if (XHR.status != 200) {
            alert(`Error ${XHR.status}: ${XHR.statusText}`);
            return null;
          }
          const comment = XHR.response.comment;
          if (comment == null) {
            deletes[i].parentNode.remove();
          }
        }
      });
    }
  }
  setInterval(commentDelete, 2000);
}
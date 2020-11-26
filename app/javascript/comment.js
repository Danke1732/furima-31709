if (document.URL.match( /items/ ) && document.URL.match( /[0-9]/ )) {
  function commentUp() {
    const commentBtn = document.querySelector('.comment-btn');
    if (commentBtn.getAttribute('data-load') != null) {
      return null;
    }
    commentBtn.setAttribute('data-load', 'true');
    commentBtn.addEventListener('click', (e) => {
      const commentForm = document.getElementById('comment-form');
      const commentBox = document.querySelector('.comment-box');
      const itemId = commentBox.getAttribute('id');
      const form = new FormData(commentForm);
      const XHR = new XMLHttpRequest();
      XHR.open('POST', `/items/${itemId}/comments`, true);
      XHR.responseType = 'json';
      XHR.send(form);
      XHR.onload = () => {
        if (XHR.status != 200) {
          alert(`Error ${XHR.status}: ${XHR.statusText}`);
          return null;
        }
        const sendErrorMessage = XHR.response.error;
        // バリデーションエラー発生時の処理
        const errorAlert = document.querySelector('.comment-alert');
        if (sendErrorMessage != null) {
          if (errorAlert) {
            errorAlert.remove();
          }
          const errorMessage = `
          <div class="comment-alert">
            <ul>
              <li class="error-message">${sendErrorMessage}</li>
            </ul>
          </div>`;
          const commentBox = document.querySelector('.comment-box');
          commentBox.insertAdjacentHTML('afterbegin', errorMessage);
          return null;
        }
        // 正しくコメント入力された場合の処理
        if (errorAlert) {
          errorAlert.remove();
        }
        const updateComment = XHR.response.comment;
        const updateCommentUser = XHR.response.user;
        const commentsIndicate = document.getElementById('comments-indicate');
        const li = document.createElement('li');
        li.classList.add('comment');
        const HTML = `
        <h3 class="comment_user">${updateCommentUser.nickname}</h3>
        <div>${updateComment.text}</div>
        <div class="comment-delete" id="${updateComment.id}">削除</div>
        <div class="clearfix"></div>`;
        li.insertAdjacentHTML('beforeend', HTML);  
        commentsIndicate.appendChild(li);
        const commentText = document.getElementById('comment_text');
        commentText.value = "";
      };
      e.preventDefault();
    });
  }
  setInterval(commentUp, 2000);
}
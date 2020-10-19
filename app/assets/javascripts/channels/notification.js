App.notification = App.cable.subscriptions.create("NotificationChannel", {
  connected: function () { },
  disconnected: function () { },

  // サーバーからデータを受け取ったとき
  received: function (data) {
    // 通知の内容を変更する
    const notification = document.querySelector('.toast');
    notification.textContent = '更新が完了しました！';

    // 3秒後に通知を削除する
    setTimeout(() => {
      notification.remove();
    }, 3000)

    // return alert(`${data['email']} ${data['password']}`);
  },

  // サーバーにデータを送る
  display: function (email, password) {
    // 通知を作成、表示する
    const notification = createNotification('更新中です...');
    console.log(notification);
    document.querySelector('body').appendChild(notification);

    return this.perform('display', {
      email: email,
      password: password
    });
  }
});

/**
 * 通知を作成する
 * @param {String} content 
 */
function createNotification(content) {
  const notification = createElementFromHtml('<div class="toast p-3 shadow-sm toast-default"></div>');
  const p = createElementFromHtml(`<p class="mb-0">${content}</p>`);
  notification.appendChild(p);
  return notification
}

/**
 * 文字列のHTMLからHTMLElementを生成する
 * @param {String} html 
 */
function createElementFromHtml(html) {
  const elem = document.createElement('div');
  elem.innerHTML = html
  return elem.firstChild;
}
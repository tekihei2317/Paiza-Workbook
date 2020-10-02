document.addEventListener('turbolinks:load', () => {
  console.log('page loaded!');

  const form = document.querySelector('form');

  form.addEventListener('ajax:success', (event) => {
    // クライアントサイドで問題フィルタリング処理を書く
    data = event.detail[0];
    // console.log(data);
    // console.log(data.rank.min);
    // console.log(data.hideSolved);
  });
});
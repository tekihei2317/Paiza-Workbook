document.addEventListener('turbolinks:load', () => {
  console.log('page loaded!');

  const form = document.querySelector('form');
  const table = document.querySelector('table');

  // HTMLCollection->Array
  const problems = Array.from(document.getElementsByClassName('problem'));
  console.log(problems);

  form.addEventListener('ajax:success', (event) => {
    // クライアントサイドで問題フィルタリング処理を書く
    const data = event.detail[0];
    console.log(data);
    rankToNumber = { D: 0, C: 1, B: 2, A: 3, S: 4 };

    // 条件に合う問題だけ抜き出す
    filtered_problems = problems.filter((problem) => {
      const rank = rankToNumber[problem.childNodes[0].textContent];
      const difficulty = Number(problem.childNodes[3].textContent);

      let ok = true;
      ok = ok && (data.rank.min <= rank && rank <= data.rank.max);
      ok = ok && (data.difficulty.min <= difficulty && difficulty <= data.difficulty.max);
      ok = ok && (!data.hideSolved || !problem.classList.contains('table-success'))
      return ok;
    });

    // 一旦全部消去する
    problems.forEach((problem) => {
      problem.remove();
    });

    // 抜き出した問題を追加する
    filtered_problems.forEach((problem) => {
      table.appendChild(problem);
    })
  });
});
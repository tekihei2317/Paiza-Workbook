(() => {
  let table = null;
  let problems = null;

  document.addEventListener('turbolinks:load', () => {
    console.log('page loaded!');

    form = document.querySelector('form');
    table = document.querySelector('table');

    // HTMLCollection->Array
    problems = Array.from(document.getElementsByClassName('problem'));
    console.log(problems);

    eventSetting();

  });

  function eventSetting() {
    setFilterEvent();
  }

  function setFilterEvent() {
    const form = document.querySelector('form');
    console.log(form);
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

      // 一旦全部消去してから、フィルタした問題を追加する
      problems.forEach((problem) => problem.remove());
      filtered_problems.forEach((problem) => table.appendChild(problem));
    });
  }
})();
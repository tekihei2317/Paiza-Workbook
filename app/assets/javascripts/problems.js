(() => {
  let table = null;
  let allProblems = null;

  document.addEventListener('turbolinks:load', () => {
    console.log('page loaded!');

    form = document.querySelector('form');
    table = document.querySelector('table');

    // HTMLCollection->Array
    allProblems = Array.from(document.getElementsByClassName('problem'));
    console.log(allProblems);

    eventSetting();

  });

  function eventSetting() {
    setFilterEvent();
    setSortEvent();
  }

  // 引数で指定した問題だけを表示する
  function applyProblems(problems) {
    // 一旦全部消去してから追加する
    allProblems.forEach((problem) => problem.remove());
    problems.forEach((problem) => table.appendChild(problem));
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
      filtered_problems = allProblems.filter((problem) => {
        const rank = rankToNumber[problem.childNodes[0].textContent];
        const difficulty = Number(problem.childNodes[3].textContent);

        let ok = true;
        ok = ok && (data.rank.min <= rank && rank <= data.rank.max);
        ok = ok && (data.difficulty.min <= difficulty && difficulty <= data.difficulty.max);
        ok = ok && (!data.hideSolved || !problem.classList.contains('table-success'))
        return ok;
      });

      // 変更を反映する
      applyProblems(filtered_problems);
    });
  }

  function setSortEvent() {
    const difficultyElem = document.querySelector('tr').childNodes[3];
    difficultyElem.addEventListener('click', () => {
      const currentProblems = Array.from(document.getElementsByClassName('problem'));

      // 難易度順に並べ替える
      currentProblems.sort((a, b) => {
        difficultyA = Number(a.childNodes[3].textContent);
        difficultyB = Number(b.childNodes[3].textContent);
        return difficultyA - difficultyB;
      })

      // 変更を反映する
      applyProblems(currentProblems);
    });
  }
})();
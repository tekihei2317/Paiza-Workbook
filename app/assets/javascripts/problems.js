(() => {
  let table = null;
  let allProblems = null;

  document.addEventListener('turbolinks:load', () => {
    console.log('page loaded!');

    form = document.querySelector('form');
    table = document.querySelector('table');
    // HTMLCollection->Array
    allProblems = Array.from(document.getElementsByClassName('problem'));

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
    form.addEventListener('ajax:success', (event) => {
      // クライアントサイドで問題フィルタリング処理を書く
      const data = event.detail[0];
      console.log(data);
      const rankToInt = { D: 0, C: 1, B: 2, A: 3, S: 4 };

      // 条件に合う問題だけ抜き出す
      filtered_problems = allProblems.filter((problem) => {
        const rank = rankToInt[problem.childNodes[0].textContent[0]];
        const difficulty = Number(problem.childNodes[2].textContent);

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

  function comp(a, b) {
    if (a === b) return 0;
    return a > b ? 1 : -1;
  }

  function idToInt(id) {
    const rankToInt = { D: 0, C: 1, B: 2, A: 3, S: 4 };
    const rank = rankToInt[id[0]];
    const number = Number(id.slice(1));
    // ランクが等しい場合は問題番号の大小関係、
    // ランクが異なる場合はランクの大小関係が保たれるような数値に変換する
    return rank * 1000 + number;
  }

  function setSortEvent() {
    // 難易度順のソート
    document.querySelector('tr').childNodes.forEach((th, index) => {
      // 名前のカラムではソートしない
      if (index === 1) return;

      th.addEventListener('click', () => {
        console.log('th clicked!');
        const currentProblems = Array.from(document.getElementsByClassName('problem'));

        currentProblems.sort((problemA, problemB) => {
          valueA = problemA.childNodes[index].textContent;
          valueB = problemB.childNodes[index].textContent;
          // IDを数値に変換する
          if (index === 0) [valueA, valueB] = [idToInt(valueA), idToInt(valueB)];
          return comp(valueA, valueB);
        });

        // 変更を反映する
        applyProblems(currentProblems);
      });
    })
  }
})();
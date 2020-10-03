(() => {
  let table = null;
  let allProblems = null;

  const COLUMN_COUNT = 6;
  // カラムが昇順ソートされているか
  let isColumnSortedAsc = new Array(COLUMN_COUNT).fill(false);
  // IDは最初ソートされているのでtrueにする
  isColumnSortedAsc[0] = true;

  document.addEventListener('turbolinks:load', () => {
    console.log('page loaded!');

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

  // フィルタリング処理を設定する
  function setFilterEvent() {
    const form = document.querySelector('form');
    form.addEventListener('ajax:success', (event) => {
      // クライアントサイドで問題フィルタリング処理を書く
      const data = event.detail[0];
      console.log(data);
      const rankToInt = { D: 0, C: 1, B: 2, A: 3, S: 4 };

      // 条件に合う問題だけ抜き出す
      filteredProblems = allProblems.filter((problem) => {
        const rank = rankToInt[problem.childNodes[0].textContent[0]];
        const difficulty = Number(problem.childNodes[2].textContent);

        let ok = true;
        ok = ok && (data.rank.min <= rank && rank <= data.rank.max);
        ok = ok && (data.difficulty.min <= difficulty && difficulty <= data.difficulty.max);
        ok = ok && (!data.hideSolved || !problem.classList.contains('table-success'))
        return ok;
      });

      // 変更を反映する
      applyProblems(filteredProblems);
    });
  }

  // IDでソート出来るように数値に変換する
  function idToInt(id) {
    const rankToInt = { D: 0, C: 1, B: 2, A: 3, S: 4 };
    const rank = rankToInt[id[0]];
    const number = Number(id.slice(1));
    // ランクが等しい場合は問題番号の大小関係、
    // ランクが異なる場合はランクの大小関係が保たれるような数値に変換する
    return rank * 1000 + number;
  }

  // 秒に変換する
  function timeToInt(id) {
    const [m, s] = id.match(/\d+/g).map((num) => Number(num));
    return m * 60 + s;
  }

  // ソート処理を設定する
  function setSortEvent() {
    // 難易度順のソート
    document.querySelector('tr').childNodes.forEach((th, index) => {
      // 名前のカラムではソートしない
      if (index === 1) return;

      th.addEventListener('click', () => {
        console.log('th clicked!');
        const currentProblems = Array.from(document.getElementsByClassName('problem'));

        // 昇順ソートされていない(ソートされていないor降順ソートされている)場合は昇順ソート、
        // 昇順ソートされている場合は場合は降順ソートする
        currentProblems.sort((problemA, problemB) => {
          valueA = problemA.childNodes[index].textContent;
          valueB = problemB.childNodes[index].textContent;

          // ソートできるように数値に変換する
          if (index === 0) {
            // IDの場合
            [valueA, valueB] = [idToInt(valueA), idToInt(valueB)];
          } else if (index === 3) {
            // 時間の場合
            [valueA, valueB] = [timeToInt(valueA), timeToInt(valueB)];
          } else {
            // その他(数値)の場合
            [valueA, valueB] = [Number(valueA), Number(valueB)];
          }
          return !isColumnSortedAsc[index] ? valueA - valueB : valueB - valueA;
        });

        // 昇順ソートされているかのフラグを更新する
        isColumnSortedAsc = isColumnSortedAsc.map((sortFlag, i) => {
          if (i === index) return !sortFlag
          return false;
        });

        // 変更を反映する
        applyProblems(currentProblems);
      });
    })
  }
})();
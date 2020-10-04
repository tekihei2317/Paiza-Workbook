(() => {
  let table = null;
  let allProblems = null;

  // 最初のカラムのソートの状態 [昇順, ソートされていない, 降順] = [1, 0, -1]
  const INITIAL_SORT_STATES = [1, 0, 0, 0, 0, 0];
  // 参照が代入されるので、コピーしてから代入する
  let columnSortStates = INITIAL_SORT_STATES.concat();

  // ソートされていないときに、どちらの方向にソートするか [昇順, 降順] = [1, -1]
  const INITIAL_SORT_DIRECTIONS = [1, 1, 1, 1, -1, -1];
  let firstSortDirections = INITIAL_SORT_DIRECTIONS.concat();

  document.addEventListener('turbolinks:load', () => {
    console.log('page loaded!');

    table = document.querySelector('table');
    // HTMLCollection->Array
    allProblems = Array.from(document.getElementsByClassName('problem'));

    setEvents();
  });

  function setEvents() {
    setFilterEvent();
    setSubmitEvent();
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

      selectedRanks = ['D', 'C', 'B', 'A', 'S'].filter((rank) => {
        return data.rank[rank.toLowerCase()];
      });
      console.log(selectedRanks);

      // 条件に合う問題だけ抜き出す
      filteredProblems = allProblems.filter((problem) => {
        const rank = problem.childNodes[0].textContent[0];
        const difficulty = Number(problem.childNodes[2].textContent);

        let ok = true;
        ok = ok && selectedRanks.includes(rank);
        ok = ok && (data.difficulty.min <= difficulty && difficulty <= data.difficulty.max);
        ok = ok && (!data.hideSolved || !problem.classList.contains('table-success'))
        return ok;
      });

      // 変更を反映する
      // console.log(filteredProblems.length);
      applyProblems(filteredProblems);

      // ソートの状態を元に戻す
      columnSortStates = INITIAL_SORT_STATES.concat();;
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

        // ソートされていない→最初のソートの向き、されている→逆向き
        let sortDirection = firstSortDirections[index];
        if (columnSortStates[index] !== 0) sortDirection = -columnSortStates[index];
        columnSortStates[index] = sortDirection;

        // ソートの状態を更新する
        columnSortStates = columnSortStates.map((sortState, i) => {
          return i === index ? sortDirection : 0;
        });

        // ソートする
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
          return (valueA - valueB) * sortDirection;
        });

        // 変更を反映する
        applyProblems(currentProblems);
      });
    })
  }

  // input要素、select要素の変更を検出して送信する
  function setSubmitEvent() {
    const submitBtn = document.querySelector('input[type=submit]');
    console.log(submitBtn);

    // セレクト要素とチェックボックスを取り出す
    selectElems = Array.from(document.querySelectorAll('select'));
    checkboxElems = Array.from(document.querySelectorAll('input[type=checkbox]'));
    targets = selectElems.concat(checkboxElems);
    console.log(targets);

    targets.forEach((target) => {
      target.addEventListener('change', () => submitBtn.click());
    });
  }
})();
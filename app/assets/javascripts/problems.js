(() => {
  let table = null;
  let allProblems = null;

  let isIdSortedAsc = false;
  let isDifficultySortedAsc = false;

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
    setSortByIdEvent();
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

  function setSortEvent() {
    // 難易度順のソート
    const difficultyElem = document.querySelector('tr').childNodes[2];
    difficultyElem.addEventListener('click', () => {
      const currentProblems = Array.from(document.getElementsByClassName('problem'));

      // 難易度順に並べ替える
      currentProblems.sort((a, b) => {
        difficultyA = Number(a.childNodes[2].textContent);
        difficultyB = Number(b.childNodes[2].textContent);
        return isDifficultySortedAsc === false ? difficultyA - difficultyB : difficultyB - difficultyA;
      })
      isDifficultySortedAsc = !isDifficultySortedAsc;

      // 変更を反映する
      applyProblems(currentProblems);
    });
  }

  function setSortByIdEvent() {
    // IDでのソート(同じランクなら番号順、ランクが別ならランク順)
    const idElem = document.querySelector('tr').childNodes[0];
    idElem.addEventListener('click', () => {
      const currentProblems = Array.from(document.getElementsByClassName('problem'));

      // IDからランクと問題番号を取得するための関数
      const rankToInt = { D: 0, C: 1, B: 2, A: 3, S: 4 };
      const parseId = (id) => {
        rank = rankToInt[id[0]];
        number = Number(id.slice(1));
        return [rank, number];
      };
      // console.log(parseId('S103'));

      // 並べ替える
      currentProblems.sort((a, b) => {
        [rankA, numberA] = parseId(a.childNodes[0].textContent);
        [rankB, numberB] = parseId(b.childNodes[0].textContent);
        sumA = rankA * 1000 + numberA;
        sumB = rankB * 1000 + numberB;
        return isIdSortedAsc === false ? sumA - sumB : sumB - sumA;
      })
      isIdSortedAsc = !isIdSortedAsc;

      // 変更を反映する
      applyProblems(currentProblems);
    });
  }
})();
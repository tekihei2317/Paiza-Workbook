// 問題を扱うクラス
class ProblemsUtility {
  /**
   * @constructor
   * @param {HTMLTableElement} table - 問題が入っているテーブル要素
   * @param {Array<HTMLTableRowElement>} allProblems - 全ての問題の配列
   */
  constructor(table, allProblems) {
    this.table = table;
    this.allProblems = allProblems;

    // 初期状態のソートの向き(1: 昇順、0: ソートされていない、-1: 降順)
    this.DEFAULT_SORT_DIRECTIONS = [1, 0, 0, 0, 0, 0];
    // ソートされていないときに、どちらの向きにソートするか
    this.FIRST_SORT_DIRECTIONS = [1, 1, 1, 1, - 1, -1];

    // 現在のソートの向き(参照が入らないようにコピーしてから代入する)
    this.currentSortDirections = this.DEFAULT_SORT_DIRECTIONS.concat();
  }

  // 問題の変更を反映する
  applyProblems(problems) {
    // 一旦全部消去してから追加する
    this.allProblems.forEach((problem) => problem.remove());
    problems.forEach((problem) => this.table.appendChild(problem));
  }

  // 問題IDをランク・問題番号の大小が保たれるように数値に変換する
  idToInt(id) {
    const rankToInt = { D: 0, C: 1, B: 2, A: 3, S: 4 };
    const rank = rankToInt[id[0]];
    const number = Number(id.slice(1));
    return rank * 1000 + number;
  }

  // 分:秒の形式の文字列を秒に変換する
  timeToInt(id) {
    const [m, s] = id.match(/\d+/g).map((num) => Number(num));
    return m * 60 + s;
  }

  // カラムの値を数値に変換する
  convertToNumber(value, index) {
    if (index === 0) return this.idToInt(value);
    if (index === 3) return this.timeToInt(value);
    return Number(value);
  }

  // フィルタ処理をするイベントを設定する
  setFilterEvent() {
    const form = document.getElementById('filter-form');

    // JSONを受け取ってフィルタ処理をする
    form.addEventListener('ajax:success', (event) => {
      const data = event.detail[0];
      console.log(data);

      const selectedRanks = ['D', 'C', 'B', 'A', 'S'].filter((rank) => {
        return data.rank[rank.toLowerCase()] === true;
      });
      console.log(selectedRanks);

      // 条件に合う問題だけ抜き出す
      const filteredProblems = this.allProblems.filter((problem) => {
        const rank = problem.childNodes[0].textContent[0];
        const difficulty = Number(problem.childNodes[2].textContent);

        let ok = true;
        ok = ok && selectedRanks.includes(rank);
        ok = ok && (data.difficulty.min <= difficulty && difficulty <= data.difficulty.max);
        ok = ok && (!data.hideSolved || !problem.classList.contains('table-success'))
        return ok;
      });
      // 変更を反映する
      this.applyProblems(filteredProblems);

      // ソートの状態を初期化する
      this.currentSortDirections = this.DEFAULT_SORT_DIRECTIONS.concat();
    });
  }

  // フォームの変更を検知して送信するイベントを設定する 
  setSubmitEvents() {
    const submitBtn = document.getElementById('filter-submit-btn');

    // セレクト要素とチェックボックスを取り出す
    const selectElems = Array.from(document.querySelectorAll('select'));
    const checkboxElems = Array.from(document.querySelectorAll('input[type=checkbox]'));
    const targets = selectElems.concat(checkboxElems);

    targets.forEach((target) => {
      target.addEventListener('change', () => submitBtn.click());
    });
  }

  // カラムをクリックしたときにソートするイベントを設定する
  setSortEvents() {
    document.querySelector('tr').childNodes.forEach((th, index) => {
      // 名前のカラムではソートしない
      if (index === 1) return;

      th.addEventListener('click', () => {
        let currentProblems = Array.from(document.getElementsByClassName('problem'));
        console.log(currentProblems.length);

        // ソートされていない→最初のソートの向き、されている→逆向きにソートする
        let nextDirection = this.FIRST_SORT_DIRECTIONS[index];
        if (this.currentSortDirections[index] !== 0) nextDirection = -this.currentSortDirections[index];

        // ソートする
        currentProblems.sort((problemA, problemB) => {
          let valueA = problemA.childNodes[index].textContent;
          let valueB = problemB.childNodes[index].textContent;

          // ソートできるように数値に変換する
          valueA = this.convertToNumber(valueA, index);
          valueB = this.convertToNumber(valueB, index);

          return (valueA - valueB) * nextDirection;
        });

        // ソートの状態を更新する
        this.currentSortDirections = this.currentSortDirections.map((direction, i) => {
          return i === index ? nextDirection : 0;
        });

        // 変更を反映する
        this.applyProblems(currentProblems);
      });
    });
  }
}

(() => {
  /**
   * @type {ProblemsUtility} - 問題を管理するクラス
   */
  let util = null;

  document.addEventListener('turbolinks:load', () => {
    console.log('page loaded!');

    const table = document.querySelector('table');
    const allProblems = Array.from(document.getElementsByClassName('problem'));
    util = new ProblemsUtility(table, allProblems);

    setEvents();
  });

  function setEvents() {
    util.setFilterEvent();
    util.setSubmitEvents();
    util.setSortEvents();
    isSignedIn();

    const statusUpdateBtn = document.getElementById('status-update-submit-btn');
    statusUpdateBtn.addEventListener('click', (event) => {
      // ログインしていない場合はデフォルトのイベントが発生するので、
      // グインページにリダイレクトする
      if (isSignedIn()) {
        event.preventDefault();

        const form = statusUpdateBtn.parentNode;
        const email = form.querySelector('input[type=email]').value
        const password = form.querySelector('input[type=password]').value

        // サーバー側にデータを渡す(NotificationChannel#display)
        App.notification.display(email, password);
      }
    });
  }

  function isSignedIn() {
    logoutBtn = document.getElementById('logout-btn')
    console.log(logoutBtn !== null);
    return logoutBtn !== null
  }
})();
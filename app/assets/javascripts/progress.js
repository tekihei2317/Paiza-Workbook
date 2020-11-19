(() => {
  function setEvent() {
    const paginatorContainer = document.getElementById('paginator');

    paginatorContainer.addEventListener('ajax:success', (event) => {
      const data = event.detail[0];
      // console.log(data.results);
      const resultsContainer = document.getElementById('results-table');

      resultsContainer.innerHTML = data.results;
      paginatorContainer.innerHTML = data.paginator;
    });
  }

  // #paginatorの描画待ち
  setTimeout(setEvent, 1000);
})();
(() => {
  function setEvent() {
    const paginatorContainer = document.getElementById('paginator');

    paginatorContainer.addEventListener('ajax:success', (event) => {
      const data = event.detail[0];
      // console.log(data.results);
      const resultsContainer = document.getElementById('results-table');
      console.log(data.results);

      resultsContainer.innerHTML = data.results;
      paginatorContainer.innerHTML = data.paginator;
    });
  }

  document.addEventListener('turbolinks:load', () => {
    setEvent();
  });
})();
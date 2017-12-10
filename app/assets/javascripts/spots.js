var ready;
//スポット一覧で使用している、データベーステーブルの日本語化
ready = function() {
  $('#spots').DataTable({
   "language": {
    "url": "//cdn.datatables.net/plug-ins/3cfcc339e89/i18n/Japanese.json"
   }
  });
};

$(document).ready(ready);
//スポット検索で、遷移後にスポット一覧が表示されるように対応
$(document).on('page:change', ready);

$(document).on('turbolinks:load',function() {
  var schedule_id = document.getElementById("schedule_id").value;
  var select = function(start, end) {
  };
  var calendar = $('#calendar').fullCalendar({
    header: {
      left: 'prev,next',
      center: 'title',
      right: 'month'
    },
    titleFormat: 'YYYY年 MM月',
    axisFormat: 'H:mm',
    timeFormat: 'H:mm',
    monthNames: ['１月','２月','３月','４月','５月','６月','７月','８月','９月','１０月','１１月','１２月'],
    monthNamesShort: ['１月','２月','３月','４月','５月','６月','７月','８月','９月','１０月','１１月','１２月'],
    dayNames: ['日曜日','月曜日','火曜日','水曜日','木曜日','金曜日','土曜日'],
    dayNamesShort: ['日','月','火','水','木','金','土'],
    events: {
        url: '/api/v1/schedule_each_date',
        type: 'get',
        data: {
            custom_param1: schedule_id,
        },
        error: function() {
            alert('there was an error while fetching events!');
        }
    },
    editable: false,        // 編集可
    selectable: true,      // 選択可
    selectHelper: true,    // 選択時にプレースホルダーを描画
    ignoreTimezone: false, // 自動選択解除
    select: select,        // 選択時に関数にパラメータ引き渡す
    buttonText: {
      prev:     '<',   // &lsaquo;
      next:     '>',   // &rsaquo;
      prevYear: '<<',  // &laquo;
      nextYear: '>>',  // &raquo;
      today:    '今日',
      month:    '月',
      week:     '週',
      day:      '日'
    },
    height: 600,                           // 高さ
    defaultView: 'month',             // 初期表示ビュー
    eventLimit: true,                      // allow "more" link when too many events
    firstDay: 0,                           // 最初の曜日, 0:日曜日
    allDaySlot: false,                     // 終日スロットを非表示
    allDayText:'',                   // 終日スロットのタイトル
    eventClick: function(event) { //イベントをクリックしたときに実行
      var id = event.id
      var show_url = "travel_planning_time/"+id
      location.href = show_url;
    }
   });
});

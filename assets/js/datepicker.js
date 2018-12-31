$(function() {
  if(isEdit()){
    datepicker(true);
  }else{
    datepicker();
  }
});

function isEdit () {
  if($('#order_monthly_date').val() != ''){
    return true;
  } else {
    return false;
  }
};

function datepicker(callback) {
  $('.monthly-date').datepicker({
    format: "dd/mm/yyyy",
    language: "pt-BR",
    autoclose: true,
    beforeShowDay: disableDates
  }).on('changeDate', function(e){
    var data = new Date(e.date);
    if(data.getDate() != 10 && data.getDate() != 25){
      $('.monthly-date').val('');
    }
  });

  if(callback){
    updateMonthlyDate();
  };
};

function updateMonthlyDate() {
  var date = $("#order_monthly_date").val().split("-");
  var date_format = new Date(date[0], date[1] - 1, date[2]);
  $('#order_monthly_date').datepicker('setDate', date_format);
};

function disableDates (date) {
  var day = date.getDate();
  if (day == 10 || day == 25) {
    return true;
  } else {
    return false;
  }
};

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

function disableDates (date) {
  var day = date.getDate();
  if (day == 10 || day == 25) {
    return true;
  } else {
    return false;
  }
}

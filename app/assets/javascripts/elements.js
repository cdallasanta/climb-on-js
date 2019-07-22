var showInspections = function(){
  // get call to server to retreive all periodic inspections from this element
  let elementId = $('#show-all-periodics').data("elementId");
  $.get(`/elements/${elementId}/periodic_inspections`, function(resp){
    // empty the ul, then populate with an li and a link to each inspection
    $('#periodic-ul').empty();
    resp.reverse().forEach(function(insp){
      $('#periodic-ul').append(`<li><a href="/elements/${insp.element.id}/periodic_inspections/${insp.id}/edit">${insp.date}</a></li>`);
    })
  })
}

$(function(){
  $("#show-all-periodics").click(function(e){
    e.preventDefault();
    showInspections();
  });
});
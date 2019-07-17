// $('form.periodic-form').on('submit', function(e){
//   e.preventDefault();
//   debugger;
// });

var test = function() {
  //get the element ID from the form's action attribute
  let elementId = $('form')[0].action.split('elements/').pop().split("/periodic").shift()

  let data = {
    "date": $("#periodic_inspection_date").val(),
    "equipment_complete": $("#periodic_inspection_equipment_complete").is(":checked"),
    "element_complete": $("#periodic_inspection_element_complete").is(":checked"),
    "environment_complete": $("#periodic_inspection_environment_complete").is(":checked"),
    "comments_attributes": [{
      "content": $('textarea').val()
    }]
  }

  if (this.id === "new_periodic_inspection") {
    // POST to db
    $.post(`/elements/${elementId}/periodic_inspections/`, data, function(resp){
      debugger;
      // set alert that it saved successfully
      // set form id
      // update comments
      $('textarea').val("");
    })
  } else if (this.id.includes("edit_periodic_inspection")) {
    // PATCH to db
    let inspectionId = this.id.replace("edit_periodic_inspection_","");

    // $.ajax({
    //   type: 'PATCH',
    //   url: `/periodic_inspections/${inspectionId}`,
    //   data: JSON.stringify(data),
    //   processData: false,
    //   contentType: 'application/merge-patch+json',
    //   success: function(resp){
    //     debugger;
    //   }
    // });

  }
}

$(function(){
  $('form').submit(function(e){
    e.preventDefault();
    test.call(this);
  });
});
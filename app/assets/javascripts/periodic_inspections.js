// $('form.periodic-form').on('submit', function(e){
//   e.preventDefault();
//   debugger;
// });

var saveInspection = function() {
  //get the element ID from the form's action attribute
  let elementId = $('form')[0].action.split('elements/').pop().split("/periodic").shift()

  let data = {
    "date": $("#periodic_inspection_date").val(),
    "equipment_complete": $("#periodic_inspection_equipment_complete").is(":checked"),
    "element_complete": $("#periodic_inspection_element_complete").is(":checked"),
    "environment_complete": $("#periodic_inspection_environment_complete").is(":checked"),
  }

  // if a comment was typed in, add it to data (otherwise, we would end up with empty comments saved to the db)
  if ($('textarea').val() != ""){
    data["comments_attributes"] = [{
      "content": $('textarea').val()
    }]
  }

  if (this.id === "new_periodic_inspection") {
    // POST to db
    $.post(`/elements/${elementId}/periodic_inspections/`, data, function(resp){
      // TODO set alert that it saved successfully

      // set form id
      $('form').data('inspection_id', resp.id)

      // update comments
      resp.comments.forEach(function(comment){
        $('#comments-previous').append(`<strong>${comment.user.fullname}: </strong>${comment.content}<br>`)
      })
      $('textarea').val("");

      // change "save" button to "update"
      $(':submit').text("Update Periodic Inspection");
    })
  } else if (this.id.includes("edit_periodic_inspection")) {
    // PATCH to db

    $.ajax({
      type: 'PATCH',
      url: `/periodic_inspections/${this.dataset.id}`,
      data: JSON.stringify(data),
      processData: false,
      contentType: 'application/merge-patch+json',
      success: function(resp){
        debugger;
      }
    });
  }
}

$(function(){
  $(':submit').click(function(event){
    event.preventDefault();
    saveInspection.call($('form')[0]);
  });
});
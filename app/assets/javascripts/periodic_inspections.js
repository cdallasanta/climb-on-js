var elementId;
var periodicService;

var saveInspection = function() {
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

  //if this is undefined, it's a new inspection. Otherwise, we're updating an old one
  let inspectionId = $('form').data("inspection-id")
  if (inspectionId === undefined) {
    periodicService.post(data)
  } else {
    periodicService.patch(data, inspectionId)
  }
}

class PeriodicInspection{
  constructor(data){
    this.id = data["id"],
    this.date = data["date"],
    this.equipment_complete = data["equipment_complete"],
    this.element_complete = data["element_complete"],
    this.environment_complete = data["environment_complete"],
    this.alert = data["alert"] || data["responseText"]
    this.comments = data["comments"]
  }

  updatePage() {
    // set form id
    $('form').data('inspection-id', this.id)

    this.updateComments();
    
    // TODO: update edited by

    // change "save" button to "update"
    $(':submit').val("Update Periodic Inspection");
    
    // alert bar = "success!"
    this.alertPartial()
  }
  
  updateComments(){
    $('#comments-previous').empty();
    this.comments.forEach(function(comment){
      $('#comments-previous').append(`<strong>${comment.user.fullname}: </strong>${comment.content}<br>`)
    })
    $('textarea').val("");
  }

  alertPartial(){
    $('#alert-ul').remove();
    $('form').prepend(this.alert);
  }
}

$(function(){
  //get the element ID from the form's action attribute
  elementId = $('form')[0].action.split('elements/').pop().split("/periodic").shift()
  periodicService = new ClimbOnService(elementId, "periodic")
   
  $(':submit').click(function(event){
    event.preventDefault();
    saveInspection();
  });
  $("textarea").keypress(function (e) {
    if(e.which == 13) {
      event.preventDefault();
      saveInspection();
    }
  });
});
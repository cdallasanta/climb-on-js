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

  //if this is undefined or an empty string, it's a new inspection. Otherwise, we're updating an old one
  let inspectionId = $('form').data("inspection-id")
  if (inspectionId === "" || inspectionId === undefined) {
    periodicService.post(data)
  } else {
    periodicService.patch(data, inspectionId)
  }
}

var loadInspection = function(date) {
  periodicService.get(date);
}

class PeriodicInspection{
  constructor(data){
    this.id = data["id"];
    this.date = data["date"];
    this.equipment_complete = data["equipment_complete?"];
    this.element_complete = data["element_complete?"];
    this.environment_complete = data["environment_complete?"];
    this.alert = data["alert"] || data["responseText"];
    this.comments = data["comments"];
    this.users = data["users"];
  }

  updatePage() {
    // set form id
    $('form').data('inspection-id', this.id)

    this.updateComments();
    this.updateEditedBy();
    this.updateCheckboxes();

    // change "save" button to "update"
    $(':submit').val("Update Periodic Inspection");
    
    // alert bar = "success!" or lists errors
    this.alertPartial()
  }
  
  updateComments(){
    $('#comments-div').empty();
    this.comments.forEach(function(comment){
      $('#comments-div').append(`<strong>${comment.user.fullname}: </strong>${comment.content}<br>`)
    })
    $('#comments-div').append(document.createElement('textarea'))
  }

  alertPartial(){
    $('#alert-ul').remove();
    $('form').prepend(this.alert);
  }

  updateEditedBy(){
    $('#updated-by').remove();
    let users = this.users.reduce((html, user)=>{
      if (!html.includes(user.fullname))
      return html += user.fullname + '<br>'
    }, "");

    $(':submit').before(`<div id="updated-by"><h5>Updated by:</h5>${users}</div>`);
  }

  updateCheckboxes(){
    $('#periodic_inspection_equipment_complete').prop('checked', this.equipment_complete);
    $('#periodic_inspection_element_complete').prop('checked', this.element_complete);
    $('#periodic_inspection_environment_complete').prop('checked', this.environment_complete);
  }
}

$(function(){
  //get the element ID from the form's action attribute
  elementId = $('form')[0].action.split('elements/').pop().split("/periodic").shift()
  periodicService = new ClimbOnService(elementId, "periodic")
   
  $(':submit').click(function(e){
    e.preventDefault();
    saveInspection();
  });
  $("textarea").keypress(function(e) {
    if(e.which == 13) {
      event.preventDefault();
      saveInspection();
    }
  });
  $("#periodic_inspection_date").change(function(e){
    loadInspection(e.target.value);
  })
});
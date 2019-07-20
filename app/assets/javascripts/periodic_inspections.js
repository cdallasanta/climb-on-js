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

  let inspectionId = $('form').data("inspection-id")

  if (inspectionId === undefined) {
    // POST to db, TODO: move this to a service object
    periodicService.post(data)
  } else {
    // PATCH to db, TODO: move this to a service object
    periodicService.patch(data, inspectionId)
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
});
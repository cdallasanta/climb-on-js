let elementId;
let periodicService;

let saveInspection = () => {
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

  //if inspectionId is undefined or an empty string, it's a new inspection. Otherwise, we're updating an old one
  let inspectionId = $('form').data("inspection-id")
  if (inspectionId === "" || inspectionId === undefined) {
    periodicService.post(data)
  } else {
    periodicService.patch(data, inspectionId)
  }
}

let loadInspection = (date) => {
  periodicService.get(date);
}

$(() => {
  //get the element ID from the form's action attribute
  elementId = $('form')[0].action.split('elements/').pop().split("/periodic").shift()
  periodicService = new ClimbOnService(elementId, "periodic")
   
  $(':submit').click((e) => {
    e.preventDefault();
    saveInspection();
  });
  $("textarea").keypress((e) =>  {
    if(e.which == 13) {
      event.preventDefault();
      saveInspection();
    }
  });
  $("#periodic_inspection_date").change((e) => {
    loadInspection(e.target.value);
  })
});
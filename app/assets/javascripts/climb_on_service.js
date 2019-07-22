class ClimbOnService{
  constructor(elementId, inspectionType) {
    this.elementId = elementId;
    this.inspectionType = inspectionType + "_inspection";
    this.baseURL = `/elements/${this.elementId}/${this.inspectionType}s`
  }

  get(date){
    $.get(this.baseURL + `/${date}`)
      .done((resp) => {
        var periodicInspection = new PeriodicInspection(resp);
        periodicInspection.updatePage();
      })
      .fail(() => {
        $('#alert-ul').remove();
        $(':checkbox').prop('checked', false);
        $('#previous-comments').empty();
        $('textarea').val("");
        $('#updated-by').remove();
        $('form').data("inspection-id", "")
      })
  }

  post(data){
    $.post(this.baseURL, data)
    .done((resp) => {
      var periodicInspection = new PeriodicInspection(resp);
      periodicInspection.updatePage();
    })
    .fail((resp) => {
      var periodicInspection = new PeriodicInspection(resp);
      periodicInspection.alertPartial();
    })
  }

  patch(data, inspId){
    $.ajax({
      type: 'PATCH',
      url: this.baseURL + `/${inspId}`,
      data: data,
      success: function(resp){
        var periodicInspection = new PeriodicInspection(resp);
        periodicInspection.updatePage();
      },
      failure: function(resp){
        var periodicInspection = new PeriodicInspection(resp);
        periodicInspection.alertPartial();
      }
    })
  }
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
    $('#previous-comments').empty();
    this.comments.forEach(function(comment){
      $('#previous-comments').append(`<strong>${comment.user.fullname}: </strong>${comment.content}<br>`)
    })
    $('textarea').val("");
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
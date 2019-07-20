class ClimbOnService{
  constructor(elementId, inspectionType) {
    this.elementId = elementId;
    this.inspectionType = inspectionType + "_inspection";
    this.baseURL = `/elements/${this.elementId}/${this.inspectionType}s`
  }

  get(inspId){
    $.get(this.baseURL + `/${inspId}`)

  }

  post(data){
    $.post(this.baseURL, data)
    .done((resp) => {
      // set form id
      $('form').data('inspection-id', resp.id)

      ClimbOnService.updateComments(resp.comments);
      
      // TODO: update edited by

      // change "save" button to "update"
      $(':submit').val("Update Periodic Inspection");
      
      // alert bar = "success!"
      ClimbOnService.alertPartial(resp["alert"])
    })
    .fail((resp) => {
      ClimbOnService.alertPartial(resp["responseText"])
    })
  }

  patch(data, inspId){
    $.ajax({
      type: 'PATCH',
      url: this.baseURL + `/${inspId}`,
      data: data,
      success: function(resp){
        ClimbOnService.updateComments(resp.comments);

        // TODO: update edited by
        
        // alert bar = "success!"
        ClimbOnService.alertPartial(resp["alert"])
      },
      failure: function(resp){
        ClimbOnService.alertPartial(resp["responseText"])
      }
    })
  }

  static updateComments(comments){
    $('#comments-previous').empty();
    comments.forEach(function(comment){
      $('#comments-previous').append(`<strong>${comment.user.fullname}: </strong>${comment.content}<br>`)
    })
    $('textarea').val("");
  }

  static alertPartial(html){
    $('#alert-ul').remove();
    $('form').prepend(html)
  }
}


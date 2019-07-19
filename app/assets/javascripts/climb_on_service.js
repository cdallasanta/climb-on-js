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
      debugger;
      $('form').data('inspection-id', resp.id)

      this.updateComments(resp.comments);
      
      // TODO: update edited by

      // change "save" button to "update"
      $(':submit').val("Update Periodic Inspection");
    })
    .fail((resp) => {
      this.alertPartial(resp["responseText"])
    })
  }

  patch(data, inspId){
    $.ajax({
      type: 'PATCH',
      url: this.baseURL + `/${inspId}`,
      data: data,
      success: function(resp){
        this.updateComments(resp.comments);

      // TODO: update edited by
      },
      failure: function(resp){
        this.alertPartial(resp["responseText"])
      }
    })
  }

  updateComments(comments){
    $('#comments-previous').empty();
    comments.forEach(function(comment){
      // TODO can be a prototype method
      $('#comments-previous').append(`<strong>${comment.user.fullname}: </strong>${comment.content}<br>`)
    })
    $('textarea').val("");
  }

  alertPartial(html){
    $('#alert-ul').remove();
    $('form').prepend(html)
  }
}


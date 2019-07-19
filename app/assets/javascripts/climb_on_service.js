class ClimbOnService{
  constructor(elementId, inspectionType) {
    this.elementId = elementId;
    this.inspectionType = inspectionType + "_inspection";
    this.baseURL = `/elements/${this.elementId}/${inspectionType}s`
  }

  get(id){
    $.get(this.baseURL + `/${id}`)
      .done((resp) => {
        debugger;
        // set form id
        $('form').data('inspection-id', resp.id)

        // update comments
        $('#comments-previous').empty();
        resp.comments.forEach(function(comment){
          // TODO can be a prototype method
          $('#comments-previous').append(`<strong>${comment.user.fullname}: </strong>${comment.content}<br>`)
        })
        $('textarea').val("");
        
        // TODO: update edited by

        // change "save" button to "update"
        $(':submit').val("Update Periodic Inspection");
      })
      .fail((resp) => {

        debugger;
        // TODO, put all this in some other function. It's too much
        let alertDiv = document.createElement('div');
        let alertUl = document.createElement('ul');
        alertDiv.id = "alert-div";
        alertDiv.classList.add("alert", "alert-danger")
        alertUl.id = "alert-ul";
        resp["responseJSON"]["error"].forEach(function(error){
          let li = document.createElement('li');
          li.append(error);
          alertUl.appendChild(li);
        });
        alertDiv.appendChild(alertUl);
        $('form').prepend(alertDiv);
      })
  }

  post(data){
    $.post(this.baseURL, data)
      .done((resp) => {

        debugger;
      })
      .fail((resp) => {

        debugger;
      })
  }
}


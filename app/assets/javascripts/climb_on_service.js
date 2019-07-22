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
        $('#comments-div').empty();
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
$(document).on("turbolinks:load", function() {
  $('ul.tabs li').click(function(e) {
    e.preventDefault()

    var tab_id = $(this).attr('data-tab')

    $('ul.tabs li a').removeClass('tab-active')
    $('.tab-content').removeClass('current')

    $('a', this).addClass('tab-active')
    $("#" + tab_id).addClass('current')
  })

  $( "#assignee_input" ).autocomplete({
     source: $('#assignee_input').data('autocomplete-source')
  })

  $('.datetimepicker').datetimepicker();

  $(".tab-link").on("click", function(){
    localStorage.setItem("tab", $(this).data('tab'));
  });

  // Set open tab
  $(".tab-link[data-tab='" + localStorage.getItem("tab") + "']").click();
});

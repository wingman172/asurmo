# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $("#phone").mask("(999) 99-999-999")
  $("#datepicker").datepicker()
  $("time.timeago").timeago()

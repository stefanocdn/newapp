# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('.scholarship_degree').autocomplete( source: ['Master', 'PHD', 'Bachelor'])

  $('.scholarship_field').autocomplete( source: ["Engineering", "Electronics", "Elements", "Excell", "Litterature", "Architecture"])
jQuery ->
  $('#scholarship_school_name').autocomplete( source: $('#scholarship_school_name').data('autocomplete-source'))

  $('#scholarship_degree').autocomplete( source: ['Master', 'PHD', 'Bachelor'])

  $('#scholarship_field').autocomplete( source: ["Engineering", "Electronics", "Elements", "Excell", "Litterature", "Architecture"])

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    $(this).before($(this).data('fields'))
    event.preventDefault()

  $('.scholarship_school_name').autocomplete( source: $('.scholarship_school_name').data('autocomplete-source'))

  $('#profile').on('click', 'button', ->
    $(this).closest('#profile').find('.add_education').slideToggle())
jQuery ->
  $('#scholarship_school_name').autocomplete( source: $('#scholarship_school_name').data('autocomplete-source'))

  $('#scholarship_degree').autocomplete( source: ['Master', 'PHD', 'Bachelor'])

  $('#scholarship_field').autocomplete( source: ["Engineering", "Litterature", "Architecture"])
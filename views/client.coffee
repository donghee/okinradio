$ ->
  $.ajax
    type: 'GET'
    url: '/list'
    success: (page) ->
      console.log('test')
      #$(page).insertBefore('#radio-ustream-list')

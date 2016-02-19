Spree.fetch_account = ->
  $.ajax
    url: Spree.pathFor("account_link"),
    success: (data) ->
      $(data).insertBefore("li#search-bar")

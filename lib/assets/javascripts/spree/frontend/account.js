Spree.fetch_account = function() {
  return $.ajax({
    url: Spree.pathFor("account_link"),
    success: function(data) {
      return $(data).insertBefore("li#search-bar");
    }
  });
};

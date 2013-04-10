app.filter("js_link", function() {
  return function(input) {
    if (_.isUndefined(input) || _.isNull(input)) return "";
    
    return input.replace(new RegExp('\\[([^\\]]+)\\]\\(([^\\)]+)\\)', 'mg'), '<a data-remote="true" href="$2">$1</a>')
  };
});

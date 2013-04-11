app.filter("js_link", function() {
  return function(input) {
    if (_.isUndefined(input) || _.isNull(input)) return "";
    
    return input.replace(new RegExp('\\[([^\\]]+)\\]\\(([^\\)]+)\\)', 'mg'), '<a onClick="$.ajax({url: \'$2\'})" href="#">$1</a>')
  };
});

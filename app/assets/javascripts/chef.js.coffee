window.close_dialog = (selector, content) ->
  $("#" + selector).modal 'hide'
  $("#" + selector).remove()

window.build_dialog = (selector, content) ->
  # Close it and remove content if it's already open
  close_dialog selector
  # Add new content and pops it up
  $("body").append "<div id=\"" + selector + "\" class=\"modal fade\" role=\"dialog\">\n" + content + "</div>"
  $("#" + selector).modal()

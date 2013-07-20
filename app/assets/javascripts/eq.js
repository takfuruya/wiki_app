
this.EQ = this.EQ || {};

EQ.saveNoteContent = function(id, content, successListener, failListener)
{
  EQ.saveNote(id, {content: content}, successListener, failListener);
}

EQ.saveNoteName = function(id, name, successListener, failListener)
{
  EQ.saveNote(id, {name: name}, successListener, failListener);
}

EQ.saveNote = function(id, data, successListener, failListener)
{
  var settings = {
    url: '/notes/'+id,
    type: 'PUT',
    dataType: 'html',
    contentType: 'application/json; charset=UTF-8',
    data: JSON.stringify(data)
  };
  var jqXHR = $.ajax(settings);

  jqXHR.done(successListener);
  jqXHR.fail(failListener);
}
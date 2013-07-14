window.addEventListener('load', windowLoadListener)

function windowLoadListener(event)
{
  var editorTextArea = document.getElementById('editor');

  editorTextArea.addEventListener('input', editorInputListener);
}

function editorInputListener(event)
{
  var content = event.currentTarget.value;
  console.log(content);

$.ajax({
    url: '/notes/64',
    type: 'PUT',
    dataType: 'html',
    contentType: 'application/json; charset=UTF-8',
    data: JSON.stringify({ content: content })
}).done(function( msg )
        {
            document.getElementById('display').innerHTML = msg;
        })
.fail(function(jqXHR, textStatus, errorThrown) {console.log(errorThrown)});
}


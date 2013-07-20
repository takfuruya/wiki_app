
this.EQ = this.EQ || {};

$(function(event)
{
  var path = window.location.pathname.split("/");
  EQ.id = path[2];

  EQ.editor = ace.edit("editor");
  EQ.editor.setTheme("ace/theme/monokai");
  EQ.editor.getSession().setMode("ace/mode/markdown");
  EQ.editor.renderer.setShowGutter(false);
  EQ.editor.getSession().setUseWrapMode(true);
  EQ.editor.getSession().on("change", EQ.editorChangeListener);
});

EQ.editorChangeListener = function(event)
{
  // Better to have timer to prevent saving with every single input
  var content = EQ.editor.getValue();
  EQ.saveNoteContent(EQ.id, content, EQ.saveContentSuccessListener, EQ.saveContentFailListener);
};

EQ.saveContentSuccessListener = function(data, textStatus, jqXHR)
{
  $("#display").html(data);
};

EQ.saveContentFailListener = function(jqXHR, textStatus, errorThrown)
{
  console.log(errorThrown);
};

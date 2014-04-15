//= require jquery
//= require jquery_ujs
//= require eq

this.EQ = this.EQ || {};

$(function(event)
{
  $("#edit_link").click(EQ.editProfileClickListener);
  $(".item_rename button").click(EQ.renameClickListener);
});

EQ.editProfileClickListener = function(event)
{
  event.preventDefault();
  $("#user_edit_form").css("display", "block");
};

EQ.renameClickListener = function(event)
{
  var renameButton = $(this);
  var item = renameButton.closest('tr').children('.item_name');
  var aTag = item.children('a');
  var inputTag = item.children('input');

  this.innerHTML = "OK";
  renameButton.unbind();
  inputTag.val(aTag.text());
  inputTag.blur(EQ.inputBlurListener);
  inputTag.keyup(EQ.inputKeyUpListener);

  aTag.css('display', 'none');
  inputTag.css('display', 'block');
  inputTag.focus();
};

EQ.inputBlurListener = function(event)
{
  EQ.doneRenaming(this);
};

EQ.inputKeyUpListener = function(event)
{
  var ENTER = 13;
  if (event.keyCode == ENTER)
  {
    EQ.doneRenaming(this);
  }
};

EQ.doneRenaming = function(inputTag)
{
  var inputTag = $(inputTag);
  var aTag = inputTag.siblings("a");
  var row = inputTag.parents("tr");
  var renameButton = row.find(".item_rename button");
  var newName = inputTag.val();
  var oldName = aTag.html();

  if (oldName != newName)
  {
    noteId = row.attr('id').substring(4);
    EQ.saveNoteName(noteId, newName,
      EQ.saveNoteNameSuccessListener,
      EQ.saveNoteNameFailListener);
  }

  inputTag.unbind();
  renameButton.html("SAVING...");
  setTimeout(function() {
    renameButton.html("NAME");
    renameButton.click(EQ.renameClickListener);
  },1000);
  
  aTag.text(newName);
  inputTag.css('display', 'none');
  aTag.css('display', 'block');
};

EQ.saveNoteNameSuccessListener = function(data, textStatus, jqXHR)
{
  console.log("Note name save success");
};

EQ.saveNoteNameFailListener = function(jqXHR, textStatus, errorThrown)
{
  console.log(errorThrown);
};

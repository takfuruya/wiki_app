//= require jquery
//= require jquery_ujs

$(function(event)
{
  var emailTextInput = $("#email");
  var checkbox = $("#sign_up_");
  var errorDivs = [$("#email_error"), $("#password_error"), $("#confirmation_error")];

  emailTextInput.focus();
  emailTextInput.select();

  for (var i = 0; i < errorDivs.length; i++)
  {
    if (!errorDivs[i].children().eq(1).is(":empty"))
    {
      errorDivs[i].css("visibility", "visible");
    }
  }

  refreshConfirmationDisplay();
  checkbox.change(checkboxChangeListener);
});


function checkboxChangeListener(event)
{
  refreshConfirmationDisplay();
}

function refreshConfirmationDisplay()
{
  var confirmationTextInput = $('#password_confirmation');
  var confirmationErrorDiv = $('#confirmation_error');
  var isChecked = $("#new_user").children().eq(0).prop("checked");

  if (isChecked)
  {
    confirmationTextInput.css("display", "block");
    confirmationErrorDiv.css("display", "table");
  }
  else
  {
    confirmationTextInput.css("display", "none");
    confirmationErrorDiv.css("display", "none");
  }
}
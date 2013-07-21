//= require jquery
//= require jquery_ujs

window.addEventListener('load', windowLoadListener)

function windowLoadListener(event) {
  var emailTextInput = document.getElementById('email');
  var checkbox = document.getElementById('sign_up_');

  emailTextInput.focus();
  emailTextInput.select();

  checkbox.addEventListener('change', checkboxChangeListener);
}

function checkboxChangeListener(event)
{
  var pwConfTextInput = document.getElementById('password_confirmation');
  var isChecked = event.currentTarget.checked;

  if (isChecked)
  {
    pwConfTextInput.style.display = "block";
  }
  else
  {
    pwConfTextInput.style.display = "none";
  }
}
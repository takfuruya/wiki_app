window.addEventListener('load', windowLoadListener)

function windowLoadListener(event) {
  var editLink = document.getElementById('edit_link');
  editLink.addEventListener('click', editLinkClickListener);
}

function editLinkClickListener(event)
{
  var editForm = document.getElementById('user_edit_form');

  event.preventDefault();
  editForm.style.display = "block";
}
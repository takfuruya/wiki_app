function windowLoadListener(a){var b=document.getElementById("editor");b.addEventListener("input",editorInputListener)}function editorInputListener(a){var b=a.currentTarget.value;console.log(b),$.ajax({url:"/notes/64",type:"PUT",dataType:"html",contentType:"application/json; charset=UTF-8",data:JSON.stringify({content:b})}).done(function(a){document.getElementById("display").innerHTML=a}).fail(function(a,b,c){console.log(c)})}window.addEventListener("load",windowLoadListener);
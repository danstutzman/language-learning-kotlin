function clickedIRemember() {
  var form = document.forms[0]
  if (form['first_responded_at'].value == '') {
    form['first_responded_at'].value = new Date().getTime()
  }
  form['action'].value = 'i_remember'
  form.submit()
}

function clickedIForget() {
  var form = document.forms[0]
  if (form['first_responded_at'].value == '') {
    form['first_responded_at'].value = new Date().getTime()
  }
  form['action'].value = 'i_forget'
  form.submit()
}

document.addEventListener('keypress', function(event) {
  if (event.keyCode === 82 || event.keyCode === 114) { // R
    clickedIRemember()
  } else if (event.keyCode === 70 || event.keyCode === 102) { // F
    clickedIForget()
  }
})

for (const element of document.getElementsByClassName('i-remember')) {
  element.addEventListener('click', clickedIRemember)
}
for (const element of document.getElementsByClassName('i-forget')) {
  element.addEventListener('click', clickedIForget)
}

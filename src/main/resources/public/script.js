function clickedIRemember() {
  document.forms[0]['action'].value = 'i-remember'
  document.forms[0].submit()
}

function clickedIForget() {
  document.forms[0]['action'].value = 'i-forget'
  document.forms[0].submit()
}

document.addEventListener('keypress', function(event) {
  if (event.keyCode === 82 || event.keyCode === 114) { // R
    clickedIRemember()
  } else if (event.keyCode === 70 || event.keyCode === 102) { // F
    clickedIForget()
  }
})

var timeout1, timeout2, timeout3
function clearTimeouts() {
  window.clearTimeout(timeout1)
  window.clearTimeout(timeout2)
  window.clearTimeout(timeout3)
}

function clickedIRemember() {
  clearTimeouts()

  var form = document.forms[0]
  if (form['first_responded_at'].value == '') {
    form['first_responded_at'].value = new Date().getTime()
  }
  form['action'].value = 'i_remember'
  form.submit()
}

function clickedIForget() {
  clearTimeouts()

  var form = document.forms[0]
  if (form['first_responded_at'].value == '') {
    form['first_responded_at'].value = new Date().getTime()
  }
  form['action'].value = 'i_forget'
  form.submit()
}

function clickedOkay() {
  clearTimeouts()

  var form = document.forms[0]
  if (form['first_responded_at'].value == '') {
    form['first_responded_at'].value = new Date().getTime()
  }
  form['action'].value = 'okay'
  form.submit()
}

function onLoad() {
  document.addEventListener('keypress', function(event) {
    if (event.keyCode === 82 || event.keyCode === 114) { // R
      clickedIRemember()
    } else if (event.keyCode === 70 || event.keyCode === 102) { // F
      clickedIForget()
    } else if (event.keyCode === 79 || event.keyCode === 111) { // O
      clickedOkay()
    }
  })

  console.log(document.getElementsByClassName('timer-3s-left').length)
  if (document.getElementsByClassName('timer-3s-left').length > 0) {
    timeout1 = window.setTimeout(function() {
      for (const element of document.getElementsByClassName('timer-3s-left')) {
        element.style.visibility = 'hidden';
      }
    }, 1000)
    timeout2 = window.setTimeout(function() {
      for (const element of document.getElementsByClassName('timer-2s-left')) {
        element.style.visibility = 'hidden';
      }
    }, 2000)
    timeout3 = window.setTimeout(function() {
      for (const element of document.getElementsByClassName('timer-1s-left')) {
        element.style.visibility = 'hidden';
      }
      clickedIForget()
    }, 3000)
  }

  for (const element of document.getElementsByClassName('i-remember')) {
    element.addEventListener('click', clickedIRemember)
  }
  for (const element of document.getElementsByClassName('i-forget')) {
    element.addEventListener('click', clickedIForget)
  }
  for (const element of document.getElementsByClassName('okay')) {
    element.addEventListener('click', clickedOkay)
  }
}

document.addEventListener('DOMContentLoaded', onLoad)

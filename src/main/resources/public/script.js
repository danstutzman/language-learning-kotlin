const BUCKWALTER_TO_ARABIC = {
  A: '\u0627',
  D: '\u0636',
  E: '\u0639',
  F: '\u064b',
  H: '\u062d',
  K: '\u064d',
  N: '\u064c',
  S: '\u0635',
  T: '\u0637',
  Y: '\u0649',
  Z: '\u0638',
  a: '\u064e',
  b: '\u0628',
  d: '\u062f',
  f: '\u0641',
  g: '\u063a',
  h: '\u0647',
  i: '\u0650',
  j: '\u062c',
  k: '\u0643',
  l: '\u0644',
  m: '\u0645',
  n: '\u0646',
  o: '\u0652',
  p: '\u0629',
  q: '\u0642',
  r: '\u0631',
  s: '\u0633',
  t: '\u062a',
  u: '\u064f',
  v: '\u062b',
  w: '\u0648',
  x: '\u062e',
  y: '\u064a',
  z: '\u0632',
  '$': '\u0634',
  '*': '\u0630',
  "'": '\u0621',
  '>': '\u0623',
  '<': '\u0625',
  '_': '\u0640',
  '&': '\u0624',
  '}': '\u0626',
  '~': '\u0651',
  '|': '\u0622',
  '{': '\u0671',
  '`': '\u0670',
  '0': '\u06f0',
  '1': '\u06f1',
  '2': '\u06f2',
  '3': '\u06f3',
  '4': '\u06f4',
  '5': '\u06f5',
  '6': '\u06f6',
  '7': '\u06f7',
  '8': '\u06f8',
  '9': '\u06f9',
  ' ': ' ',
};

const BUCKWALTER_TO_MIDDLES = {
  A: '\ufe8e',
  D: '\ufec0',
  E: '\ufecc',
  F: '\u064b',
  H: '\ufea4',
  K: '\u064d',
  N: '\u064c',
  S: '\ufebc',
  T: '\ufec4',
  Y: '\ufef0',
  Z: '\ufec8',
  a: '\u064e',
  b: '\ufe92',
  d: '\ufeaa',
  f: '\ufed4',
  g: '\ufec8',
  h: '\ufeec',
  i: '\u0650',
  j: '\ufea0',
  k: '\ufedc',
  l: '\ufee0',
  m: '\ufee4',
  n: '\ufee8',
  o: '\u0652',
  p: '\u0629',
  q: '\ufed8',
  r: '\ufeae',
  s: '\ufeb4',
  t: '\ufe98',
  u: '\u064f',
  v: '\ufe9c',
  w: '\ufeee',
  x: '\ufea8',
  y: '\ufef4',
  z: '\ufeb0',
  '$': '\ufeb8',
  '*': '\ufeaa',
  "'": '\u0621',
  '>': '\u0623',
  '<': '\u0625',
  '_': '\u0640',
  '&': '\u0624',
  '}': '\u0626',
  '~': '\u0651',
  '|': '\u0622',
  '{': '\ufb51',
  '`': '\u0670',
  '0': '\u06f0',
  '1': '\u06f1',
  '2': '\u06f2',
  '3': '\u06f3',
  '4': '\u06f4',
  '5': '\u06f5',
  '6': '\u06f6',
  '7': '\u06f7',
  '8': '\u06f8',
  '9': '\u06f9',
  ' ': ' ',
};

const BUCKWALTER_TO_QALAM = {
  A: 'a', //?
  D: 'D',
  E: '`',
  F: 'aN', //?
  H: 'H',
  K: 'iN', //?
  N: 'uN', //?
  S: 'S',
  T: 'T',
  Y: 'ae',
  Z: 'Z',
  a: 'a',
  b: 'b',
  d: 'd',
  f: 'f',
  g: 'gh',
  h: 'h',
  k: 'k',
  i: 'i',
  j: 'j',
  l: 'l',
  m: 'm',
  n: 'n',
  o: '',
  p: '', // ta marbuta is not usually pronounced
  q: 'q',
  r: 'r',
  s: 's',
  t: 't',
  u: 'u',
  v: 'th',
  w: 'w',
  x: 'kh',
  y: 'y',
  z: 'z',
  '*': 'dh',
  '$': 'sh',
  "'": "'",
  '>': "'a", //?
  '<': "'i", //?
  '&': "w'", //?
  '}': "y'", //?
  '|': '~aa', //?
  '{': 'a', // alif al-wasla indicates word is connected to previous word
  '`': 'a', //?
  ' ': ' ',
};

const ARABIC_TO_BUCKWALTER = {};
for (const key in BUCKWALTER_TO_ARABIC) {
  ARABIC_TO_BUCKWALTER[BUCKWALTER_TO_ARABIC[key]] = key;
}

function convertBuckwalterToArabic(buckwalter) {
  return buckwalter
    .trim()
    .split('')
    .map(function (c) { return BUCKWALTER_TO_ARABIC[c] })
    .join('');
}

function convertArabicToBuckwalter(arabic) {
  return arabic
    .trim()
    .split('')
    .map(function (c) { return ARABIC_TO_BUCKWALTER[c] })
    .join('');
}

function convertBuckwalterToMiddles(buckwalter) {
  return buckwalter
    .trim()
    .split('')
    .map(function (c) { return BUCKWALTER_TO_MIDDLES[c] })
    .join('')
    .replace(/\ufee0\ufe8e/, '\ufee0\ufeff\ufe8e'); // split up l+a ligature
}

function convertBuckwalterToQalam(buckwalter) {
  return buckwalter
    .trim()
    .split('')
    .map(function (c) { return BUCKWALTER_TO_QALAM[c] })
    .join('');
}

function convertQalamToBuckwalter(qalam) {
  try {
    return module.exports.parse(qalam);
  } catch (e) {
    return '';
  }
}

function onLoad() {
  for (const element of document.getElementsByClassName('ar-qalam')) {
    const rowId = element.getAttribute('data-row-id');
    if (rowId === null) continue;

    const qalam = element.value;
    if (document.getElementById(`ar-buckwalter-${rowId}`) != null) {
      document.getElementById(`ar-buckwalter-${rowId}`).innerHTML =
        convertQalamToBuckwalter(qalam);
    }

    element.addEventListener('input', function (e) {
      const qalam = e.target.value;
      if (document.getElementById(`ar-buckwalter-${rowId}`) != null) {
        document.getElementById(`ar-buckwalter-${rowId}`).innerHTML =
          convertQalamToBuckwalter(qalam);
      }
    })
  }

  for (const element of document.getElementsByClassName('ar-buckwalter')) {
    const rowId = element.getAttribute('data-row-id');
    if (rowId === null) continue;

    const buckwalter = element.innerText;
    if (document.getElementById(`ar-qalam-${rowId}`) != null) {
      document.getElementById(`ar-qalam-${rowId}`).innerHTML =
        convertBuckwalterToQalam(buckwalter);
    }
    document.getElementById(`ar-monospace-${rowId}`).innerHTML =
      convertBuckwalterToArabic(buckwalter);
    if (document.getElementById(`ar-middles-${rowId}`) !== null) {
      document.getElementById(`ar-middles-${rowId}`).innerHTML =
        convertBuckwalterToMiddles(buckwalter);
    }

    element.addEventListener('input', function (e) {
      const buckwalter = e.target.value;
      if (document.getElementById(`ar-qalam-${rowId}`) != null) {
        document.getElementById(`ar-qalam-${rowId}`).value =
          convertBuckwalterToQalam(buckwalter);
      }
      document.getElementById(`ar-monospace-${rowId}`).value =
        convertBuckwalterToArabic(buckwalter);
      if (document.getElementById(`ar-middles-${rowId}`) !== null) {
        document.getElementById(`ar-middles-${rowId}`).value =
          convertBuckwalterToMiddles(buckwalter);
      }
    })
  }

  const arMonospaceNew = document.getElementById('ar-monospace-new');
  if (arMonospaceNew !== null) {
    arMonospaceNew.addEventListener('input', function (e) {
      const buckwalter = convertArabicToBuckwalter(e.target.value);
      document.getElementById('ar-buckwalter-new').value = buckwalter;
      if (document.getElementById('ar-qalam-new') != null) {
        document.getElementById('ar-qalam-new').value =
          convertBuckwalterToQalam(buckwalter);
      }
      arMonospaceNew.value = convertBuckwalterToArabic(buckwalter);
      document.getElementById('ar-middles-new').value =
        convertBuckwalterToMiddles(buckwalter);
    });
  }
}

document.addEventListener('DOMContentLoaded', onLoad);

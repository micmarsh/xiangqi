
function assertColor(color) {
  if (color !== 'red' && color !== 'black')
    throw Error(color + ' is not a valid color');
}

exports.assertColor = assertColor

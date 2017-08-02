exports.index = function(event, context, callback) {
  if (isBusinessTime(new Date())) {
    callback(null, {
      statusCode: '200',
      body: JSON.stringify({ message: "It's time for business" }),
      headers: { 'Content-Type': 'application/json' }
    })
  } else {
    callback(null, {
      statusCode: '200',
      body: JSON.stringify({ message: "It's party time" }),
      headers: { 'Content-Type': 'application/json' }
    })
  }
}

function isBusinessTime(now) {
  return now.getDay() <= 4 && now.getHours() >= 9 && now.getHours() < 17
}

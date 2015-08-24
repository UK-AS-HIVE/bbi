@TrafficLog = new Mongo.Collection 'trafficLog'

Router.route '/remote', where: 'server'
  .post ->
    console.log 'received remote event', @request.body
    json = if typeof @request.body == 'string' then JSON.parse(@request.body) else @request.body
    try
      TrafficLog.insert _.extend json, received: Date.now()
    finally
      @response.end 'received'

Router.route '/',
  template: 'trafficLog'

if Meteor.isClient
  Template.trafficLog.helpers
    stringify: (o) ->
      JSON.stringify o
    trafficLog: ->
      TrafficLog.find({}, {sort: {timestamp: -1}})


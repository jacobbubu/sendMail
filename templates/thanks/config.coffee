fs = require 'fs'
jade = require 'jade'

content = require './content'

fn = jade.compile fs.readFileSync(__dirname + '/index.jade', {encoding: 'utf8'}), {pretty: true}

plainContent = fs.readFileSync __dirname + '/plainContent.txt', { encoding: 'utf8' }
plainContent = plainContent.replace '#{start}', content.start
plainContent = plainContent.replace '#{content}', content.body
plainContent = plainContent.replace '#{regards}', content.regards

getHTML = (options) ->
  content.start = content.start.replace '#{contributor}', options.contributor
  content.start = content.start.replace '#{numberOfPhotos}', options.numberOfPhotos

  content.body = content.body.replace '#{contributor}', options.contributor
  content.body = content.body.replace '#{numberOfPhotos}', options.numberOfPhotos

  content.regards = content.regards.replace '#{contributor}', options.contributor
  content.regards = content.regards.replace '#{numberOfPhotos}', options.numberOfPhotos

  html = fn { start: content.start, content: content.body, regards: content.regards }
  #fs.writeFileSync __dirname + '/index.html', html
  return html

getPlainText = (options) -> 
  plainContent = plainContent.replace '#{contributor}', options.contributor
  plainContent = plainContent.replace '#{numberOfPhotos}', options.numberOfPhotos

module.exports = 
  getHTML: getHTML
  getPlainText: getPlainText
  from: content.from
  subject: content.subject
  forceEmbeddedImages: true

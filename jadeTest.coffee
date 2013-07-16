jade = require 'jade'
fs = require 'fs'
fn = jade.compile fs.readFileSync(__dirname + '/templates/thanks/index.jade', {encoding: 'utf8'}), {pretty: true}

locals = 
  Contributor: '大沙发'
  NoOfPhotos: 4
  Content: '收到你的照片#{NoOfPhotos}张，它们已经进入nextday图片库，可能会出现在某一天，也可能不出现。谢谢你的分享，nextday是一点小阳光，一场小游戏，很高兴你与我们一起玩耍！'
  Regards: '牛奶君送上夏安。'

content = fn(locals)
fs.writeFileSync __dirname + '/templates/thanks/index.html', content
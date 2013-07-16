#!/usr/bin/env coffee

fs = require 'fs'
nodemailer = require 'nodemailer'
colors = require 'colors'
prompt = require 'prompt'
wrap = require('wordwrap')(2, 40, {mode: 'hard'})

thanks = require './templates/thanks/config'

schema =
  properties:
    email:
      description: 'Gmail account'
      default: 'judy.shi@nxmix.com'
      required: true
    password:
      required: true
      hidden: true
      description: 'Password'
      message: 'Password MUST be provided'
    contributor:
      description: "Contributor's name"      
      required: true
    numberOfPhotos:
      description: "Number of Photos"
      default: 1
      required: true
    sendTo:
      description: 'Send to: "User Name" <a@b.c>'
      message: 'MUST have email address'
      required: true

confirmSchema = 
  properties:
    confirm:
      description: 'ARE U SURE U WANT TO SEND IT? (y/n)'
      default: 'y'
      required: true

startOver = ->
  prompt.message= '🍼'

  prompt.start()

  prompt.get schema, (err, res) ->
  	if err?
  		console.error 'Error:'.red.inverse, err
  	else
  		if res.email.indexOf('@') < 0
  			res.email = res.email + '@gmail.com'

  		smtpTransport = nodemailer.createTransport 'SMTP',
  		  service: 'Gmail'
  		  auth:
  		     user: res.email
  		     pass: res.password

  		opt = 
        contributor: res.contributor
        numberOfPhotos: res.numberOfPhotos

      schema.properties.email.default = res.email
      schema.properties.contributor.default = res.contributor
      schema.properties.numberOfPhotos.default = res.numberOfPhotos
      schema.properties.sendTo.default = res.sendTo

      mailOptions =
  		  from: thanks.from
  		  to: res.sendTo
  		  subject: thanks.subject
  		  html: thanks.getHTML opt
  		  text: thanks.getPlainText opt
  		  forceEmbeddedImages: thanks.forceEmbeddedImages

      console.log ''
      console.log 'This mail will be send to', "[#{mailOptions.to.split(',').join(' -|- ')}]".cyan, 'with the content:'
      console.log ''
      console.log wrap(mailOptions.text).italic.yellow
      console.log ''

      prompt.message= '💣'
      prompt.start()

      prompt.get confirmSchema, (err, confirmed) ->
        if err?
          console.error 'Error:'.red.inverse, err
        else
          confirm = confirmed.confirm.toLowerCase()

          if confirm in ['y', 'yes']
            console.log 'Contacting to Gmail...'
            smtpTransport.sendMail mailOptions, (err, response) ->
              if err?
                console.error 'Error:'.red.inverse, err
                startOver()
              else
                console.log 'Done:'.green, response.message
                process.exit()
              return
          else
            console.log "Let's start over again..."
            startOver()

startOver()
---
layout: 'default'
title: 'Async Operations'
---

div '.app', ->
  section '.main', ->

aside '.async-container', ->
  div '.controls', ->
    button '.js-start', name: 'button', -> 'Start'
  div '.stats', ->
    p 'Requests'
    ul ->
      li "Total: #{cede -> span '.js-total', '0'}"
      li "User online: #{cede -> span '.js-success', '0'}"
      li "User offline: #{cede -> span '.js-failure', '0'}"
  div '.message', ->

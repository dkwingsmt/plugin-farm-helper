Promise = require 'bluebird'
async = Promise.coroutine
request = Promise.promisifyAll require('request')
{relative, join} = require 'path-extra'
path = require 'path-extra'
fs = require 'fs-extra'
{_, $, $$, React, ReactBootstrap, ROOT, resolveTime, layout, toggleModal} = window
{Table, ProgressBar, Grid, Input, Col, Alert} = ReactBootstrap
{APPDATA_PATH, SERVER_HOSTNAME} = window

delayedLog = (msg) ->
  setTimeout (-> window.warn msg), 100

module.exports =
  name: 'farm-helper'
  displayName: <span><FontAwesome key={1} name='heart' />{' 周回大师'}</span>
  description: "帮助你周回时不犯脑残错误哒哟。现在只支持E3上路周回。"
  version: '0.0.1'
  author: 'DKWings'
  link: 'https://github.com/dkwingsmt'
  reactClass: React.createClass

    isBossPoint: ->
      return @now_point == 16

    judgeNextPoint: (body) ->
      @now_point = body.api_no
      switch @now_point
        when 1
          delayedLog "[选→] 能动分歧走上路"
        when 3
          delayedLog "[选↘️] 4号单纵"
        when 5
          delayedLog "[选↙️] 3号轮型"
        when 8
          delayedLog "[选↘️] 4号单纵"
        when 16
          delayedLog "[选↘️] 4号单纵"

    judgeBattle: (body) ->
      console.log body
      console.log @now_point
      if body.api_midnight_flag
        if @isBossPoint()
          delayedLog "[选→] 进入夜战"
        else
          delayedLog "[选←] 不进夜战"

    judgeEndBattle: (body) ->
      if body.api_escape_flag
        delayedLog "[选←] 要退避"
      else
        @judgeEndBattleContinue body

    judgeEndBattleContinue: (body) ->
      if !@isBossPoint()
        delayedLog "[选←] 继续进击！"

    handleResponse: (e) ->
      {method, path, body, postBody} = e.detail
      now_point = 0
      switch path
        when '/kcsapi/api_req_map/start'
          @judgeNextPoint body
        when '/kcsapi/api_req_map/next'
          @judgeNextPoint body
        when '/kcsapi/api_req_combined_battle/airbattle'
          @judgeBattle body
        when '/kcsapi/api_req_combined_battle/battle'
          @judgeBattle body
        when '/kcsapi/api_req_combined_battle/battleresult'
          @judgeEndBattle body
        when '/kcsapi/api_req_combined_battle/goback_port'
          @judgeEndBattleContinue body

    getInitialState: ->
      mapHp: []
      clearedVisible: false

    componentDidMount: ->
      window.addEventListener 'game.response', @handleResponse
    componentWillUnmount: ->
      window.removeEventListener 'game.response', @handleResponse
    render: ->
      <div>
      </div>

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery-ui
//= require jquery-file-upload
//= require bootstrap-sprockets
//= require floatThead
//= require cable
//= require_self
//= require_tree .

this.App = {};
App.cable = Cable.createConsumer('ws://' + window.location.host + '/websocket');

App.messages = App.cable.subscriptions.create('MessagesChannel', {
  received: function(data) {
    //return alert(data.upload.original_filename); //$('#messages').append(this.renderMessage(data));
    $('#files').append("<p><a href='/uploads/" + data.upload.id + "/preview'>" + data.upload.original_filename + "</a></p>");
  },
  //renderMessage: function(data) {
  //  return "<p><b>[" + data.username + "]:</b> " + data.message + "</p>";
  //}
});

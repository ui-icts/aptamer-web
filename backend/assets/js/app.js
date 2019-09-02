// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../less/app.less";
import "./vendor/semantic-ui";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

import LiveSocket from "phoenix_live_view";
let liveSocket = new LiveSocket("/live");
liveSocket.connect();

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"


$(function() {

  $('.ui.menu .ui.dropdown').dropdown({
    on: 'hover'
  });

  $('.ui.menu a.item').on('click', function() {
      $(this)
        .addClass('active')
        .siblings()
        .removeClass('active')
      ;
  });

  $('div.error.message i.close.icon').on('click', function() {
    $(this).closest('.error.message').remove();
  })
});

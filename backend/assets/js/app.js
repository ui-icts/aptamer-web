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

import {Socket} from "phoenix";
import {LiveSocket} from "phoenix_live_view";

import $ from 'jquery';

import Dropzone from "dropzone";

let Hooks = {};
Hooks.SemanticUiDropdown = {
  mounted() {
    console.log("DROPDOWN MOUNTED", this.el.id);
    $(this.el).dropdown({
      action: 'activate'
    });
  },

  destroyed() {
    console.log("DROPDOWN DESTROYED", this.el.id);
  },

  updated() {
    let fieldVal = $('input:hidden:first', this.el).val()
    console.log("DROPDOWN UPDATED", this.el.id, fieldVal);
    $(this.el).dropdown('set selected', fieldVal);
  }
}

Hooks.SemanticUiCheckbox = {
  mounted() {
    $(this.el).checkbox();
  },

  updated() {
    let fieldVal = $('input:checkbox:first', this.el).val()
    console.log("UPDATED", fieldVal);
  }
}

//this is the 'client' of the modal
//it needs to pass data to it so that when it is displayed it can
//show the right stuffs
Hooks.ShowModal = {
  mounted() {
    let modalId = $(this.el).data('modal-id');
    // let fileId = $(this.el).data('file-id');
    // let fileName = $(this.el).data('file-name');
    let modalSelector = `#${modalId}.ui.modal`;
    let sourceData = $(this.el).data();
    $(this.el).on('click', function() {
      let theModal = $(modalSelector);
      $.each(sourceData, function(k,v) {
        if (k.startsWith("job") || k.startsWith("file")) {
          theModal.data(k,v);
        }
      });
      theModal.modal('show');
    });
  }
}

// Used on the modal itself. Need to update it using
// the DOM because if phoenix does it it gets put back in the dom
// and in order to display int he right spot it needs to not do that
Hooks.SemanticModalDialog = {
  mounted() {

    let $domElement = $(this.el);
    let pushEvent = this.pushEvent.bind(this); 

    $(this.el).modal({
      onShow: function() {
        $('span.file-name', $domElement).text( $domElement.data('file-name') );
      },

      onApprove: function(btn) {
        let fileId = $domElement.data('file-id');
        pushEvent('delete_file', {file_id: fileId});
      }
    });
  },

  destroyed() {
    console.log("MODAL DESTROY");
  },

  updated() {
    console.log("MODAL UPDATE");
  }


}

Hooks.ConfirmJobDelete = {
  mounted() {

    let $domElement = $(this.el);
    let pushEvent = this.pushEvent.bind(this); 

    $(this.el).modal({
      onShow: function() {
        $('span.job-description', $domElement).text( $domElement.data('job-description') );
        $('span.job-status', $domElement).text( $domElement.data('job-status') );
      },

      onApprove: function(btn) {
        let jobId = $domElement.data('job-id');
        pushEvent('delete_job', {job_id: jobId});
      }
    });
  },

  destroyed() {
    console.log("MODAL DESTROY");
  },

  updated() {
    console.log("MODAL UPDATE");
  }


}
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: {_csrf_token: csrfToken},
  hooks: Hooks
});

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

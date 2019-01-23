import { inject as service } from '@ember/service';
import Component from '@ember/component';
import Controller from '@ember/controller';
import ENV from 'aptamer/config/environment';

Controller.reopen({
    rootURL: ENV.rootURL,
});

Component.reopen({
    rootURL: ENV.rootURL,
});

export default Controller.extend({
  session: service('session'),

  actions: {
    invalidateSession() {
      this.get('session').invalidate();
    }
  }
})

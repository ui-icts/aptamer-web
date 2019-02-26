import { inject as service } from '@ember/service';
import Component from '@ember/component';

export default Component.extend({
  fileContents: service(),
  contents: '',

  didReceiveAttrs () {
    this._super(...arguments);

    let fileContents = this.fileContents;
    fileContents.captureContents(this.file.id, (payload) => {
      this.set("contents", payload)
    });
  }
})

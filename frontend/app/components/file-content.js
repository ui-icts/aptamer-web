import Ember from 'ember';

export default Ember.Component.extend({
  fileContents: Ember.inject.service(),
  contents: '',

  didReceiveAttrs () {
    this._super(...arguments);

    let fileContents = this.get('fileContents');
    fileContents.captureContents(this.get('file').id, (payload) => {
      this.set("contents", payload)
    });
  }
})

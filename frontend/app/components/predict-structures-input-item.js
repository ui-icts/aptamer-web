import Ember from 'ember';
import { task, timeout } from 'ember-concurrency';

export default Ember.Component.extend({
  classNames: ['item'],
  store: Ember.inject.service(),

  processTask: task( function * (file) {
    let result = this.get('store').createRecord('result', {
      file: file,
      status: 'Not Started'
    });

    file.get('results').pushObject(result);

    yield timeout(4*1000);

    let childFile = this.get('store').createRecord('file', {
      generatedBy: result,
      fileName: file.get('fileName') + '.struct',
    });

    result.get('generatedFiles').pushObject(childFile);
    result.set('status', 'Complete');
  }),

});

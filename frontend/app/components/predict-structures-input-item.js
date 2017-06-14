import Ember from 'ember';
import { task } from 'ember-concurrency';

export default Ember.Component.extend({
  classNames: ['item'],
  store: Ember.inject.service(),

  processTask: task( function * (file) {
    let result = this.get('store').createRecord('result', {
      file: file,
      status: 'Not Started'
    });

    file.get('results').pushObject(result);

    result = yield result.save();

    let childFile = this.get('store').createRecord('file', {
      generatedBy: result,
      fileName: file.get('fileName') + '.struct',
      filePurpose: 'create-graph-input'
    });

    childFile = yield childFile.save();

    result.get('generatedFiles').pushObject(childFile);
    result.set('status', 'Complete');

    yield result.save();
  }),

});

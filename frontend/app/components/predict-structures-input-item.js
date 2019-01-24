import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { task } from 'ember-concurrency';

export default Component.extend({
  classNames: ['item'],
  store: service(),

  processTask: task( function * (file) {
    let result = this.store.createRecord('result', {
      file: file,
      status: 'Not Started'
    });

    file.get('results').pushObject(result);

    result = yield result.save();

    let childFile = this.store.createRecord('file', {
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

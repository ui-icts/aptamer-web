import Ember from 'ember';
import { task, timeout } from 'ember-concurrency';

export default Ember.Component.extend({
  classNames: ['item'],
  store: Ember.inject.service(),
  showMore: false,

  init() {
    this._super(...arguments);
    this.set('optionsObject', this.get('store').createRecord('create-graph-options'));
  },

  processTask: task(function * (file) {
    let result = this.get('store').createRecord('result', {
      file: file,
      status: 'Not Started'
    });

    file.get('results').pushObject(result);
    yield timeout(2*1000);

    result.set('status', 'Processing');

    yield timeout(5*1000);

    let allResults = yield file.get('results')
    result.set('resultNumber', allResults.length + 2);
    result.set('status', 'Complete');

  }),

  actions: {
    toggleShowMore() {
      this.toggleProperty('showMore');
    },

  }
});

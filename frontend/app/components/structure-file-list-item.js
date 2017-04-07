import Ember from 'ember';
import CreateGraphOptions from '../models/create-graph-options';

export default Ember.Component.extend({
  classNames: ['item'],
  showMore: false,
  
  init() {
    this._super(...arguments);
    this.set('optionsObject', CreateGraphOptions.create());
  },

  actions: {
    toggleShowMore() {
      this.toggleProperty('showMore');
    }
  }
});

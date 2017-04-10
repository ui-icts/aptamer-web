import Ember from 'ember';

export default Ember.Component.extend({
  showHelp: true,
  showCommandPreview: true,
  edgeTypes: ['edit', 'tree', 'both'],

  actions: {
    toggleCommandPreview() {
      this.toggleProperty('showCommandPreview');
    },

    toggleHelp() {
      this.toggleProperty('showHelp');
    }
  }
});

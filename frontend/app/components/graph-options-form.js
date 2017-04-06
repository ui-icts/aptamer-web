import Ember from 'ember';

export default Ember.Component.extend({
  showHelp: false,
  showCommandPreview: true,
  edgeTypes: ['edit', 'tree', 'both'],

  actions: {
    toggleCommandPreview() {
      this.set('showCommandPreview', !this.get('showCommandPreview'));
    }
  }
});

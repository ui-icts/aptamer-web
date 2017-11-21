import Ember from 'ember';

function formatSliderValue(value) {
  if ( Number.parseInt(value) === 11 ) {
    return "None";
  } else {
    return value.toString();
  }
}

export default Ember.Component.extend({
  showHelp: false,
  showCommandPreview: true,
  edgeTypes: ['edit', 'tree', 'both'],

  editDistanceDisplay: Ember.computed('optionsObject.maxEditDistance', function() {
    let value = this.get('optionsObject.maxEditDistance');
    return formatSliderValue(value);
  }),

  treeDistanceDisplay: Ember.computed('optionsObject.maxTreeDistance', function() {
    let value = this.get('optionsObject.maxTreeDistance');
    return formatSliderValue(value);
  }),

  actions: {
    toggleCommandPreview() {
      this.toggleProperty('showCommandPreview');
    },

    toggleHelp() {
      this.toggleProperty('showHelp');
    }
  }
});

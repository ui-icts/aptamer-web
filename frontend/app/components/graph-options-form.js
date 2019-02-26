import { computed } from '@ember/object';
import Component from '@ember/component';

function formatSliderValue(value) {
  if ( Number.parseInt(value) === 11 ) {
    return "None";
  } else {
    return value.toString();
  }
}

export default Component.extend({
  showHelp: false,
  showCommandPreview: true,

  init() {
    this._super(...arguments);
    this.edgeTypes = ['edit', 'tree', 'both'];
  },

  editDistanceDisplay: computed('optionsObject.maxEditDistance', function() {
    let value = this.get('optionsObject.maxEditDistance');
    return formatSliderValue(value);
  }),

  treeDistanceDisplay: computed('optionsObject.maxTreeDistance', function() {
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

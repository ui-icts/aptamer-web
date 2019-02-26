import { computed } from '@ember/object';
import Component from '@ember/component';

export default Component.extend({
  showHelp: false,
  showCommandPreview: true,

  init() {
    this._super(...arguments);
    this.predictionTools = ['ViennaRNA', 'mFold'];
  },

  currentTool: computed('optionsObject.{runMfold,viennaVersion}', function() {
    let runmfold = this.get('optionsObject.runMfold');

    if ( runmfold ) {
      return 'mFold';
    } else {
      return 'ViennaRNA';
    }
  }),

  actions: {
    changeTool(newTool) {
      if ( newTool === 'mFold' ) {
        this.set('optionsObject.runMfold', true );
      } else {
        this.set('optionsObject.runMfold', false );
      }
    },

    toggleCommandPreview() {
      this.toggleProperty('showCommandPreview');
    },

    toggleHelp() {
      this.toggleProperty('showHelp');
    }
  }

});

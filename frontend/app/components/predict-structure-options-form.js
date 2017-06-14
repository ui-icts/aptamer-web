import Ember from 'ember';

export default Ember.Component.extend({
  showHelp: false,
  showCommandPreview: true,

  predictionTools: ['ViennaRNA', 'mFold'],
  currentTool: Ember.computed('optionsObject.runMfold', 'optionsObject.viennaVersion', function() {
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

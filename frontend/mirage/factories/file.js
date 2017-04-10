import { Factory } from 'ember-cli-mirage';

export default Factory.extend({
  fileName(i) {
    return `Final_${i}_struct.fa`;
  },

  uploadedOn() {
    return new Date();
  },

});

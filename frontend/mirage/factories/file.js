import { Factory, trait } from 'ember-cli-mirage';

export default Factory.extend({
  fileName(i) {
    return `Final_${i}_struct.fa`;
  },

  uploadedOn() {
    return new Date();
  },

  filePurpose(i) {
    return "UNKNOWN";
  },

  createGraphInput: trait({
    filePurpose: "create-graph-input"
  }),

  predictStructuresInput: trait({
    filePurpose: "predict-structures-input"
  })
});

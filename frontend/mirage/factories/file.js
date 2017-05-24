import { Factory, trait } from 'ember-cli-mirage';

export default Factory.extend({
  fileName(i) {
    return `somefile_${i}.txt`;
  },

  uploadedOn() {
    return new Date();
  },

  fileType(i) {
    return "UNKNOWN";
  },

  fasta: trait({
    fileName(i) {
      return `Final_${i}.fa`;
    },
    fileType: "fasta"
  }),

  structure: trait({
    fileName(i) {
      return `Final_${i}_struct.fa`;
    },
    fileType: "structure"
  })
});

import { Factory, trait } from 'ember-cli-mirage';

function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min)) + min;
}

export default Factory.extend({
  fileName(i) {
    return `somefile_${i}.txt`;
  },

  uploadedOn() {
    let days = getRandomInt(0,500);
    let d = new Date();
    d.setDate( d.getDate() - days );
    return d;
  },

  fileType: "UNKNOWN",

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

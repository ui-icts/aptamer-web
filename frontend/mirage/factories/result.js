import { Factory, association } from 'ember-cli-mirage';

export default Factory.extend({
  bobby() {
    return "Bobby";
  },

  generatedAt() {
    return new Date();
  },

  resultNumber(i) {
    return i + 1;
  },

  commandLine: "python create_graph.py -t both --seed 3 -e 3",

  programVersion: "0070565ae3afceb72944f65a42d8bb1389bdd566",

  file: association()
});

import Ember from 'ember';

const FileType = Ember.Object.extend({
  key: '',
  title: ''
});

const fileTypes = [
  FileType.create({
    key: 'fasta',
    title: 'FASTA'
  }),

  FileType.create({
    key: 'structure',
    title: 'FASTA (M)'
  })
];

export default Ember.Service.extend({
  list() {
    return fileTypes.copy();
  }
});

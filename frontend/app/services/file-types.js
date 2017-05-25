import Ember from 'ember';

const FileType = Ember.Object.extend({
  key: '',
  title: ''
});


const fileTypes = {
  structure: FileType.create({
    key: 'structure',
    title: 'Structure',
    operationText: 'Create Graph',
  }),

  fasta: FileType.create({
    key: 'fasta',
    title: 'FASTA',
    operationText: 'Create Structure',
  }),

  unknown: FileType.create({
  key: 'unknown',
  title: 'Unknown',
  operationText: 'Assign Filetype'
  })
};

export default Ember.Service.extend({

  list() {
    return [
      fileTypes.structure, fileTypes.fasta, fileTypes.unknown
    ];
  },

  find( key ) {
    return fileTypes[key] || fileTypes.unknown;
  }

});

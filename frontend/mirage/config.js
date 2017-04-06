export default function() {

  // These comments are here to help you get started. Feel free to delete them.

  /*
    Config (with defaults).

    Note: these only affect routes defined *after* them!
  */

  // this.urlPrefix = '';    // make this `http://localhost:8080`, for example, if your API is on a different server
  // this.namespace = '';    // make this `/api`, for example, if your API is namespaced
  // this.timing = 400;      // delay for each request, automatically set to 0 during testing

  /*
    Shorthand cheatsheet:

    this.get('/posts');
    this.post('/posts');
    this.get('/posts/:id');
    this.put('/posts/:id'); // or this.patch
    this.del('/posts/:id');

    http://www.ember-cli-mirage.com/docs/v0.3.x/shorthands/
  */

  this.post('/upload', () => {
    return {data: {type: 'struct-file', id: '111-XXX', attributes: {}}}
  }, { timing: 8000 });

  this.get('/structure-files', () => {

    return {
      data: [{
        type: 'structure-files',
        id: 'final_rd12_struct.fa - 1',
        attributes: {
          'file-name': 'Final_Rd12_struct.fa',
          'uploaded-on': '2017-03-25T08:15:30-05:00'
        }
      }, {
        type: 'structure-files',
        id: 'final_rd12_struct.fa - 2',
        attributes: {
          'file-name': 'Final_Rd12_struct.fa',
          'uploaded-on': '2017-04-01T08:15:30-05:00'
        }
      },{
        type: 'structure-files',
        id: 'final_rd12_struct.fa - 3',
        attributes: {
          'file-name': 'Final_Rd12_struct.fa',
          'uploaded-on': '2017-04-03T08:15:30-05:00'
        }
      }]
    };

  });
}

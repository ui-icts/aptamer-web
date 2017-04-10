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

  function buildFilterQuery(queryParams) {
    let query = {};
    Object.keys(queryParams).forEach(key => {
      let filterRegex = key.match(/filter\[([^&]*)\]/);
      if (filterRegex) {
        query[filterRegex[1]] = queryParams[key];
      }
    });
    return query;
  }

  this.post('/upload/create-graph', (schema,request) => {
    let sf = schema.files.create({ 
      fileName: "Uploaded File",
      filePurpose: 'create-graph-input',
      uploadedOn: new Date()
    });

    return sf;
  }, { timing: 4000 });

  this.post('/upload/predict-structures', (schema,request) => {
    let sf = schema.files.create({ 
      fileName: "Uploaded File",
      filePurpose: 'predict-structures-input',
      uploadedOn: new Date()
    });

    return sf;
  }, { timing: 4000 });

  this.get('/files', (schema, request) => {
    if (request.queryParams) {
      return schema.files.where(buildFilterQuery(request.queryParams));
    } else {
      return schema.files.all();
    }
  });

  this.get('/files/:id', ['file','results'])

  this.get('/results');
  this.get('/results/:id');
}

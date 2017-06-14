import Ember from 'ember';

const MenuItem = Ember.Object.extend({
  text: '',
  selected: false,
  value: null
});

const allItem = MenuItem.create({
  text: 'All',
  value: 'all'
});

export default Ember.Component.extend({
  fileTypes: Ember.inject.service('file-types'),

  currentFilter: 'all',
  menuItems: Ember.computed('currentFilter', function() {
    let fileTypes = this.get('fileTypes'),
        items;

    items = fileTypes.list().map( (ft) => {
      return MenuItem.create({
        text: ft.get('title'),
        value: ft.get('key')
      });
    });

    items.insertAt(0, allItem);

    items.forEach( (i) => {
      if ( i.get('value') === this.get('currentFilter') ) {
        i.set('selected', true);
      } else {
        i.set('selected', false);
      }
    });

    return items;
  }),
});

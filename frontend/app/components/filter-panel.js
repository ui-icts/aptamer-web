import { inject as service } from '@ember/service';
import Component from '@ember/component';
import EmberObject, { computed } from '@ember/object';

const MenuItem = EmberObject.extend({
  text: '',
  selected: false,
  value: null
});

const allItem = MenuItem.create({
  text: 'All',
  value: 'all'
});

export default Component.extend({
  fileTypes: service('file-types'),

  currentFilter: 'all',
  menuItems: computed('currentFilter', function() {
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

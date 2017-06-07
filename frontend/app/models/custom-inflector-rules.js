import Inflector from 'ember-inflector';

const inflector = Inflector.inflector;

//This is so that ember-data doesn't try to
//singular-ize CreateGraphOptions
inflector.uncountable('options');

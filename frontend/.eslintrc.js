module.exports = {
  root: true,
  parserOptions: {
    ecmaVersion: 2016,
    sourceType: 'module'
  },
  extends: 'eslint:recommended',
  env: {
    browser: true
  },
  rules: {
    "no-unused-vars": ["error", {"argsIgnorePattern": "^_"}]
  }
};

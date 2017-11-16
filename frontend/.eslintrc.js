const isTestEnv = process.env.EMBER_ENV === 'test';

module.exports = {
  root: true,
  parserOptions: {
    ecmaVersion: 2017,
    sourceType: 'module'
  },
  extends: 'eslint:recommended',
  env: {
    browser: true
  },
  rules: {
    "no-unused-vars": ["error", {"argsIgnorePattern": "^_"}],
    "no-console": isTestEnv ? "off" : "error"
  }
};

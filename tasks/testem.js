module.exports = {
  browser: {
    src: [
      'dist/indeed.js',
      'node_modules/chai/chai.js',
      'node_modules/sinon/pkg/sinon.js',
      'node_modules/lodash/index.js',
      'test/browser/*.coffee',
      'test/*.coffee'
    ],
    options: {
      framework: 'mocha',
      parallel: 2,
      launch_in_ci: ['PhantomJS'],
      launch_in_dev: ['PhantomJS', 'Chrome', 'Firefox', 'Safari'],
      reporter: 'dot'
    }
  }
};

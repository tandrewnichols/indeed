module.exports = {
  browser: {
    src: [
      'dist/indeed.js',
      'test/helpers/setup.js',
      'node_modules/chai/chai.js',
      'test/*.coffee'
    ],
    options: {
      framework: 'mocha',
      parallel: 2,
      reporter: 'tap',
      launch_in_ci: ['PhantomJS'],
      launch_in_dev: ['PhantomJS', 'Chrome', 'Firefox', 'Safari'],
      reporter: 'dot'
    }
  }
};

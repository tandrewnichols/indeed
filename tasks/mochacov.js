module.exports = {
  lcov: {
    options: {
      reporter: 'mocha-lcov-reporter',
      instrument: true,
      require: 'coffee-script/register',
      output: 'coverage/coverage.lcov'
    },
    src: ['test/**/*.coffee'],
  },
  html: {
    options: {
      reporter: 'html-cov',
      require: 'coffee-script/register',
      output: 'coverage/coverage.html'
    },
    src: ['test/**/*.coffee']
  }
};

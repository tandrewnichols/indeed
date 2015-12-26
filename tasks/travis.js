module.exports = {
  options: {
    targets: {
      test: '{{ version }}',
      when: 'v4.0.0',
      tasks: ['mochacov:lcov', 'matrix:v4.0.0']
    }
  }
};

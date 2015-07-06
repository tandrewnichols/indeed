module.exports = {
  dist: {
    src: ['lib/**'],
    dest: 'dist/indeed.js',
    options: {
      browserifyOptions: {
        entry: 'lib/index',
        standalone: 'indeed'
      }
    }
  }
};

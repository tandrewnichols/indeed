module.exports = {
  dist: {
    src: ['lib/**'],
    dest: 'dist/indeed.js',
    options: {
      browserifyOptions: {
        standalone: 'indeed'
      }
    }
  }
};

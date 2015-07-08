module.exports = {
  dist: {
    src: ['lib/index.js'],
    dest: 'dist/indeed.js',
    options: {
      browserifyOptions: {
        standalone: 'indeedLib'
      }
    }
  }
};

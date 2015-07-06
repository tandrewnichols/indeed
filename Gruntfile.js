var tm = require('task-master');

module.exports = function(grunt) {
  tm(grunt, {
    jit: {
      travis: 'grunt-travis-matrix',
      matrix: 'grunt-travis-matrix',
      mochacov: 'grunt-mocha-cov'
    }
  });
  grunt.registerTask('mocha', ['mochaTest:test']);
  grunt.registerTask('test', ['jshint:all', 'mocha', 'testem:ci:browser']);
  grunt.registerTask('default', ['browserify:dist', 'test']);
  grunt.registerTask('coverage', ['mochacov:html', 'open:coverage']);
  grunt.registerTask('ci', ['test', 'travis']);
  grunt.registerTask('build', ['clean:dist', 'browserify:dist', 'uglify:dist']);
  grunt.registerTask('browser', ['browserify:dist', 'testem:run:browser']);
};

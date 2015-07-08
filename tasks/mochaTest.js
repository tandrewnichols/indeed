module.exports = {
  options: {
    reporter: 'spec',
    require: 'coffee-script/register'
  },
  test: {
    src: '<%= files.nodeTests %>'
  }
};

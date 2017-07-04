module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    concat: {
      domop: {
        src: ['script/pda_base.js', 'script/pda_listview.js', 'script/pda_panel.js', 'script/pda_category.js', 'script/pda_fixed.js', 'script/pda_dialog.js', 'script/pda_collapsible.js', 'script/pda_button.js'],
        dest: 'script/lib/pda.js'
      }
    },
    uglify: {
      options: {
        banner: '\n'
      },
      bulid: {
        src: 'script/lib/pda.js',
        dest: 'script/lib/pda.min.js'
      }
    },
    cssmin: {
      combine: {
        files: {
          'css/style/pda.min.css': ['css/style/*.css', 'css/style/!*.min.css']
        }
      }
    }
  });
  grunt.loadNpmTasks('grunt-contrib-concat');
  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-uglify');

  grunt.loadNpmTasks('grunt-contrib-cssmin');

  // Default task(s).
  grunt.registerTask('default', ['concat', 'uglify', 'cssmin']);
};
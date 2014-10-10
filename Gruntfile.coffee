module.exports = (grunt) ->
	require('time-grunt')(grunt)

	require('load-grunt-tasks')(grunt)

	grunt.initConfig
		clean:
			dev: [
				'build'
			]

		coffee:
			dev:
				options:
					sourceMap: false
					bare: true
				files: [
					expand: true
					flatten: false
					src: [
						'*.coffee'
					]
					dest: 'build'
					ext: '.js'
				]

		copy:
			dist:
				expand: true
				src: [
					'index.html'
				]
				dest: 'build'

		less:
			dev:
				files:
					'build/style.css': 'style.less'

		uglify:
			dist:
				files: [
					expand: true
					cwd: 'build'
					src: '*.js'
					dest: 'build'
				]

		connect:
			dist:
				options:
					hostname: '*'
					port: 9003
					base: 'build'
					livereload: false
					open: false

		watch:
			dev:
				options:
					livereload: true
				files: [
					'**'
				]
				tasks: [
					'build'
				]

	grunt.registerTask('build', ['clean', 'coffee', 'copy', 'less', 'uglify'])
	grunt.registerTask('serve', ['build', 'connect', 'watch'])

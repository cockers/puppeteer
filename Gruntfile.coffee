module.exports = (grunt) ->
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-connect'
	grunt.loadNpmTasks 'grunt-contrib-compass'
	grunt.loadNpmTasks 'grunt-contrib-requirejs'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-mocha'
	grunt.loadNpmTasks 'grunt-smushit'

	grunt.initConfig
		clean:
			all : ['./dev/*', './production/*']
			dev : ['./dev/*']
			production : ['./production/*']

		connect:
			dev:
				options:
					port: 8000
					base: '.'
					keepalive: true
			test:
				options:
					port: 8000
					base: '.'

		copy:
			dev:
				files: [
					expand: true
					cwd: './src/app/assets'
					src: ['**']
					dest: './dev/app/assets'
				]
			templates:
				files: [
					expand: true
					cwd: './src/app/modules'
					src: ['**/*.html']
					dest: './dev/app/modules'
				]
			test:
				files: [
					expand: true
					cwd: './src/test/fixtures'
					src: ['**']
					dest: './dev/test/fixtures'
				]
			production:
				files: [
						expand: true
						cwd: './src/app/assets'
						src: ['**']
						dest: './production/app/assets'
				]
			productionRequire:
				files: [
						expand: true
						cwd: './lib/requirejs/'
						src: ['require.js']
						dest: './production/'
				]

		smushit:
			production:
				src: './production/app/assets'

		requirejs:
			compile:
				options:
					baseUrl: './dev/app'
					mainConfigFile: './dev/app/main.js'
					out: './production/app/main.js'
					include: 'main'

		coffee:
			dev:
				files: [
					expand: true
					cwd: './src/'
					src: ['**/*.coffee']
					dest: './dev/'
					ext: '.js'
				]

		compass:
			dev:
        options:
          sassDir: './src/app/css/',
          cssDir: './dev/app/css/'
          importPath: 'lib/',
			production:
        options:
          sassDir: './src/app/css/',
          cssDir: './production/app/css/'
          importPath: 'lib/',


		mocha:
			test:
				options:
					urls: [ 'http://localhost:8000/test.html']
					reporter : 'Dot'

		watch:
			options:
				livereload: true
			templates:
				files: './src/app/**/*.html'
				tasks: ['copy:templates']
				options:
					nospawn: true
			coffee:
				files: './src/app/**/*.coffee'
				tasks: []
				options:
					nospawn: true
			compass:
				files: './src/**/*.sass'
				tasks: ['compass:dev']
			test:
				files: './src/test/**/*.coffee'
				tasks: ['test:watch']
				options:
					nospawn: true

	grunt.event.on 'watch', (action, filepath) ->
		cwd = 'src/'
		filepath = filepath.replace cwd, ''

		grunt.config.set 'coffee',
			changed:
				expand: true
				cwd: cwd
				src: filepath
				dest: './dev'
				ext: '.js'
				options:
					livereload: true

		grunt.task.run 'coffee:changed' unless filepath.indexOf('.coffee') < 0

	grunt.registerTask 'default', [
		'dev'
		'connect:dev'
	]

	grunt.registerTask 'dev', [
		'clean:dev'
		'coffee'
		'compass:dev'
		'copy:dev'
		'copy:test'
		'copy:templates'
	]

	grunt.registerTask 'production', [
		'clean:production'
		'test'
		'compass:production'
		'copy:production'
		'copy:productionRequire'
		'copy:templates'
		'requirejs'
		'smushit:production'
	]

	grunt.registerTask 'test:watch', [
		'copy:test'
		'mocha'
	]

	grunt.registerTask 'test', [
		'coffee'
		'copy:test'
		'connect:test'
		'mocha'
	]
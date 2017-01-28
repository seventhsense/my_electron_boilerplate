gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
concat  = require 'gulp-concat'
gutil   = require 'gulp-util'
plumber = require 'gulp-plumber'
eco     = require 'gulp-eco'
sass    = require 'gulp-sass'
notify  = require 'gulp-notify'
webpack = require 'webpack-stream'
packager = require 'electron-packager'

gulp.task 'main', ->
  gulp.src('./coffee/main.coffee')
    .pipe(plumber())
    .pipe(coffee()).on('error', gutil.log)
    .pipe(concat('main.js'))
    .pipe(gulp.dest('dist'))
    .on 'finish', ->
       gutil.log 'main.js done'

gulp.task 'app', ->
  gulp.src [
    './coffee/namespace.coffee',
    './coffee/models/**/*.coffee',
    './coffee/collections/**/*.coffee',
    './coffee/views/**/*.coffee'
    './coffee/collection_views/**/*.coffee'
  ]
    .pipe(plumber())
    .pipe(coffee()).on('error', gutil.log)
    .pipe(concat('app.js'))
    .pipe(gulp.dest('tmp'))
    .on('finish', -> gutil.log 'app.js done')

gulp.task 'templates', ->
  gulp.src('./templates/**/*.eco')
    .pipe(plumber())
    .pipe(eco(basePath: 'templates')).on('error', gutil.log)
    .pipe(concat('templates.js'))
    .pipe(gulp.dest('tmp'))
    .on('finish', -> gutil.log 'templates.js done')

gulp.task 'concat', ['app', 'templates'], ->
  gulp.src ['tmp/vendor.js', 'tmp/templates.js', 'tmp/app.js']
    .pipe(concat('index.js'))
    .pipe(gulp.dest('dist'))
    .pipe notify    'index.js done', onLast: true
    .on('finish', -> gutil.log 'index.js done')

gulp.task 'vendor', ->
  gulp.src 'coffee/vendor.coffee'
    .pipe webpack(require './webpack.config.coffee')

gulp.task 'pack-linux', ['concat'], ->
  packager
    dir: './dist'
    name: 'app2'
    arch: 'x64'
    platform: 'linux'
    electronVersion: '1.4.14'
    overwrite: true

gulp.task 'watch', ->
  gulp.watch('coffee/main.coffee', ['main'])
  gulp.watch('coffee/**/*.coffee', ['concat'])
  gulp.watch('templates/**/*.eco', ['concat'])

gulp.task 'default', ['concat', 'main', 'watch']

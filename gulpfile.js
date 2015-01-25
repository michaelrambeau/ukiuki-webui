var gulp = require('gulp');

var concat = require('gulp-concat');
var jade = require('gulp-jade');
var sass = require('gulp-sass');
var less = require('gulp-less');
var coffee = require('gulp-coffee');
var minifyCss = require('gulp-minify-css');
var rename = require('gulp-rename');
var browserSync = require('browser-sync');

var paths = {
	less: ['app/styles/**/*.less'],
  sass: ["./scss/**/*.scss", "./scss/**/*.sass"],
  coffee: ['./app/app.coffee', './app/services/*.coffee', './app/main-controller.coffee', './app/*/*.coffee']
};

var libs = [
	//'bower_components/ionic/release/js/ionic.bundle.js',
	'bower_components/angular-utils-pagination/dirPagination.js',
	'bower_components/ui-router-extras/release/ct-ui-router-extras.js',
	'bower_components/angular-file-upload/angular-file-upload.js',
	'bower_components/cloudinary_ng/js/angular.cloudinary.js',

];

var fonts = [
	'bower_components/ionic/release/fonts/ionicons.ttf',
	'bower_components/ionic/release/fonts/ionicons.woff'
];

gulp.task('lib', function(done){
  return gulp.src(libs)
		.pipe(concat('lib.js'))
		.pipe(gulp.dest('./www/js/'));
});

gulp.task('fonts', function(done){
  return gulp.src(fonts)
		.pipe(gulp.dest('./www/fonts/'));
});


gulp.task('jade', function(done) {
  return gulp.src(['app/index.jade','temp/index-test.jade'])
		.pipe(jade({
			pretty: true
		}))
		.pipe(gulp.dest('www/'));
});
gulp.task('jade-partials', function(done) {
  return gulp.src('app/templates/**/*.jade')
		.pipe(jade({
			pretty: true
		}))
		.pipe(gulp.dest('www/html/'));
});


gulp.task('coffee', function(done) {
  gulp.src('app/app-module/**/*.coffee')
		.pipe(coffee())
		.pipe(concat('app.js'))
		.pipe(gulp.dest('./www/js/'));
	return gulp.src('app/resource-module/**/*.coffee')
		.pipe(coffee())
		.pipe(concat('resource.js'))
		.pipe(gulp.dest('./www/js/'));
});

gulp.task('coffee-test', function(done) {
  return gulp.src('temp/**/*.coffee')
		.pipe(coffee())
		.pipe(concat('app-test.js'))
		.pipe(gulp.dest('./www/js/'));
});

gulp.task('less', function(done) {
  gulp.src('./app/styles/app.less').pipe(less()).pipe(gulp.dest('./www/css/'));
	done();
});

gulp.task('copycss', function(done) {
  return gulp.src('bower_components/ionic/release/css/ionic.css')
		.pipe(gulp.dest('./www/css/'));
});


gulp.task('sass', function(done) {
  return gulp.src('./scss/ionic.app.scss').pipe(sass()).pipe(gulp.dest('./www/css/')).pipe(minifyCss({
    keepSpecialComments: 0
  })).pipe(rename({
    extname: '.min.css'
  })).pipe(gulp.dest('./www/css/'));
});

gulp.task('images', function () {
	gulp.src('app/styles/site/images/**/*')
		.pipe(gulp.dest('www/css/site/images'))
  return gulp.src('app/images/**/*')
    .pipe(gulp.dest('www/images'));
});

gulp.task('watch', function() {
  gulp.watch('./app/**/*.jade', ['jade','jade-partials']);
	gulp.watch('./app/**/*.coffee', ['coffee']);
  gulp.watch(paths.sass, ['sass']);
  gulp.watch(paths.less, ['less']);
});

// Build and serve the output from the dist build
gulp.task('serve', ['default'], function () {
  browserSync({
    notify: false,
    server: 'www',
		port: 3001
  });
});

// Build Production Files, the Default Task
gulp.task('default', [], function (cb) {
	console.log('No default task');
	cb();
  //runSequence('styles', ['jshint', 'html', 'images', 'fonts', 'copy'], cb);
});

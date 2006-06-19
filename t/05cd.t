use strict;
use warnings;

use Test::More;

plan tests => 10;

use FindBin;
use lib "$FindBin::Bin/lib";
require Path::Class;


$ENV{MODEL_FILE_DIR} = $FindBin::Bin . '/store';
Path::Class::dir($ENV{MODEL_FILE_DIR})->rmtree;

use_ok('Catalyst::Model::File');
use_ok('TestApp');


ok(-d $ENV{MODEL_FILE_DIR}, 'Store directory exists');

my $model = TestApp->model('File');

# Subdir test
{
    my $file = 'sub/dir/file.txt';
    $model->splat($file, $file);

}

$model->cd('sub', 'dir');

is(Path::Class::dir('/sub/dir'), $model->pwd, "pwd is correct");

is_deeply([
        Path::Class::file('file.txt')
    ],
    [ $model->list ], "list right after cd");


$model->cd('..', 'foo');

is(Path::Class::dir('/sub/foo'), $model->pwd, "pwd right after cd('..')");

is(Path::Class::dir('/sub'), $model->parent->pwd, "Parent right");
is(Path::Class::dir('/'), $model->parent->pwd, "Parent right");
is(Path::Class::dir('/'), $model->parent->pwd, "Parent doesn't go out of root");

is_deeply([
        Path::Class::file('sub/dir/file.txt')
    ],
    [ $model->list ], "List right after repeated parent");



$model->{root_dir}->rmtree;

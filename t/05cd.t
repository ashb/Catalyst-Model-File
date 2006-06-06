use strict;
use warnings;

use Test::More;

plan tests => 10;

use FindBin;
use lib "$FindBin::Bin/lib";


$ENV{MODEL_FILE_DIR} = $FindBin::Bin . '/store';
{
    require Path::Class;
    Path::Class::dir($ENV{MODEL_FILE_DIR})->rmtree;
}

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

is('/sub/dir', $model->pwd, "pwd is correct");

is_deeply([
        Path::Class::file('file.txt')
    ],
    [ $model->list ], "list right after cd");


$model->cd('..', 'foo');

is('/sub/foo', $model->pwd, "pwd right after cd('..')");

is('/sub', $model->parent->pwd, "Parent right");
is('/', $model->parent->pwd, "Parent right");
is('/', $model->parent->pwd, "Parent doesn't go out of root");

is_deeply([
        Path::Class::file('sub/dir/file.txt')
    ],
    [ $model->list ], "List right after repeated parent");



$model->{root_dir}->rmtree;

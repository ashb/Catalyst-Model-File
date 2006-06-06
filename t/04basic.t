use strict;
use warnings;

use Test::More;

plan tests => 12;

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

my @files = (qw(foo1 foo2));

for my $file (@files) {
    open FILE, '>>', $ENV{MODEL_FILE_DIR} . '/' .$file;
    print FILE $file;
    close FILE;
}

my $model = TestApp->model('File');

ok($model);

is_deeply(\@files, [ $model->list], 'List matches');

for my $file (@files) {
    is($file, $model->slurp($file), 'slurp okay');
}

# Slurp/Splat tests
{
    my $file = 'file3';
    my $string = 'A B C';
    $model->splat($file, $string);

    open FILE, $ENV{MODEL_FILE_DIR} . '/'. $file;
    my (@lines) = <FILE>;
    close FILE;
    is_deeply([$string], \@lines, 'splat works');
 
    is($string, $model->slurp($file), 'slurp works');
}

# Subdir test
{
    my $file = 'sub/dir/file,txt';
    $model->splat($file, $file);

    my $file_obj = $model->file($file);
    

    ok($file_obj->stat, 'File in sub directory created');
    is($file, $file_obj->slurp, "contents are right");
}

is_deeply([
    Path::Class::file('file3'),
    Path::Class::file('foo1'),
    Path::Class::file('foo2'),
    Path::Class::dir('sub'),
,], [sort $model->list(recurse => 0, mode => 'both')], "List without recurse is right");

$model->{root_dir}->rmtree;

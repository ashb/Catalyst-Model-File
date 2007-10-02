use inc::Module::Install;

name            'Catalyst-Model-File';
all_from        'lib/Catalyst/Model/File.pm';

requires        'perl'                  => '5.8.1';
requires        'Catalyst'              => '5.69';
requires        'Catalyst::Component::InstancePerContext' => 0;
requires        'Path::Class';

build_requires  'Test::More';

no_index        directory => 't/lib';

WriteAll;

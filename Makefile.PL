use inc::Module::Install 0.87;

name            'Catalyst-Model-File';
all_from        'lib/Catalyst/Model/File.pm';
perl_version    '5.8.1';

requires        'Catalyst' => '5.69';
requires        'Catalyst::Component::InstancePerContext' => 0;
requires        'Path::Class';
requires        'MRO::Compat';

build_requires  'Test::More';

no_index        directory => 't/lib';

resources repository => 'git://github.com/ashb/Catalyst-Model-File.git';

WriteAll;

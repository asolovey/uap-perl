use HTTP::UA::Parser;
use strict;
use Test::More;
use FindBin qw($Bin);

my $source = 'tests/test_device_brandmodel.yaml';

if ($ENV{TRAVIS} || $ENV{DEV_TESTS}){
    eval {
        require($Bin . '/utils.pl');
        my $yaml = get_test_yaml($source);
        my $r = HTTP::UA::Parser->new();
        foreach my $st (@{$yaml}){
            my $user_agent_string = $st->{user_agent_string};
            $r->parse($user_agent_string);
            my $device = $r->device;
            is ($device->family, $st->{family} );
            is ($device->brand,  $st->{brand}  );
            is ($device->model,  $st->{model}  );
        }
    };
    
    if ($@){
        diag $@;
        plan skip_all => 'Couldn\'t fetch tests file ' . $source;
    }
} else {
    plan skip_all => 'Set environment DEV_TESTS To run this test';
}

done_testing();

1;

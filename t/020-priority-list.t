#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;

BEGIN {
    use_ok('HTTP::Headers::ActionPack::PriorityList');
}

{
    my $q = HTTP::Headers::ActionPack::PriorityList->new;
    isa_ok($q, 'HTTP::Headers::ActionPack::PriorityList');

    $q->add( 1.0, "foo" );
    $q->add( 2.0, "bar" );
    $q->add( 3.0, "baz" );
    $q->add( 3.0, "foobaz" );
    $q->add( 2.5, "gorch" );

    is_deeply($q->get(2.5), ["gorch"], '... got the right item for the priority');
    is($q->priority_of("foo"), 1.0, '... got the right priority for the item');

    is_deeply($q->get(3.0), ["baz", "foobaz"], '... got the right item for the priority');

    is_deeply(
        [ $q->iterable ],
        [
            [ 3, 'baz' ],
            [ 3, 'foobaz' ],
            [ 2.5, 'gorch' ],
            [ 2, 'bar' ],
            [ 1, 'foo' ]
        ],
        '... got the iterable form'
    );
}

{
    my $q = HTTP::Headers::ActionPack::PriorityList->new_from_header_string( "application/xml;q=0.7" );

    is_deeply($q->get(0.7), ["application/xml"], '... got the right item for the priority');
    is($q->priority_of("application/xml"), 0.7, '... got the right priority for the item');

    is_deeply(
        [ $q->iterable ],
        [
            [ 0.7, "application/xml" ],
        ],
        '... got the iterable form'
    );
}

{
    my $q = HTTP::Headers::ActionPack::PriorityList->new_from_header_string( "en-US, es" );
    is_deeply(
        [ $q->iterable ],
        [
            [ 1, "en-US" ],
            [ 1, "es" ],
        ],
        '... got the iterable form'
    );
}


done_testing;
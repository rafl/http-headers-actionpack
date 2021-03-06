package HTTP::Headers::ActionPack::Core::BaseHeaderType;
# ABSTRACT: A Base header type

use strict;
use warnings;

use Carp qw[ confess ];

use HTTP::Headers::ActionPack::Util qw[
    split_header_words
    join_header_words
];

use parent 'HTTP::Headers::ActionPack::Core::BaseHeaderWithParams';

sub BUILDARGS {
    my $class = shift;
    my ($subject, @params) = @_;

    confess "You must specify a subject" unless $subject;

    return +{
        subject => $subject,
        %{ $class->_prepare_params( @params ) }
    };
}

sub subject { (shift)->{'subject'} }

sub new_from_string {
    my ($class, $header_string) = @_;
    $class->new( @{ (split_header_words( $header_string ))[0] } );
}

sub as_string {
    my $self = shift;
    join_header_words( $self->subject, $self->params_in_order );
}

1;

__END__

=head1 SYNOPSIS

  use HTTP::Headers::ActionPack::Core::BaseHeaderType;

=head1 DESCRIPTION

This is a base class for header values which also contain
a parameter list. There is no real user servicable parts
in here.

=head1 METHODS

=over 4

=item C<new( $subject, @params )>

=item C<subject>

=item C<new_from_string ( $header_string )>

This will take an HTTP header string
and parse it into and object.

=item C<as_string>

This stringifys the link respecting the
parameter order.

NOTE: This will canonicalize the header such
that it will add a space between each semicolon
and quotes and unquotes all headers appropriately.

=back







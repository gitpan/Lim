package Lim::Agent::CLI;

use common::sense;

use Scalar::Util qw(weaken);

use Lim ();
use Lim::Agent ();

use base qw(Lim::Component::CLI);

=encoding utf8

=head1 NAME

...

=head1 VERSION

See L<Lim> for version.

=cut

our $VERSION = $Lim::VERSION;

=head1 SYNOPSIS

...

=head1 SUBROUTINES/METHODS

=head2 version

=cut

sub version {
    my ($self) = @_;
    my $agent = Lim::Agent->Client;
    
    weaken($self);
    $agent->ReadVersion(sub {
		my ($call, $response) = @_;
		
		if ($call->Successful) {
			$self->cli->println('agent version ', $response->{version});
			$self->Successful;
		}
		else {
			$self->Error($call->Error);
		}
		undef($agent);
    });
}

=head2 plugins

=cut

sub plugins {
    my ($self) = @_;
    my $agent = Lim::Agent->Client;
    
    weaken($self);
    $agent->ReadPlugins(sub {
		my ($call, $response) = @_;
		
		if ($call->Successful) {
		    $self->cli->println(join("\t", qw(Name Description Module Version)));
		    foreach my $plugin (@{$response->{plugin}}) {
		        $self->cli->println(join("\t", $plugin->{name}, $plugin->{description}, $plugin->{module}, $plugin->{version}));
		    }
			$self->Successful;
		}
		else {
			$self->Error($call->Error);
		}
		undef($agent);
    });
}

=head1 AUTHOR

Jerry Lundström, C<< <lundstrom.jerry at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to L<https://github.com/jelu/lim/issues>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Lim

You can also look for information at:

=over 4

=item * Lim issue tracker (report bugs here)

L<https://github.com/jelu/lim/issues>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2012-2013 Jerry Lundström.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Lim::Agent::CLI

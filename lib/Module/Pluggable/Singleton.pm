package Module::Pluggable::Singleton;

use strict;
use warnings;
use Module::Pluggable::Object;
use Carp;

=head1 NAME

Module::Pluggable::Singleton - call/return single plugins on demand using shortened names

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    package MyPluggable;
    use Module::Pluggable::Singleton;

    my $plugins = MyPluggable->plugin;
    my $nick = MyPluggable->call('Robert','nickname',$person->full_name);

=head1 DESCRIPTION

=head1 METHODS

=head2 find($name)

Return the instance of the plugin with the given name

    $plugin = $logic->find('Bar');

=head2 plugin($name)

Return an array of the shortened available plugins or the full name of the
module when a short name is given

    my @plugin_short = $logic->plugin
    my $plugin_long = $logic->plugin($name);

=head2 call($plugin_name, $method, $params)

Using the plugin $plugin_name call $method with $params

    $rv = $logic->call($plugin_name, $method, $params)

=cut

sub import {
    my ($class, %opts) = @_;
    my $caller = (caller)[0];
    require Module::Pluggable;

    $opts{search_path} = "${caller}::Plugin";
    Module::Pluggable->import(
        package     => $caller,
        search_path => $opts{search_path},
        require => 1
    );

    my $namespace  = "${caller}::Plugin";
    my $base_class = "${caller}::Base";
    my $to_chop    = "${namespace}";
    my $plugin_for = { };
    my $instance_of = { };
    foreach my $plugin ($caller->plugins) {
        my $shortname = $plugin;
        $shortname =~ s/^${to_chop}:://;

# FIXME:
#        if (not $plugin->isa($base_class)) {
#            confess __PACKAGE__ .": plugin '$shortname' needs to implement "
#                ."'". $base_class ."'";
#        }

        if (exists $plugin_for->{$shortname}) {
            confess __PACKAGE__ .": Plugin already exists for '$shortname'";
        }

        $plugin_for->{$shortname} = $plugin;
    }

    my $find_sub = sub {
        my($self,$label) = @_;

        if (!defined $label) {
            die "Not provided name of plugin";
            return;
        }

        my $name = $plugin_for->{$label} || undef;
        if (!defined $name) {
            die "Not possible to load module '$label'";
        }


        # use an existing instance or create a new one.. and keep ref to it
        my $instance = $instance_of->{$label}
            || (defined $name ? $name->new() : undef);

        if ($instance && not defined $instance_of->{$label}) {
            $instance_of->{$label} = $instance;
        }

        return $instance;
    };

    my $plugin_sub = sub {
        my($self,$name) = @_;

        return keys %{$plugin_for} if (!defined $name);
        
        return defined $plugin_for->{$name}
            ? $plugin_for->{$name} : undef;
    };

    my $call_sub = sub {
        my $self = shift @_;
        my $label = shift @_;
        my $method = shift @_;

        if (!defined $label) {
            die __PACKAGE__ .": Plugin name not provided";
            return;
        }

        if (!defined $method) {
            die "Method name not provided";
            return;
        }


        my $instance = $self->find($label);
        if (!$instance->can($method)) {
            die "Cannot call '$method' on '$label' plugin";
        }

        return $instance->$method(@_);
    };

    no strict 'refs';
    no warnings qw(redefine prototype);

    *{"$caller\::find"} = $find_sub;
    *{"$caller\::plugin"} = $plugin_sub;
    *{"$caller\::call"} = $call_sub;

    return;
}

=head1 AUTHOR

Jason Tang, C<< <tang.jason.ch at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-module-pluggable-singleton at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Module-Pluggable-Singleton>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SEE ALSO

Module::Pluggable::Object

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Module::Pluggable::Singleton


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Module-Pluggable-Singleton>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Module-Pluggable-Singleton>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Module-Pluggable-Singleton>

=item * Search CPAN

L<http://search.cpan.org/dist/Module-Pluggable-Singleton/>

=back


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Jason Tang.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Module::Pluggable::Singleton


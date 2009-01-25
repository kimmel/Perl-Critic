##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/distributions/Perl-Critic/lib/Perl/Critic/Policy/Modules/ProhibitMultiplePackages.pm $
#     $Date: 2009-01-18 15:32:26 -0800 (Sun, 18 Jan 2009) $
#   $Author: clonezone $
# $Revision: 3007 $
##############################################################################

package Perl::Critic::Policy::Subroutines::ProhibitExit;

use 5.006001;
use strict;
use warnings;
use Readonly;

use Perl::Critic::Utils qw{ :severities :classification };
use base 'Perl::Critic::Policy';

#-----------------------------------------------------------------------------

our $VERSION = '1.095_001';

#-----------------------------------------------------------------------------

Readonly::Scalar my $DESC   => q{"exit" called from within a subroutine};
Readonly::Scalar my $EXPL   => q{Use "die" or "croak" instead};

#-----------------------------------------------------------------------------

sub supported_parameters { return ()                 }
sub default_severity     { return $SEVERITY_MEDIUM   }
sub default_themes       { return qw( core)          }
sub applies_to           { return 'PPI::Token::Word' }

#-----------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, $doc ) = @_;
    return if $elem ne 'exit';
    return if not is_function_call($elem);
    
    my $statement = $elem->statement();
    return if not $statement;
    
    my $parent = $statement->parent();
    return if not $parent;
    
    return if $parent->isa('PPI::Document');
    
    return $self->violation($DESC, $EXPL, $elem);
}

#-----------------------------------------------------------------------------
1;

__END__

#-----------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::Subroutines::ProhibitExit - Don't use exit() to throw exceptions from subroutines.


=head1 AFFILIATION

This Policy is part of the core L<Perl::Critic|Perl::Critic>
distribution.


=head1 DESCRIPTION

This Policy is a more extreme form of <Perl::Critic::Policy::Modules::ProhibitExit>,
A common newbie mistake is to use the C<exit> function when they encounter some
kind error condition in their subroutines.  But there is no way to trap an C<exit> call
to possibly recover from the error, which makes it difficult for others to use your 
subroutine.  Instead, you should be using C<die> or C<croak>, which can be trapped.  Or
better yet, you can use a real exception mechanism, such as L<Class::Exception>.

So this Policy emits a violation any time that C<exit> is called from within a subroutine.

To be fair, there are certain occasions where calling C<exit> from a subroutine is
perfectly reasonable (C<Pod::Usage::pod2usage> is a very good example).  In those cases,
you should clearly document the behavior and add a C<"## no critic"> annotation
for this Policy.


=head1 SEE ALSO

L<Perl::Critic::Policy::Modules::ProhibitExit>

L<Perl::Critic::Policy::ErrorHandling::RequireCarping>


=head1 CONFIGURATION

This Policy is not configurable except for the standard options.


=head1 AUTHOR

Jeffrey Ryan Thalhammer <thaljef@cpan.org>


=head1 COPYRIGHT

Copyright (c) 2005-2009 Jeffrey Ryan Thalhammer.  All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.  The full text of this license
can be found in the LICENSE file included with this module.

=cut

#############################################################################
# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
# --
# Kernel/Language/de_EmailDev.pm - the German translation of EmailDev
# Copyright (C) 2016 Perl-Services.de, http://perl-services.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_EmailDev;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation} || {};

    # Custom/Kernel/Output/HTML/Templates/Standard/AdminEmailDevList.tt
    $Lang->{'Emails'} = '';
    $Lang->{'List'} = '';
    $Lang->{'Subject'} = '';
    $Lang->{'From'} = '';
    $Lang->{'To'} = '';
    $Lang->{'Date'} = '';

    # Custom/Kernel/Output/HTML/Templates/Standard/AdminEmailDevShow.tt
    $Lang->{'Actions'} = '';
    $Lang->{'Go to overview'} = '';
    $Lang->{'Email'} = '';

    # Kernel/Config/Files/EmailDev.xml
    $Lang->{'Path to the directory where the mails are saved to (relative to $OTRS_HOME).'} =
        'Pfad zum Verzeichnis in das die Mails gespeichert werden (Relativ zu $OTRS_HOME).';
    $Lang->{'Frontend module registration for the development emails interface.'} = '';
    $Lang->{'List and show development emails.'} = '';
    $Lang->{'Development emails'} = '';
}

1;

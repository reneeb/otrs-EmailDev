# --
# Kernel/Language/hu_EmailDev.pm - the Hungarian translation of EmailDev
# Copyright (C) 2016 Perl-Services.de, http://perl-services.de/
# Copyright (C) 2016 Balázs Úr, http://www.otrs-megoldasok.hu
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::hu_EmailDev;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation} || {};

    # Custom/Kernel/Output/HTML/Templates/Standard/AdminEmailDevList.tt
    $Lang->{'Emails'} = 'E-mailek';
    $Lang->{'List'} = 'Lista';
    $Lang->{'Subject'} = 'Tárgy';
    $Lang->{'From'} = 'Feladó';
    $Lang->{'To'} = 'Címzett';
    $Lang->{'Date'} = 'Dátum';

    # Custom/Kernel/Output/HTML/Templates/Standard/AdminEmailDevShow.tt
    $Lang->{'Actions'} = 'Műveletek';
    $Lang->{'Go to overview'} = 'Ugrás az áttekintőhöz';
    $Lang->{'Email'} = 'E-mail';

    # Kernel/Config/Files/EmailDev.xml
    $Lang->{'Path to the directory where the mails are saved to (relative to $OTRS_HOME).'} =
        'Útvonal ahhoz a könyvtárhoz, ahova az e-mailek mentve lesznek (relatívan az $OTRS_HOME könyvtártól).';
    $Lang->{'Frontend module registration for the development emails interface.'} =
        'Előtétprogram-modul regisztráció a fejlesztői e-mailek felülethez.';
    $Lang->{'List and show development emails.'} = 'Fejlesztői e-mailek felsorolása és megjelenítése.';
    $Lang->{'Development emails'} = 'Fejlesztői e-mailek';
}

1;

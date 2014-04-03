# --
# Kernel/System/Email/EmailDev.pm - save mails to disk
# Copyright (C) 2014 Perl-Services.de, http://perl-services.de
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Email::EmailDev;

use strict;
use warnings;

use File::Temp qw(tempdir);
use File::Path qw(make_path);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (qw(ConfigObject LogObject EncodeObject MainObject TimeObject)) {
        die "Got no $Needed" if ( !$Self->{$Needed} );
    }

    # debug
    $Self->{Debug} = $Param{Debug} || 0;

    # check if temp dir exists, otherwise use global temp dir
    my $Dir = $Self->{ConfigObject}->Get( 'Home' ) . '/' . $Self->{ConfigObject}->Get( 'EmailDev::Path' );
    if ( !-e $Dir ) {
        make_path( $Dir );
    }

    if ( !-e $Dir ) {
        $Dir = tempdir( CLEANUP => 0 );
    }

    $Self->{Dir} = $Dir;

    return $Self;
}

sub Check {
    my ( $Self, %Param ) = @_;

    return ( Successful => 1 );
}

sub Send {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Header Body ToArray)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # encode utf8 header strings (of course, there should only be 7 bit in there!)
    $Self->{EncodeObject}->EncodeOutput( $Param{Header} );

    # encode utf8 body strings
    $Self->{EncodeObject}->EncodeOutput( $Param{Body} );

    # send data
    my $To       = join ', ', @{ $Param{ToArray} };
    my $From     = $Param{From} // '';
    my $Time     = $Self->{TimeObject}->SystemTime();
    my $MailFile = $Self->{MainObject}->FileWrite(
        Filename   => "Mail_${From}_${To}_${Time}.eml",
        Directory  => $Self->{Dir},
        Content    => \"${ $Param{Header} }\n${ $Param{Body} }",
        Mode       => 'binmode',
        Type       => 'Local',
        Permission => 644,
    );

    # debug
    if ( $Self->{Debug} > 2 ) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message  => "Saved email to '$To' from '$From' as $MailFile.",
        );
    }

    return 1;
}

1;

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

our @ObjectDependencies = qw(
    Kernel::Config
    Kernel::System::Log
    Kernel::System::Encode
    Kernel::System::Main
    Kernel::System::Time
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # debug
    $Self->{Debug} = $Param{Debug} || 0;

    # check if temp dir exists, otherwise use global temp dir
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $Dir = $ConfigObject->Get( 'Home' ) . '/' . $ConfigObject->Get( 'EmailDev::Path' );
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

    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');
    my $EncodeObject = $Kernel::OM->Get('Kernel::System::Encode');
    my $TimeObject   = $Kernel::OM->Get('Kernel::System::Time');
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

    # check needed stuff
    for my $Needed (qw(Header Body ToArray)) {
        if ( !$Param{$Needed} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # encode utf8 header strings (of course, there should only be 7 bit in there!)
    $EncodeObject->EncodeOutput( $Param{Header} );

    # encode utf8 body strings
    $EncodeObject->EncodeOutput( $Param{Body} );

    # send data
    my $To       = join ', ', @{ $Param{ToArray} };
    my $From     = $Param{From} // '';
    my $Time     = $TimeObject->SystemTime();
    my $Random   = sprintf "%04d", int rand 1000;
    my $Filename = $MainObject->FilenameCleanUp( Filename => "Mail_${From}_${To}_${Time}_${Random}.eml" );

    my $MailFile = $MainObject->FileWrite(
        Filename   => $Filename,
        Directory  => $Self->{Dir},
        Content    => \"${ $Param{Header} }\n${ $Param{Body} }",
        Mode       => 'binmode',
        Type       => 'Local',
        Permission => 644,
    );

    # debug
    if ( $Self->{Debug} > 2 ) {
        $LogObject->Log(
            Priority => 'notice',
            Message  => "Saved email to '$To' from '$From' as $MailFile.",
        );
    }

    return 1;
}

1;

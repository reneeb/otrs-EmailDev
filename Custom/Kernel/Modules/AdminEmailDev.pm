# --
# Kernel/Modules/AdminEmailDev.pm - list and show development emails
# Copyright (C) 2015 Perl-Services.de, http://perl-services.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminEmailDev;

use strict;
use warnings;

use File::Spec;
use File::Basename;

our @ObjectDependencies = qw(
    Kernel::Config
    Kernel::Output::HTML::Layout
    Kernel::System::Web::Request
    Kernel::System::Main
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my @Params = (qw(Subaction Filename));

    my %GetParam;
    for my $ParamName (@Params) {
        $GetParam{$ParamName} = $ParamObject->GetParam( Param => $ParamName ) || '';
    }

    my $Content = '';
    if ( $GetParam{Subaction} eq 'Show' ) {
        my $Mail = $Self->_MailGet( %GetParam );
        $Content = $LayoutObject->Output(
            TemplateFile => 'AdminEmailDevShow',
            Data         => { Text => $Mail },
        );
    }
    else {
        my @Mails = $Self->_MailList();

        for my $Mail ( @Mails ) {
            my %Info = $Self->_MailInfo( File => $Mail );
            $LayoutObject->Block(
                Name => 'Mail',
                Data => \%Info,
            );
        }

        $Content = $LayoutObject->Output(
            TemplateFile => 'AdminEmailDevList',
        );
    }

    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();
    $Output .= $Content;
    $Output .= $LayoutObject->Footer();
    return $Output;
}

sub _MailList {
    my ($Self, %Param) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

    my $Directory = File::Spec->catdir(
        $ConfigObject->Get('Home'),
        $ConfigObject->Get('EmailDev::Path'),
    );

    my @Mails = $MainObject->DirectoryRead(
        Directory => $Directory,
        Filter    => '*.eml',
    );

    return @Mails;
}

sub _MailInfo {
    my ($Self, %Param) = @_;

    return if !$Param{File};

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $Content = $MainObject->FileRead( Location => $Param{File} );

    my %Info = ( Filename => basename( $Param{File} ) );

    for my $Header ( qw(From To Subject Date) ) {
        my ($Value) = ${$Content} =~ m{ ^ $Header: \s+ ([^\n]*) }xms;
        $Info{$Header} = $Value;
    }

    return %Info;
}

sub _MailGet {
    my ($Self, %Param) = @_;

    return if !$Param{Filename};

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $MainObject   = $Kernel::OM->Get('Kernel::System::Main');

    my $Directory = File::Spec->catdir(
        $ConfigObject->Get('Home'),
        $ConfigObject->Get('EmailDev::Path'),
    );

    my $Filename = $MainObject->FilenameCleanUp( Filename => $Param{Filename} );

    my $Content = $MainObject->FileRead(
        Directory => $Directory,
        Filename  => $Filename,
    );

    return ${$Content};
}

1;

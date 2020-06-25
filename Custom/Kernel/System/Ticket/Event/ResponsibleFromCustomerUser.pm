# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Ticket::Event::ResponsibleFromCustomerUser;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::CustomerUser',
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Data UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }
    for my $Needed (qw(TicketID)) {
        if ( !$Param{Data}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed! in Data",
            );
            return;
        }
    }
    
    my $ResponsibleField = $Param{Config}->{CustomerUserResponsibleField};
    
    # get customer user data from ticket
    my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
        TicketID => $Param{Data}->{TicketID},
    );

    return if !%Ticket;

    my %CustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
        User => $Ticket{CustomerUserID},
    );

    return if !%CustomerUserData;
    return if !$CustomerUserData{'DynamicField_'.$ResponsibleField};
    
    my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketResponsibleSet(
        TicketID  => $Param{Data}->{TicketID},
        NewUser   => $CustomerUserData{'DynamicField_'.$ResponsibleField},
        UserID    => 1,
    );
            
}

1;

package Penguin::Channel::TCP::Client;

use Penguin::Channel::TCP;

use Penguin::Frame::Code;
use Penguin::Frame::Data;

use IO::Socket;

@ISA = qw( Penguin::Channel::TCP );

$VERSION = "4.0";

sub new {
    my ($class, %args) = @_;

    $self = {};
    $self->{'Peer'} = $args{'Peer'};
    $self->{'Port'} = ($args{'Port'} or 8118);
    $self->{'Status'} = 'not connected';

    bless $self, $class;
}

sub open {
    my ($self, %args) = @_;
    
    $self->{'Socket'} = new IO::Socket Peer => $self->{'Peer'},
                                       Port => $self->{'Port'},
                                      Proto => 'tcp';
    if ($self->{'Socket'} eq undef) { 
        die "can't get a socket! $!";
    }
    $self->{'Socket'}->autoflush();
    $self->{'Status'} = 'connected';

    1;
}
1;

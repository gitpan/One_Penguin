package Penguin::Compartment;

use Safe;

sub new {
    my ($class, %args) = @_;
    $self = { 'compartment' => new Safe,
              'shares' => { },
              'opset' => Safe::empty_opset,
            };
    $self->{'compartment'}->share('% { $self->shares }');
    bless $self, $class;
}

sub register {
    my ($self, %args) = @_;
    my $share = $args{'Share'};
    my $sharedesc = $args{'Description'};
    $self->{'shares'}->{$share} = $sharedesc;
    $self->{'compartment'}->share_from(scalar(caller), [$args{'Share'}]);
    1;
}

sub unregister {
    my ($self, %args) = @_;
    my ($share) = $args{'Share'};
    undef $self->{'shares'}->{$share};
    # reminder to myself: bother tim about unshare and clear_share.
    1;
}

sub initialize {
    my ($self, %args) = @_;
    my $opstring = $args{'Operations'} || "";
    $self->{'compartment'}->permit_only(Safe::ops_to_opset(split(/ +/, $opstring)));
    1;
}

sub execute {
    my ($self, %args) = @_;
    $code = $args{'Code'};
    $self->{'compartment'}->reval($code);
}
1;

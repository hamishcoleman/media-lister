package SeenList;
use warnings;
use strict;
#
# Keep track of which files have been watched
#

sub new {
    my $class = shift;
    my $self = {};
    bless($self, $class);
    return $self;
}

# TODO
# - persistance across runs
# -- filename to save state

sub seen {
    my $self = shift;
    my $name = shift;
    my $value = shift;

    if (defined($value)) {
        $self->{seen}{$name} = $value;
    }

    return $self->{seen}{$name};
}

sub toggle {
    my $self = shift;
    my $name = shift;

    my $new = not $self->seen($name);
    return $self->seen($name,$new);
}

1;

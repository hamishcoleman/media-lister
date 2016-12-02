package ListEntry::PopValues;
use warnings;
use strict;
#
# A virtual ".."
#

sub new {
    my $class = shift;
    my $self = {};
    bless($self, $class);

    return $self;
}

sub RenderLabel {
    my $self = shift;

    my $watched = ' ';
    my $basename = '..';

    return $watched.' '.$basename;
}

sub RenderValue {
    my $self = shift;
    my $listbox = shift;

    $listbox->PopValues();
}

1;


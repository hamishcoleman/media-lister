package ListEntry::File;
use warnings;
use strict;
#
# Represent a file as an object that can go in a list widget
#

use File::Basename;

sub new {
    my $class = shift;
    my $self = {};
    bless($self, $class);

    my $filename = shift;
    # TODO - file must exist
    $self->{filename} = $filename;

    $self->{cui} = shift;

    return $self;
}

sub RenderLabel {
    my $self = shift;

    # TODO - actually have a database of watched files
    my $watched = ' ';
    $watched = "\N{CHECK MARK}";
    my $basename = basename($self->{filename});

    return $watched.' '.$basename;
}

sub RenderValue {
    my $self = shift;
    my $listbox = shift;

    # FIXME - if raspberry pi, use omxplayer
    # omxplayer -o hdmi --blank --sid 10 %p

    $self->{cui}->leave_curses();
    system("mplayer '".$self->{filename}."'");
    $self->{cui}->reset_curses();
}

1;


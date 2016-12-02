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

sub seenlist {
    my $self = shift;
    $self->{seenlist} = shift;
}

sub toggleseen {
    my $self = shift;
    return undef if (!defined($self->{seenlist}));
    return $self->{seenlist}->toggle($self->{filename});
}

sub seen {
    my $self = shift;
    return undef if (!defined($self->{seenlist}));
    return $self->{seenlist}->seen($self->{filename},shift);
}

sub RenderLabel {
    my $self = shift;

    # TODO - actually have a database of watched files
    my $watched = ' ';
    if (defined($self->{seenlist})) {
        if ($self->{seenlist}->seen($self->{filename})) {
            $watched = "\N{CHECK MARK}";
        }
    }
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

    $self->seen(1);
    # TODO - could just render the one label
    $listbox->RenderLabels();
    $listbox->schedule_draw(1);

}

1;


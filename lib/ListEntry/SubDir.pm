package ListEntry::SubDir;
use warnings;
use strict;
#
# Each instance is a subdir
#

use File::Basename;

use ListEntry::File;
use ListEntry::PopValues;

sub new {
    my $class = shift;
    my $self = {};
    bless($self, $class);

    my $subdir = shift;
    # TODO - file must exist
    $self->{subdir} = $subdir;

    $self->{cui} = shift;

    return $self;
}

sub seenlist {
    my $self = shift;
    $self->{seenlist} = shift;
}

sub RenderLabel {
    my $self = shift;

    my $watched = ' ';
    my $basename = basename($self->{subdir});

    return $watched.' '.$basename.'/';
}

sub RenderValue {
    my $self = shift;
    my $listbox = shift;

    my @array;
    push @array, ListEntry::PopValues->new();

    for (sort glob($self->{subdir}.'/*')) {
        my $object;
        if ( -d $_ ) {
            $object = ListEntry::SubDir->new($_,$self->{cui});
        } else {
            $object = ListEntry::File->new($_,$self->{cui});
        }
        $object->seenlist($self->{seenlist});
        push @array, $object;
    }

    $listbox->PushValues($self->{subdir});
    $listbox->values(\@array);
    $listbox->RenderLabels();
    $listbox->UseLastSelection($self->{subdir});
}

1;


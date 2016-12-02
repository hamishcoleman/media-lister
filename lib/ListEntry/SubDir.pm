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

    for (glob($self->{subdir}.'/*')) {
        if ( -d $_ ) {
            push @array, ListEntry::SubDir->new($_,$self->{cui});
        } else {
            push @array, ListEntry::File->new($_,$self->{cui});
        }
    }

    $listbox->PushValues();
    $listbox->values(\@array);
    $listbox->RenderLabels();
}

1;


package ListEntry::SubDir;
use warnings;
use strict;
#
# Each instance is a subdir
#

use File::Basename;
use File::Glob ':bsd_glob';

use ListEntry::File;
use ListEntry::PopValues;

sub new {
    my $class = shift;
    my $self = {};
    bless($self, $class);

    my $subdir = shift;
    # TODO - file must exist
    $self->{subdir} = $subdir;

    return $self;
}

sub new_from_name {
    my $class = shift;
    my $filename = shift;

    my $object;
    if ( -d $filename ) {
        $object = $class->new($filename);
    } else {
        $object = ListEntry::File->new($filename);
    }
    return $object;
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

    for (bsd_glob($self->{subdir}.'/*',GLOB_TILDE|GLOB_NOCHECK)) {
        my $object = ListEntry::SubDir->new_from_name($_);
        $object->seenlist($self->{seenlist});
        push @array, $object;
    }

    $listbox->PushValues($self->{subdir});
    $listbox->values(\@array);
    $listbox->RenderLabels();
    $listbox->UseLastSelection($self->{subdir});
}

1;


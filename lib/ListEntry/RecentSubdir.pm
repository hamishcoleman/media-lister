package ListEntry::RecentSubdir;
use warnings;
use strict;
#
# A list of recent subdirs
#

use ListEntry::PopValues;
use ListEntry::SubDir;

sub new {
    my $class = shift;
    my $self = {};
    bless($self, $class);

    return $self;
}

sub seenlist {
    my $self = shift;
    $self->{seenlist} = shift;
}

sub RenderLabel {
    my $self = shift;

    my $watched = ' ';
    my $basename = 'Recent Subdirs';

    return $watched.' '.$basename;
}

sub RenderValue {
    my $self = shift;
    my $listbox = shift;
    my $seenlist = $self->{seenlist};
    return if (!defined($seenlist));

    my $recent = $seenlist->{recent_dirs};

    my @array;
    push @array, ListEntry::PopValues->new();

    my @recent = sort { $recent->[$b] cmp $recent->[$a] } keys(%{$recent});
    for (@recent) {
        my $object = ListEntry::SubDir->new_from_name($_);
        $object->seenlist($seenlist);
        $object->use_basename(0);
        push @array, $object;
    }

    $listbox->PushValues($self->{subdir});
    $listbox->values(\@array);
    $listbox->RenderLabels();
    $listbox->UseLastSelection('Recent Subdirs');
    # FIXME - need a generic "string_id()" method in the interface
}

1;


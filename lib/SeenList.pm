package SeenList;
use warnings;
use strict;
#
# Keep track of which files have been watched
#

use File::Path qw(make_path);
use File::Basename;
use FileHandle;

sub new {
    my $class = shift;
    my $self = {};
    bless($self, $class);
    $self->replay_log();
    return $self;
}

sub _validate_path {
    my $self = shift;
    my $dirname = $ENV{'HOME'}.'/.cache/media-lister';
    make_path($dirname);
    my $filename = $dirname.'/seenlog';
    return $filename;
}

sub log {
    my $self = shift;
    my $name = shift;
    my $value = shift;

    # open the file
    if (!defined($self->{fh})) {
        my $filename = $self->_validate_path();
        my $fh = FileHandle->new($filename,"a");
        return undef if (!defined($fh));
        $self->{fh} = $fh;
    }

    if (!$value) {
        $value = 0;
    }
    $self->{fh}->write($value."\t".$name."\n");
    $self->{fh}->flush();
}

sub replay_log {
    my $self = shift;
    my $filename = $self->_validate_path();
    my $fh = FileHandle->new($filename,"r");
    return undef if (!defined($fh));
    while (<$fh>) {
        chomp;
        if ($_ =~ /^([^\t]+)\t(.*)$/) {
            $self->seen($2,$1,'nolog');
        }
    }
}

# TODO
# - persistance across runs
# -- filename to save state

sub seen {
    my $self = shift;
    my $name = shift;
    my $value = shift;
    my $nolog = shift;

    if (defined($value)) {
        $self->{seen}{$name} = $value;

        # Quick and dirty "recent subdirs" tracker
        my $dirname = dirname($name);
        $self->{recent_dirs}{$dirname} = $self->{recent_dirs_nr}++;

        if (!defined($nolog)) {
            $self->log($name,$value);
        }
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

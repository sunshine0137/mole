package EsopLib;

use 5.010001;
use strict;
use warnings;
# use Smart::Comments;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use EsopLib ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
    read_mole_config
    read_plugin_config
    read_file_recvlst
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
    read_mole_config
    read_plugin_config
    read_file_recvlst
);

our $VERSION = '0.01';

our $ESOPDIR = '/usr/local/esop/agent';
our $MOLEDIR = $ESOPDIR . '/mole';
our $MOLECONFDIR = $MOLEDIR . '/conf';
our $MOLECFG = $MOLECONFDIR . '/.mole.ini';

# Preloaded methods go here.

sub read_mole_config {
    return &read_ini($_[0],$_[1],$MOLECFG);
}

sub read_plugin_config {
    return &read_ini($_[0],$_[1],$MOLECONFDIR . '/' . $_[0] . '.ini');
}

sub read_ini {
    my ($section,$key,$file) = @_;

    unless (-f $file && -s $file) {
	return undef;
    }
	
    unless ($section && $key) {
	return undef;
    }

    unless (open FH, "<", $file) {
	return undef;
    }

    my $flag = 0;
    while (<FH>) {
	if (m/\A\s*\[\s*($section)\s*\]\s*\Z/) {
		$flag = 1;
		next;
	}
	if (m/\A\s*\[\s*(\w+)\s*\]\s*\Z/) {
		last if $flag;
	}
	if (m/\A\s*$key\s*=\s*(.+)\s*\Z/) {
		if ($flag) {
			### $&
			### $`
			### $'
			my $value = $1;
			$value =~ s/\A\s*//g;
			$value =~ s/\s*\Z//g;
			close FH;
			return $value;
		}
	}
    }
    close FH;
    return undef;	# this is important, otherwise return 1
}

sub read_file_recvlst {
    my ($config,$comment) = @_;
	
    unless ($config) {
	return undef;
    }
	
    $config =~ s/\A\s*file://gi;
    unless ($config =~ m/\A\//) {
	my $basedir = '/usr/local/esop/agent/mole/';
	$config = $basedir . $config;
    }

    unless (open FH, "<", $config) {
	return undef;
    }

    unless($comment) {
	$comment = '#';
    }

    my $result = undef;
    while (<FH>) {
	next if (m/\A\s*\Q$comment\E/);
	next if (m/\A\s*\Z/);
	chomp;
	$result .= $_ . ' ';
    }

    unless ($result) {
    	return undef;
    } else {
	return $result;
    }
}

1;
__END__
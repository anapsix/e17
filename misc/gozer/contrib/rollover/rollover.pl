#!/usr/bin/perl -w

use strict;
use vars qw[ $template @includes ];

my $VERSION="0.2";
my $DEBUG=0;

&print_usage_and_exit unless (@ARGV);
foreach ("-?","-h","--help") {
	&print_usage_and_exit if ($ARGV[0] eq $_);
}

$template = shift @ARGV;
$template = "rollover.tmpl" unless $template;

my @images = ();
my %cfg = ( ":output"          => "out.html",
         ":quiet"           => "",

         ":prefix"          => "<!-- Generated by rollover.pl with gozer -->\n\n",
         ":delimiter"       => "<BR>",
         ":suffix"          => "",

         ":border"          => "0",
         ":image_format"    => "jpg",

         ":convert_to"      => "",
         ":convert_purge"   => "",

#        NORMAL IMGAE DEFAULTS
         ":image_prefix"         => "images/", 
         ":prefix_dontcreate"    => "", 
         ":image_suffix"         => "", 
         ":bg_color",            => "",
         ":bg_image",            => "",
         ":bg_nocrop",           => "",
         ":fg_color",            => "",
         ":font",                => "",
         ":style",               => "",
         ":gozer_flags",           => "",

#        ROLLOVER (HILITED) IMAGE DEFAULTS
         ":ro_image_prefix"      => "images/", 
         ":ro_prefix_dontcreate" => "", 
         ":ro_image_suffix"      => "-hilited", 
         ":ro_bg_color",         => "",
         ":ro_bg_image",         => "",
         ":ro_bg_nocrop",        => "",
         ":ro_fg_color",         => "",
         ":ro_font",             => "",
         ":ro_style",            => "",
         ":ro_gozer_flags",        => ""
);

#open TMPL, "$template" or die "could'nt open template file";
#
#LOOP: while (<TMPL>) {
#	goto LOOP if (/^#/ or /^$/);
#	/(.*?),[ \t]+(.*)$/;
#	print "$1 = $2\n" if $DEBUG;
#	$cfg{$1}=$2;
#	push @images, $1 unless (/^:/);
#}
&parse_template_file($template);

unless ($cfg{':output'} eq "|") {
	open OUT, ">$cfg{':output'}" or die "couldn't open output file - $!";
	print STDERR "Saving to \"$cfg{':output'}\".\n" unless ($cfg{':quiet'});
}

my $ostr = "$cfg{':prefix'}";
if ($cfg{':output'} eq "|") {
	print "$ostr";
} else {
	print OUT "$ostr";
}

foreach (@images) {
    my $converted_normal;
    my $converted_hilite;


    unless(-e "$cfg{':image_prefix'}" && !$cfg{':prefix_dontcreate'}) {
       mkdir("$cfg{':image_prefix'}", 0755) or die "Cannot create image prefix - $cfg{':image_prefix'} : $!\n";
    }

    unless(-e "$cfg{':ro_image_prefix'}" && !$cfg{':ro_prefix_dontcreate'}) {
       mkdir("$cfg{':ro_image_prefix'}", 0755) or die "Cannot create image prefix - $cfg{':ro_image_prefix'} : $!\n";
    }

	next if /^:/;
	print STDERR "Generating images for \"$_\"\n" unless ($cfg{':quiet'});
	my $normal = "$cfg{':image_prefix'}$_$cfg{':image_suffix'}.$cfg{':image_format'}";
	my $hilite = "$cfg{':ro_image_prefix'}$_$cfg{':ro_image_suffix'}.$cfg{':image_format'}";
	if ($cfg{':convert_to'}) {
		$converted_normal = "$cfg{':image_prefix'}$_$cfg{':image_suffix'}.$cfg{':convert_to'}";
		$converted_hilite = "$cfg{':ro_image_prefix'}$_$cfg{':ro_image_suffix'}.$cfg{':convert_to'}";
	}

	# init gozer options
	my $gozer_opts = "";
	$gozer_opts .= "-b \"$cfg{':bg_color'}\" "  if ($cfg{":bg_color"});
	$gozer_opts .= "-G \"$cfg{':bg_image'}\" "  if ($cfg{':ro_bg_image'});
	$gozer_opts .= "-0 "                        if ($cfg{':bg_nocrop'});
	$gozer_opts .= "-f \"$cfg{':fg_color'}\" "  if ($cfg{":fg_color"});
	$gozer_opts .= "-F \"$cfg{':font'}\" "      if ($cfg{":font"});
	$gozer_opts .= "-s \"$cfg{':style'}\" "     if ($cfg{":style"});
	$gozer_opts .= " $cfg{':gozer_flags'} "       if ($cfg{":gozer_flags"});
	#system "gozer -t \"$_\" $gozer_options $cfg{:image_prefix}/$_-0.png";
	if ($DEBUG) {
		print STDERR "gozer -t \"$_\" $gozer_opts $normal\n";
		print STDERR "convert $normal $converted_normal\n" if ($cfg{':convert_to'});
		print STDERR "rm -f $normal\n" if ($cfg{':convert_purge'});
	} else {
		system "gozer -t \"$_\" $gozer_opts $normal\n";
		system "convert $normal $converted_normal\n" if ($cfg{':convert_to'});
		system "rm -f $normal\n" if ($cfg{':convert_purge'});
	}

	$gozer_opts = "";
	$gozer_opts .= "-b \"$cfg{':ro_bg_color'}\" "  if ($cfg{':ro_bg_color'});
	$gozer_opts .= "-G \"$cfg{':ro_bg_image'}\" "  if ($cfg{':ro_bg_image'});
	$gozer_opts .= "-0 "                           if ($cfg{':ro_bg_nocrop'});
	$gozer_opts .= "-f \"$cfg{':ro_fg_color'}\" "  if ($cfg{':ro_fg_color'}) ;
	$gozer_opts .= "-F \"$cfg{':ro_font'}\" "      if ($cfg{':ro_font'});
	$gozer_opts .= "-s \"$cfg{':ro_style'}\" "     if ($cfg{":ro_style"});
	$gozer_opts .= " $cfg{':ro_gozer_flags'} "       if ($cfg{':ro_gozer_flags'});
	#system "gozer -t \"$_\" $gozer_options $cfg{:image_prefix}/$_-0.png";
	if ($DEBUG) {
		print STDERR "gozer -t \"$_\" $gozer_opts $hilite\n";
		print STDERR "convert $hilite $converted_hilite\n" if ($cfg{':convert_to'});
		print STDERR "rm -f $hilite\n" if ($cfg{':convert_purge'});
	} else {
		system "gozer -t \"$_\" $gozer_opts $hilite\n";
		system "convert $hilite $converted_hilite\n" if ($cfg{':convert_to'});
		system "rm -f $hilite\n" if ($cfg{':convert_purge'});
	}

	if ($cfg{':convert_to'})	{
		$normal = $converted_normal;
		$hilite = $converted_hilite;
	}
	my $imname = $_ . "Image";
	$imname =~ s/[\., \t]/_/g;
	$ostr = "<a href=\"$cfg{$_}\"
	onMouseOver=\"document.$imname.src = '$hilite'; return true;\"
	onMouseOut=\"document.$imname.src = '$normal'; return true;\"
><IMG Name=\"$imname\" SRC=\"$normal\" BORDER=\"$cfg{':border'}\"
	HSPACE=\"0\" VSPACE=\"0\" ALT=\"$cfg{$_}\"></a>\n$cfg{':delimiter'}\n";
	if ($cfg{':output'} eq "|") {
		print "$ostr";
	} else {
		print OUT "$ostr";
	}
}

$ostr = "$cfg{':suffix'}";
if ($cfg{':output'} eq "|") {
	print "$ostr";
} else {
	print OUT "$ostr";
	close OUT;
}


sub print_usage_and_exit() {
	print "rollover $VERSION, by Paul Duncan <pabs\@pablotron.org>
Usage:
	rollover.pl <template file>
";
	exit 0;
}
sub parse_template_file() {
	local $template = shift;
	local @includes = ();

	open TMPL, "$template" or die "could'nt open template file";

	while (<TMPL>) {
		next if (/^#/ or /^$/);
		/(.*?),[ \t]+(.*)$/;
		print "$1 = $2\n" if $DEBUG;
		if ($1 eq ":include")	{
			push @includes, $2;
		} else {
			$cfg{$1}=$2;
		}
		push @images, $1 unless (/^:/);
	}
	&parse_template_file($_) foreach (@includes);
	close TMPL;
}

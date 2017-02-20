#! /usr/bin/perl
# scan JSON
$ver_name = "?";
$JSON="manifest.json";
open(JSON) || die "error :$!";
while (<JSON>) {
	$ver_name = $1 if /^\s*"version_name": "(.+)",/;
	$version  = $1 if /^\s*"version": "(.+)",/;
}
$datetime = qx/date -I/; chomp $datetime;
print "vername :[$ver_name]\n";
print "version :[$version]\n";
print "datetime:[$datetime]\n";
system qq!perl -p -i.bak -e 's/^\\* v\\d.+/* $ver_name: $datetime/ if 2..5;' README.md!;
system qq!git ci -am 'setver $version' && git tag -f v$version && cp README.md gh-pages/index.md && cd gh-pages && bash autolink.sh && git ci -am 'rel v$version'!;

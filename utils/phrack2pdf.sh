#!/usr/bin/env bash

##################################################
# @jaimecgomezz
#
# downloads phrack issues and renders them as pdfs
#
# dependencies:
#   - enscript
#   - wget
#   - tar
#   - ghostscript
#
# heavily inspired, to say the least, by
# @alanvivona phrack2pdf.fish script
########################################### script
PHRACK_DIR="phracks"
##################################################

download_and_print() {
	article="$1"

	echo "========> ARTICLE $article"

	mkdir "$article"
	cd "$article" || exit

	wget --quiet -c "http://phrack.org/archives/tgz/$article.tar.gz"
	tar zxf "$article.tar.gz"
	find ./*.txt -print0 | xargs -0 enscript -p "$article.ps"
	ps2pdf "$article.ps" "../$article.pdf"

	cd ..
	rm -rf "$article"
}

from="$1"
to="$2"

[ -z "$from" ] && from=1
[ -z "$to" ] && to=70

echo "========> Getting articles from $from to $to"

rm -rf "$PHRACK_DIR"
mkdir "$PHRACK_DIR"
cd "$PHRACK_DIR" || exit

for article in $(seq $from $to); do
	download_and_print "phrack$article"
done

#!/usr/bin/sed -f
# 20/01/05 - little.mouth@soon.com - GPL
# sed script to generate part of the body of an XHTML 1.0 document from
# VulSearch Latin source files.
#
# Requirements: sed
#
# Usage: sed -f makehtml.sed SOURCEFILE
# where SOURCEFILE is the Latin source file to convert
#
# On non-Windows systems you may need to export LANG=C before running sed
#
# Output:
# source file with appropriate XHTML tags added
#
# See README.html in latest.zip for a description of the source format (see
# also comments below).

#first deal with < > / \
s/</%/g
s/>/$/g
s+/+<br />+g
s/%/<span class="speaker">/g
s/\$/.<\/span> /g
s/\\/<br \/><br \/>/g

#now special characters
s/\ë/\&euml;/g
s/\æ/\&aelig;/g
s/\œ/\&oelig;/g
s/\Æ/\&AElig;/g
s/ \([:;!?]\)/\&nbsp;\1/g

#===
#verse numbering
#first move [ at start of verse text to start of line
s/\([1-9][0-9:]* \)\[/[\1/

#now do chapter numbers
s/\(\[*\)\([0-9][0-9]*\):\(1\) /<\/div><div class="chapter"><span class="chapter-num">\2<\/span>\1 <span class="vn" id="x\2_\3">\3<\/span>\&nbsp;/

#no need to close a previous div at the start of ch. 1
s/\(\[*\)<\/div>\(<div class="chapter"><span class="chapter-num">1<\)/\1\2/

#finally do the other verses
s/\(\[*\)\([0-9][0-9]*\):\([0-9][0-9]*\) /\1<span class="vn" id="x\2_\3">\3<\/span>\&nbsp;/
#===

#finally [ ]
s/\(<div class="chapter"><span class="chapter-num">[0-9]*<\/span>\)\[/\1<div class="poetrystartchapter">/
s/\[/<div class="poetry">/g
s/\]/<\/div>/g

#special arrangments for Lam and Sir, which have prologues
s/\(<div class="chapter"><span class="chapter-num">1<\/span> \)\(<span class="vn" id="x1_1">1<\/span> \)\(<span class="speaker">Prologus.<\/span> \)\(.*\)\(<div class="poetry">\)\(.*$\)/<div class="proltitle">Prologus.<\/div><div class="chapter">\4<\/div>\1\5\2\6/

#add a close div to the last verse
$s/$/<\/div>/

#!/bin/bash

pre="../pdf"
for i in `ls $pre`;
do
	txt=${i/%.pdf/.txt}
	pdftotext -layout -eol unix -nopgbrk "$pre/$i" "$txt"
done

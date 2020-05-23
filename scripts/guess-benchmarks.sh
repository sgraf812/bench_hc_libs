#! /usr/bin/env bash
# 
# Grep for benchmark sections in the all .cabal files found under $1,
# defaulting to .
#

main() {
	search_path=${1:-.}
	find $search_path -name "*.cabal" | grep_benchmarks | lines_to_words
}

grep_benchmarks() {
	xargs -I{} grep -Po "^benchmark \K[^\n]+" {}
}

lines_to_words () {
	xargs
}

main

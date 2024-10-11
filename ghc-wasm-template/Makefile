default: dist/ghc_wasm_jsffi.js dist/bin.wasm
	cp frontend/*.html dist/
	cp frontend/*.js dist/

release: dist/ghc_wasm_jsffi.js default
	wizer --allow-wasi --wasm-bulk-memory true --init-func _initialize -o dist/bin.wasm "$(shell find dist-newstyle -name "*.wasm")"
	wasm-opt -O4 dist/bin.wasm -o dist/bin.wasm #other optimizations possible
	wasm-tools strip -o dist/bin.wasm dist/bin.wasm

dist-newstyle:
	wasm32-wasi-cabal build ghc-wasm-miso-examples

dist/ghc_wasm_jsffi.js: dist-newstyle
	mkdir -p dist
	"$(shell wasm32-wasi-ghc --print-libdir)"/post-link.mjs \
		--input "$(shell find $< -name "*.wasm")" \
		--output $@

dist/bin.wasm: dist-newstyle
	mkdir -p dist
	cp "$(shell find $< -name "*.wasm")" $@

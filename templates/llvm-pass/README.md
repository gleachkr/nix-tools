This is a quick nix wrapper around Adrian Sampson's llvm-pass-skeleton
repository.

For more background see the blog post [LLVM for Grad
Students](https://www.cs.cornell.edu/~asampson/blog/llvm.html).

To build the skeleton from the source files under `skeleton/`, run `nix build`.
To build an instrumented binary, using the skeleton pass and
`example/example.c` run `nix build .#test`. For other available operations,
take a look in `flake.nix`.

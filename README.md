# purescript-math-es6-quality

This project helps you evaluate the quality of the polyfills in the library [purescript-math-es6](https://github.com/JamieBallingall/purescript-math-es6).

In [purescript-math-es6](https://github.com/JamieBallingall/purescript-math-es6) the functions `acosh`, `asinh`, `atanh`, `cbrt`,
`cosh`, `expm1`, `log10`, `log1p`, `log2`, `sign`, `sinh`, and `tanh` all have
type `Number -> Number`. For each three versions are provided:

- A native version that uses only the engine (browser or Node) provided version
  of the function with no polyfill. E.g., `acoshNative`
- A polyfill version that does not use the engine provided version and does not
  rely on any ES6 features. E.g., `acoshPolyfill`
- A production version that uses the native version where available and falls
  back to the polyfill. E.g., `acosh`

This project evaluates the native and polyfill versions of those functions at
various values and compares them in a table.

To see tables of comparison values using Node, run `npm run test`. To see the
tables in a browser, run `npm run serve`. This project expects to find
`purescript-math-es6` in a sibling directory.

Generally, the polyfill quality is high. If a native function returns a
non-finite value (NaN, Infinity, -Infinity) at a tested value then the polyfill
returns the same. For finite values the differences are small, either in
absolute terms if the value is small or in relative terms if the value is large.
Polyfills will often return +0.0 when the native versions return -0.0 and 0.0
when the native version returns 5e-324.  However, the polyfill for the function
`sign`, however, exactly matches.

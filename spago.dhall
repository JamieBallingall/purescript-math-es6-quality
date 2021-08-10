{ name = "halogen-project"
, dependencies =
  [ "arrays"
  , "console"
  , "effect"
  , "foldable-traversable"
  , "halogen"
  , "math"
  , "maybe"
  , "numbers"
  , "ordered-collections"
  , "prelude"
  , "psci-support"
  , "purescript-math-es6"
  , "stringutils"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}

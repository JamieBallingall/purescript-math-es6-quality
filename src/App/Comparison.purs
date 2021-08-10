module App.Comparison
  ( comparison
  , rowLabels
  , functionLabels
  ) where

import Prelude
import Data.Array (catMaybes, null)
import Data.Foldable (fold)
import Data.Map (Map, fromFoldable, lookup)
import Data.Maybe (Maybe(Nothing, Just))
import Data.Monoid (power)
import Data.Number (nan, infinity)
import Data.Number.Extra (equal, isNegZero, isPosZero, maxValue, minValue, printNumber)
import Data.String.Utils (padStart)
import Data.Tuple (Tuple(Tuple))
import Math (abs)
import Math.Internal.ES6 as ES6

printDifference :: Number -> Number -> String
printDifference x y =
  if equal x y
  then "="
  else
    if (isNegZero x && isPosZero y) || (isPosZero x && isNegZero y)
    then "±0"
    else show $ abs (x - y)

type NativePolyfillPair =
  { native   :: Number -> Number
  , polyfill :: Number -> Number
  }

row :: Boolean -> NativePolyfillPair -> String -> Maybe String
row verbose f label = case lookup label values of
  Nothing -> Nothing
  Just value ->
    let
      n = f.native value
      p = f.polyfill value
    in
      if equal n p && not verbose
      then Nothing
      else Just $
        " " <> label <>
        padStart 25 (printNumber n) <>
        padStart 25 (printNumber p) <>
        padStart 25 (printDifference n p) <> "\n"

comparison :: Boolean -> String -> String
comparison verbose label = case lookup label nativePolyfillPairs of
  Nothing -> ""
  Just f ->
    let
      rows = catMaybes $ row verbose f <$> rowLabels
    in
      if null rows
      then label <> ": Exact match at all tested values\n"
      else header label <> (fold rows) -- fold?

header :: String -> String
header label =
  label <> ":\n" <>
  " x   " <>
  padStart 25 "Native" <>
  padStart 25 "Polyfill" <>
  padStart 25 "Difference" <>
  "\n " <> power "-" 79 <> "\n"

nativePolyfillPairs :: Map String NativePolyfillPair
nativePolyfillPairs = fromFoldable
  [ Tuple "acosh" { native : ES6.acoshNative, polyfill : ES6.acoshPolyfill }
  , Tuple "asinh" { native : ES6.asinhNative, polyfill : ES6.asinhPolyfill }
  , Tuple "atanh" { native : ES6.atanhNative, polyfill : ES6.atanhPolyfill }
  , Tuple "cbrt"  { native : ES6.cbrtNative,  polyfill : ES6.cbrtPolyfill  }
  , Tuple "cosh"  { native : ES6.coshNative,  polyfill : ES6.coshPolyfill  }
  , Tuple "expm1" { native : ES6.expm1Native, polyfill : ES6.expm1Polyfill }
  , Tuple "log10" { native : ES6.log10Native, polyfill : ES6.log10Polyfill }
  , Tuple "log1p" { native : ES6.log1pNative, polyfill : ES6.log1pPolyfill }
  , Tuple "log2"  { native : ES6.log2Native,  polyfill : ES6.log2Polyfill  }
  , Tuple "sign"  { native : ES6.signNative,  polyfill : ES6.signPolyfill  }
  , Tuple "sinh"  { native : ES6.sinhNative,  polyfill : ES6.sinhPolyfill  }
  , Tuple "tanh"  { native : ES6.tanhNative,  polyfill : ES6.tanhPolyfill  }
  ]

values :: Map String Number
values = fromFoldable
  [ Tuple "-Inf" (-infinity)
  , Tuple "-Max" (-maxValue)
  , Tuple "-100" (-100.0)
  , Tuple "-10 " (-10.0)
  , Tuple "-1  " (-1.0)
  , Tuple "-Min" (-minValue)
  , Tuple "-0  " (-0.0)
  , Tuple "+0  " 0.0
  , Tuple "+Min" minValue
  , Tuple "+1  " 1.0
  , Tuple "+10 " 10.0
  , Tuple "+100" 100.0
  , Tuple "+Max" maxValue
  , Tuple "+Inf" infinity
  , Tuple "NaN " nan
  ]

rowLabels :: Array String
rowLabels =
  [ "-Inf"
  , "-Max"
  , "-100"
  , "-10 "
  , "-1  "
  , "-Min"
  , "-0  "
  , "+0  "
  , "+Min"
  , "+1  "
  , "+10 "
  , "+100"
  , "+Max"
  , "+Inf"
  , "NaN "
  ]

functionLabels :: Array String
functionLabels =
  [ "acosh"
  , "asinh"
  , "atanh"
  , "cbrt"
  , "cosh"
  , "expm1"
  , "log10"
  , "log1p"
  , "log2"
  , "sign"
  , "sinh"
  , "tanh"
  ]

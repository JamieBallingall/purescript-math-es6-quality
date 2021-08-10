module Test.Main where

import Prelude
import App.Comparison (comparison, functionLabels)
import Data.Foldable (intercalate)
import Effect (Effect)
import Effect.Class.Console (log)

main :: Effect Unit
main =
  let
    verbose = false
  in do
    log $ "\n" <> intercalate "\n" (comparison verbose <$> functionLabels)

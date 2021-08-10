module App.Main where

import Prelude
import App.Comparison (comparison, functionLabels)
import Data.Array ((!!))
import Data.Maybe (Maybe(Nothing, Just))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

type State =
  { selectedFunction :: String
  , verbose :: Boolean
  }

data Action
  = DoNothing
  | UpdateSF String
  | UpdateV Boolean

component :: forall q i o m. H.Component q i o m
component =
  H.mkComponent
    { initialState : \_ -> { selectedFunction : "acosh", verbose : false }
    , render
    , eval : H.mkEval H.defaultEval { handleAction = handleAction }
    }

render :: forall m. State -> H.ComponentHTML Action () m
render state = HH.div_
  [ HH.form []
    [ HH.label
      [ HP.for "functionPair" ]
      [ HH.text "Function pair to test: " ]
    , HH.select
      [ HP.name "functionPair"
      , HE.onSelectedIndexChange updateSF
      ]
      options
    , HH.label
      [ HP.for "verbose" ]
      [ HH.text "Verbose output: " ]
    , HH.input
      [ HP.type_ HP.InputCheckbox
      , HE.onChecked UpdateV
      ]
    , HH.pre
      []
      [ HH.text $ comparison state.verbose state.selectedFunction ]
    ]
  ]

updateSF :: Int -> Action
updateSF i = case functionLabels !! i of
  Nothing -> DoNothing
  Just s  -> UpdateSF  s

handleAction :: forall cs o m. Action -> H.HalogenM State Action cs o m Unit
handleAction = case _ of
  DoNothing  -> pure unit
  UpdateSF s -> H.modify_ \st -> st { selectedFunction = s }
  UpdateV b  -> H.modify_ \st -> st { verbose = b }

options :: forall w i. Array (HH.HTML w i)
options = once <$> functionLabels

once :: forall w i. String -> HH.HTML w i
once s = HH.option [ HP.value s ] [ HH.text s ]

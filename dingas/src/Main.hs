{-# LANGUAGE OverloadedStrings
           , RecordWildCards
           #-}

module Main where

import Miso
import Miso.String

type Model = Int

data Action = AddOne
            | SubOne
            | Nop

main :: IO ()
main = startApp $ App{..}
    where initialAction = Nop
          model = 0
          update = updateModel
          view = viewModel
          events = defaultEvents
          subs = []
          mountPoint = Nothing

updateModel :: Action -> Model -> Effect Action Model
updateModel AddOne m = noEff (m + 1)
updateModel SubOne m = noEff (m - 1)
updateModel Nop m    = noEff m

viewModel :: Model -> View Action
viewModel m = div_ [] [ button_ [onClick AddOne] [text "+"]
                      , text (ms m)
                      , button_ [onClick AddOne] [text "+"]
                      ]

{-# LANGUAGE OverloadedStrings
           , RecordWildCards
           #-}

module Main where

import Control.Exception

import Data.JSString.Text

import qualified Data.Text as T

import Dhall hiding (maybe)
import Dhall.Core (Expr)
import Dhall.Parser
import Dhall.Pretty
import Dhall.TypeCheck

import Miso
import Miso.String (MisoString, ms)

type Model = T.Text

data Action = Nop
            | NewExpr MisoString
            | ExprDone T.Text

eval :: T.Text -> IO T.Text
eval x = render <$> try (inputExpr x)
    where render :: Either SomeException (Expr Src X) -> T.Text
          render (Left e)  = T.pack (show (dropWhile (/= 'E') (show e)))
          render (Right p) = T.pack (show (prettyExpr p))

main :: IO ()
main = startApp $ App{..}
    where initialAction = Nop
          model = ""
          update = updateModel
          view = viewModel
          events = defaultEvents
          subs = []
          mountPoint = Nothing

updateModel :: Action -> Model -> Effect Action Model
updateModel Nop m          = noEff m
updateModel (NewExpr c) m  = m <# (ExprDone <$> eval (textFromJSString c))
updateModel (ExprDone e) _ = noEff e

viewModel :: Model -> View Action
viewModel m = div_ [] [ textarea_ [onInput NewExpr] []
                      , br_ []
                      , code_ [] [text (ms m)]
                      ]

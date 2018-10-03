module Test (main) where

import Prelude
import Effect.Console 
import Effect.Random
import Data.Either
import Data.Maybe
import Effect (Effect)

equal :: forall a. Eq a => Show a => String -> a -> a -> Either String String
equal name expected actual =
  if expected == actual then Right name
  else Left $ name <> "\n expected: " <> show expected <>
       ", got: " <> show actual

logger :: Either String String -> Effect Unit
logger (Left l) = log l
logger (Right r) = log r

main = logger $ equal "test" 1 1

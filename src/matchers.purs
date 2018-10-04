module Matchers (equals) where

import Prelude
import Effect.Console 
import Data.Either
import Data.Array
import Effect (Effect)
import Data.Foldable (for_)

equals :: forall a. Eq a => Show a => String -> a -> a -> Either String String
equals name expected actual =
  if expected == actual then Right $ "passed: " <> name <> "\n"
  else Left $ "failed: " <> name <> "\n expected: " <> show expected <>
       ", got: " <> show actual <> "\n"


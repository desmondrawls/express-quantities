module Matchers (it, equals) where

import Prelude
import Effect.Console 
import Data.Either
import Data.Maybe
import Data.Tuple
import Data.Array
import Effect (Effect)
import Data.Foldable (for_)

it :: forall a b. Show a => Show b => String -> Maybe (Tuple a b) -> Either String String
it description Nothing 
    = Right $ "passed: " <> description
it description (Just (Tuple expected actual)) 
    = Left $ "failed: " <> description <> "\n expected: " <> show expected <> ", got: " <> show actual <> "\n"
 

equals :: forall a. Eq a => Show a => a -> a -> Maybe (Tuple a a)
equals expected actual | expected == actual = Nothing
                       | otherwise          = Just $ Tuple expected actual


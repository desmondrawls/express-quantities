module Test (main) where

import Prelude
import Effect.Console 
import Effect.Random
import Data.Either
import Data.Maybe
import Data.Array
import Data.Tuple
import Effect (Effect)
import Data.Foldable (for_)
import Quantities (quantities)

equal :: forall a. Eq a => Show a => String -> a -> a -> Either String String
equal name expected actual =
  if expected == actual then Right $ "passed: " <> name <> "\n"
  else Left $ "failed: " <> name <> "\n expected: " <> show expected <>
       ", got: " <> show actual <> "\n"

empty :: Array (Tuple Int Int)
empty = [(Tuple 1 1)]

tests :: Array (Either String String)
tests = [
  equal "empty" [] (quantities 1 1 1 1 []),
  equal "with a radius of zero" 2 (length $ quantities 0 0 3 5 [(Tuple 2 2), (Tuple 4 4)]),
  equal "limit one" 1 (length $ quantities 1 0 2 3 [(Tuple 2 2), (Tuple 4 4)]),
  equal "with a domain of one" [(Tuple 100 100), (Tuple 2 2)] (quantities 1 0 3 5 [(Tuple 2 2)]),
  equal "with a domain less than the requested quantity" 2 (length $ quantities 1 0 5 9 [(Tuple 2 2), (Tuple 4 4), (Tuple 6 6)]),
  equal "limit" 1 (length $ quantities 1 0 2 3 [(Tuple 2 2), (Tuple 4 4), (Tuple 6 6), (Tuple 8 8)])
]

logger :: Either String String -> Effect Unit
logger (Left l) = log l
logger (Right r) = log r

main = for_ tests \test -> logger test

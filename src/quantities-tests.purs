module QuantitiesTests (quantitiesTests) where

import Prelude
import Data.Either
import Data.Array
import Data.Tuple
import Quantities (quantities)
import Matchers

empty :: Array (Tuple Int Int)
empty = [(Tuple 1 1)]

quantitiesTests :: Array (Either String String)
quantitiesTests = [
  equals "empty" [] (quantities 1 1 1 1 []),
  equals "with a radius of zero" 2 (length $ quantities 0 0 3 5 [(Tuple 2 2), (Tuple 4 4)]),
  equals "limit one" 1 (length $ quantities 1 0 2 3 [(Tuple 2 2), (Tuple 4 4)]),
  equals "with a domain of one" [(Tuple 100 100), (Tuple 2 2)] (quantities 1 0 3 5 [(Tuple 2 2)]),
  equals "with a domain less than the requested quantity" 2 (length $ quantities 1 0 5 9 [(Tuple 2 2), (Tuple 4 4), (Tuple 6 6)]),
  equals "limit" 1 (length $ quantities 1 0 2 3 [(Tuple 2 2), (Tuple 4 4), (Tuple 6 6), (Tuple 8 8)])
]

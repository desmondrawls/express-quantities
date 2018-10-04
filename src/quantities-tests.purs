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
  it "empty" $ 
      equals [] (quantities 1 1 1 1 []),
  it "with a radius of zero" $ 
      equals 2 (length $ quantities 0 0 3 5 [(Tuple 2 2), (Tuple 4 4)]),
  it "limit one" $ 
      equals 1 (length $ quantities 1 0 2 3 [(Tuple 2 2), (Tuple 4 4)]),
  it "with a domain of one" $ 
      equals [(Tuple 100 100), (Tuple 2 2)] (quantities 1 0 3 5 [(Tuple 2 2)]),
  it "with a domain less than the requested quantity" $ 
      equals 2 (length $ quantities 1 0 5 9 [(Tuple 2 2), (Tuple 4 4), (Tuple 6 6)]),
  it "padding" $ 
      equals [(Tuple 6 6)] (quantities 1 2 2 3 [(Tuple 2 2), (Tuple 4 4), (Tuple 6 6), (Tuple 8 8)]),
  it "too much padding returns default" $ 
      equals [(Tuple 100 100)] (quantities 1 8 2 3 [(Tuple 2 2), (Tuple 4 4), (Tuple 6 6), (Tuple 8 8)])
]

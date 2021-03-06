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
      equals [] (quantities { size: 1, padding: 1, limit: 1, randomness: 1 } []),
  it "with a radius of zero" $ 
      equals 2 (length $ quantities { size: 0, padding: 0, limit: 3, randomness: 5 } [(Tuple 2 2), (Tuple 4 4)]),
  it "limit one" $ 
      equals 1 (length $ quantities { size: 1, padding: 0, limit: 2, randomness: 3 } [(Tuple 2 2), (Tuple 4 4)]),
  it "with a domain of one" $ 
      equals [(Tuple 100 100), (Tuple 2 2)] (quantities { size: 1, padding: 0, limit: 3, randomness: 5 } [(Tuple 2 2)]),
  it "with a domain less than the requested quantity" $ 
      equals 2 (length $ quantities { size: 1, padding: 0, limit: 5, randomness: 9 } [(Tuple 2 2), (Tuple 4 4), (Tuple 6 6)]),
  it "padding" $ 
      equals [(Tuple 6 6)] (quantities { size: 1, padding: 2, limit: 2, randomness: 3 } [(Tuple 2 2), (Tuple 4 4), (Tuple 6 6), (Tuple 8 8)]),
  it "too much padding returns default" $ 
      equals [(Tuple 100 100)] (quantities { size: 1, padding: 8, limit: 2, randomness: 3 } [(Tuple 2 2), (Tuple 4 4), (Tuple 6 6), (Tuple 8 8)])
]

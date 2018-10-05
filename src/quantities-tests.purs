module QuantitiesTests (quantitiesTests) where

import Prelude
import Data.Either
import Data.Array
import Data.Tuple
import Quantities (quantities)
import Matchers
import Quantities.Models

empty :: Array (Tuple Int Int)
empty = [(Tuple 1 1)]

spots :: Int -> Int -> Array Center
spots x y = do
  center_x <- 1 .. x
  center_y <- 1 .. y
  pure $ (Center {center_x, center_y})

quantitiesTests :: Array (Either String String)
quantitiesTests = [
  it "works" $
      equals [(Center {center_x: 1, center_y: 1}), (Center {center_x: 1, center_y: 2}), (Center {center_x: 2, center_y: 1}), (Center {center_x: 2, center_y: 2})]
      (spots 2 2),
  it "empty" $ 
      equals 
        [] 
        (quantities { size: 1, padding: 1, limit: 1, randomness: 1 } []),
  it "with a radius of zero" $ 
      equals 
        2 
        (length $ quantities { size: 0, padding: 0, limit: 3, randomness: 5 } [(Center { center_x: 2, center_y: 2}), (Center { center_x: 4, center_y: 4})]),
  it "limit one" $ 
      equals 
        1 
        (length $ quantities { size: 1, padding: 0, limit: 2, randomness: 3 } [(Center { center_x: 2, center_y: 2}), (Center { center_x: 4, center_y: 4})]),
  it "with a domain of one" $ 
      equals 
        [(Center { center_x: 100, center_y: 100}), (Center { center_x: 2, center_y: 2})] 
        (quantities { size: 1, padding: 0, limit: 3, randomness: 5 } [(Center { center_x: 2, center_y: 2})]),
  it "with a domain less than the requested quantity" $ 
      equals 
        2 
        (length $ quantities { size: 1, padding: 0, limit: 5, randomness: 9 } [(Center { center_x: 2, center_y: 2}), (Center { center_x: 4, center_y: 4}), (Center { center_x: 6, center_y: 6})]),
  it "padding" $ 
      equals 
        [(Center { center_x: 6, center_y: 6})] 
        (quantities { size: 1, padding: 2, limit: 2, randomness: 3 } [(Center { center_x: 2, center_y: 2}), (Center { center_x: 4, center_y: 4}), (Center { center_x: 6, center_y: 6}), (Center { center_x: 8, center_y: 8})]),
  it "too much padding returns default" $ 
      equals 
        [(Center { center_x: 100, center_y: 100})] 
        (quantities { size: 1, padding: 8, limit: 2, randomness: 3 } [(Center { center_x: 2, center_y: 2}), (Center { center_x: 4, center_y: 4}), (Center { center_x: 6, center_y: 6}), (Center { center_x: 8, center_y: 8})])
]

module Quantities (quantities) where

import Prelude
import Data.Tuple
import Data.Maybe
import Data.Array
import Data.Identity
import Quantities.Models

quantities :: 
  forall e. { size :: Int, padding :: Int, limit :: Int, randomness :: Int | e } 
    -> Array Center 
    -> Array Center
quantities { size, padding, limit, randomness } domain =
    take quantity $ shuffle randomness $ filter (fits size padding) domain
    where
      quantity = randomness `mod` limit

fits :: Int -> Int -> Center -> Boolean
fits size padding (Center {center_x: x, center_y: y}) =
  y `mod` space == 0 && x `mod` space == 0
    where
      space = 2 * (size + padding)

shuffle :: Int -> Array Center -> Array Center
shuffle 0 deck = deck
shuffle rounds deck =
    shuffle (rounds - 1) $ concat subdecks
    where
      subdecks = do
        i <- 1 .. (length deck / 2)
        pure $ oddPair i deck (Center {center_x: 100, center_y: 100})

oddPair :: forall a. Int -> Array a -> a -> Array a
oddPair i arr backup =
    [(index (n - i)), (index (i - 1))]
    where
      n = length arr
      index at = maybe backup identity (arr !! at) 


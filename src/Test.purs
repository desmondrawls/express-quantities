module Test (main) where

import Prelude
import Effect.Console 
import Data.Either
import Data.Array
import Effect (Effect)
import Data.Foldable (for_)
import Quantities (quantities)
import QuantitiesTests

logger :: Either String String -> Effect Unit
logger (Left l) = log l
logger (Right r) = log r

main = for_ quantitiesTests \test -> logger test

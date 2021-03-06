module Oak.Cmd.Http.Conversion
  ( defaultEncode
  , defaultDecode
  , makeEncoder
  , makeDecoder
  ) where

import Control.Monad.Except (runExcept)
import Data.Either (Either(..))
import Foreign (Foreign, F)
import Foreign.Class (class Decode)
import Foreign.Generic (defaultOptions, genericDecode, genericDecodeJSON, genericEncode, genericEncodeJSON)
import Foreign.Generic.Class (class GenericEncode, class GenericDecode)
import Foreign.Generic.Types (Options)
import Data.Generic.Rep (class Generic)
import Prelude (show, ($))

codingOptions :: Options
codingOptions = defaultOptions { unwrapSingleConstructors = true }

defaultEncode ::
  ∀ a rep.
    Generic a rep
      => GenericEncode rep
      => a
      -> Foreign
defaultEncode = genericEncode codingOptions


-- #genericEncodeJSON calls JSON.stringify, which throws an exception for
-- recursive data structures and returns undefined for functions. We can
-- assume that recursive data structures are impossible given Purescript's
-- immutability constraint. It is still possible to pass a function to
-- #genericeEncodeJSON so we should return a Maybe or Either.
-- TODO: return Maybe or Either instead of undefined.
makeEncoder :: ∀ a t.
  Generic a t
    => GenericEncode t
    => a
    -> String
makeEncoder structured = genericEncodeJSON codingOptions structured

defaultDecode ::
  ∀ a rep.
    Generic a rep
      => GenericDecode rep
      => Foreign
      -> F a
defaultDecode = genericDecode codingOptions

makeDecoder :: ∀ a t.
  Generic a t
    => GenericDecode t
    => Decode a
    => String
    -> Either String a
makeDecoder json =
  case runExcept $ genericDecodeJSON codingOptions json of
    Left err -> Left (show err)
    Right result -> Right result

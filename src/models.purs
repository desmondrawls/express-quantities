module Quantities.Models where

import Prelude
import Oak.Cmd.Http.Conversion (defaultDecode, defaultEncode)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Foreign.Class (class Decode, class Encode)
import Foreign.Generic (genericEncode, genericDecode, defaultOptions)
import Data.Eq

data TransportModel = TransportModel { size :: Int, padding :: Int, limit :: Int, randomness :: Int, centers :: Centers }

instance showTransportModel :: Show TransportModel where 
  show = genericShow

derive instance genericTransportModel :: Generic TransportModel _

instance encodeTransportModel :: Encode TransportModel where
  encode = genericEncode $ defaultOptions {unwrapSingleConstructors = true}

data Center = Center { center_x :: Int, center_y :: Int }

instance equateCenter :: Eq Center where 
  eq (Center {center_x: x, center_y: y}) (Center {center_x: x2, center_y: y2}) = x == x2 && y == y2 

instance showCenter :: Show Center where 
  show = genericShow

derive instance genericCenter :: Generic Center _

instance decodeCenter :: Decode Center where
  decode = genericDecode $ defaultOptions {unwrapSingleConstructors = true}

instance encodeCenter :: Encode Center where
  encode = genericEncode $ defaultOptions {unwrapSingleConstructors = true}

data Centers = Centers (Array Center)

instance showCenters :: Show Centers where 
  show = genericShow

derive instance genericCenters :: Generic Centers _

instance decodeCenters :: Decode Centers where
  decode = genericDecode $ defaultOptions {unwrapSingleConstructors = true}

instance encodeCenters :: Encode Centers where
  encode = genericEncode $ defaultOptions {unwrapSingleConstructors = true}

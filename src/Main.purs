
module Main where

import Prelude hiding (apply)
import Effect (Effect)
import Foreign (renderForeignError)
import Effect.Console (log)
import Data.Tuple
import Data.Array
import Data.Maybe
import Data.Either
import Node.Express.App (App, listenHttp, post, get, use, useExternal)
import Node.Express.Handler (Handler)
import Node.Express.Request (getQueryParam, getBody)
import Node.Express.Response (send, sendJson, setStatus, setResponseHeader)
import Node.HTTP (Server)
import Quantities (quantities)
import Quantities.BodyParser (jsonBodyParser)
import Oak.Cmd.Http.Conversion (defaultDecode, defaultEncode)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Foreign.Class (class Decode, class Encode)

createTodoHandler :: Handler
createTodoHandler = do
    body <- getBody
    respond body

respond :: Maybe TransportModel -> Handler
respond (Just t) = sendJson t
respond _ = sendJson {x: "failed"}

maybes :: Maybe Int -> Maybe Int -> Maybe Int -> Maybe Int -> String
maybes (Just size) (Just padding) (Just limit) (Just randomness)
    = show {size, padding, limit, randomness}
maybes _ _ _ _ = "nope"

maybeQuantities :: Maybe Int -> Maybe Int -> Maybe Int -> Maybe Int -> Maybe (Array (Tuple Int Int)) -> Array (Tuple Int Int)
maybeQuantities (Just size) (Just padding) (Just limit) (Just randomness) (Just centers)
    = quantities {size, padding, limit, randomness} centers
maybeQuantities _ _ _ _ _ = []

cors :: Handler
cors = do
  setResponseHeader "Access-Control-Allow-Origin" "*"
  setResponseHeader "Access-Control-Allow-Methods" "GET, POST, OPTIONS"
  setResponseHeader "Access-Control-Allow-Headers" "Origin, X-Requested-With, Content-Type, Accept"

app :: App
app = do
    use cors
    useExternal jsonBodyParser
    post "/" createTodoHandler

main :: Effect Server
main = do
    listenHttp app 8080 \_ ->
        log $ "Listening on " <> show 8080

data TransportModel = TransportModel { size :: Int, padding :: Int, limit :: Int, randomness :: Int, centers :: Centers }

instance showTransportModel :: Show TransportModel where 
  show = genericShow

derive instance genericTransportModel :: Generic TransportModel _

instance encodeTransportModel :: Encode TransportModel where
  encode = defaultEncode

data Center = Center { center_x :: Int, center_y :: Int }

instance showCenter :: Show Center where 
  show = genericShow

derive instance genericCenter :: Generic Center _

instance decodeCenter :: Decode Center where
  decode = defaultDecode

instance encodeCenter :: Encode Center where
  encode = defaultEncode

data Centers = Centers (Array Center)

instance showCenters :: Show Centers where 
  show = genericShow

derive instance genericCenters :: Generic Centers _

instance decodeCenters :: Decode Centers where
  decode = defaultDecode

instance encodeCenters :: Encode Centers where
  encode = defaultEncode

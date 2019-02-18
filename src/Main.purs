
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
import Node.Express.Middleware.Static
import Node.Express.Request (getBodyParam, getQueryParam, getBody)
import Node.Express.Response (send, sendJson, setStatus, setResponseHeader)
import Node.HTTP (Server)
import Quantities (quantities)
import Oak.Cmd.Http.Conversion (defaultDecode, defaultEncode)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Foreign.Class (class Decode, class Encode)
import Data.Function.Uncurried (Fn1, runFn1, Fn3)
import Node.Express.Types (Response, Request)
import Quantities.Models

foreign import staticPath ::  Fn1 String String
foreign import jsonBodyParser :: Fn3 Request Response (Effect Unit) (Effect Unit)

getCenters :: Handler
getCenters = do
    padding <- getBodyParam "padding"
    size <- getBodyParam "size"
    limit <- getBodyParam "limit"
    randomness <- getBodyParam "randomness"
    centers <- getBodyParam "centers"
    sendJson {quantities: (maybeQuantities size padding limit randomness centers)}

respond :: Maybe TransportModel -> Handler
respond (Just t) = sendJson t
respond _ = sendJson {x: "failed"}

maybes :: Maybe Int -> Maybe Int -> Maybe Int -> Maybe Int -> String
maybes (Just size) (Just padding) (Just limit) (Just randomness)
    = show {size, padding, limit, randomness}
maybes _ _ _ _ = "nope"

maybeQuantities :: Maybe Int -> Maybe Int -> Maybe Int -> Maybe Int -> Maybe Centers -> Centers
maybeQuantities (Just size) (Just padding) (Just limit) (Just randomness) (Just (Centers centers))
    = (Centers $ quantities {size, padding, limit, randomness} [(Center {center_x: 1, center_y: 1}), (Center {center_x: 2, center_y: 2})])
maybeQuantities Nothing Nothing Nothing Nothing Nothing = (Centers [(Center {center_x: 1, center_y: 1})])
maybeQuantities _ Nothing Nothing Nothing Nothing = (Centers [(Center {center_x: 2, center_y: 2})])
maybeQuantities _ _ Nothing Nothing Nothing = (Centers [(Center {center_x: 3, center_y: 3})])
maybeQuantities _ _ _ Nothing Nothing = (Centers [(Center {center_x: 4, center_y: 4})])
maybeQuantities _ _ _ _ Nothing = (Centers [(Center {center_x: 5, center_y: 5})])
maybeQuantities _ _ _ _ _ = (Centers [(Center {center_x: 6, center_y: 6})])

cors :: Handler
cors = do
  setResponseHeader "Access-Control-Allow-Origin" "*"
  setResponseHeader "Access-Control-Allow-Methods" "GET, POST, OPTIONS"
  setResponseHeader "Access-Control-Allow-Headers" "User-Agent, Origin, X-Requested-With, Content-Type, Accept"
  setResponseHeader "access-control-expose-headers" "access-control-allow-origin, access-control-allow-methods, access-control-allow-headers"

echoHandler :: Handler
echoHandler = do
    messageParam <- getBodyParam "message"
    case messageParam of
        Nothing -> send "You did not say anything"
        Just message -> send $ "You said: " <> message

app :: App
app = do
    useExternal jsonBodyParser
    post "/echo" echoHandler
    post "/" getCenters

main :: Effect Server
main = do
    listenHttp app 8080 \_ ->
        log $ "Listening on " <> show 8080


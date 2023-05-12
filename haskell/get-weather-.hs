{-# LANGUAGE OverloadedStrings #-}

import Control.Monad.State
import Network.HTTP.Client (newTlsManager, parseRequest, httpLbs)
import Network.HTTP.Simple (getResponseBody)

data AppState = AppState
  { latitude :: Maybe String
  , longitude :: Maybe String
  , url :: Maybe String
  }

initializeLatLon :: StateT AppState IO ()
initializeLatLon = do
  put $ AppState { latitude = Nothing, longitude = Nothing, url = Nothing }
  lat <- liftIO $ putStr "Enter latitude: " >> getLine
  lon <- liftIO $ putStr "Enter longitude: " >> getLine
  modify $ \s -> s { latitude = Just lat, longitude = Just lon }

createUrl :: StateT AppState IO ()
createUrl = do
  liftM2 (,) (gets latitude) (gets longitude) >>= \(lat, lon) ->
    let url' = "https://api.openweathermap.org/data/2.5/weather?lat=" ++ lat ++ "&lon=" ++ lon ++ "&appid=9525a467ef22974bc25346d4bc02de69"
     in modify $ \s -> s { url = Just url' }

getWeatherData :: IO ()
getWeatherData = do
  let initialState = AppState { latitude = Nothing, 
                                longitude = Nothing, 
                                url = Nothing }
      finalState = execStateT (initializeLatLon >> createUrl) initialState
      getUrl' = url
  case getUrl' finalState of
    Just url' -> do
      manager <- newTlsManager
      request <- parseRequest url'
      response <- httpLbs request manager
      putStrLn $ getResponseBody response
    Nothing -> putStrLn "Error: Missing latitude/longitude"

main :: IO ()
main = getWeatherData

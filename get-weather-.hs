import Control.Monad.IO.Class
import Data.Aeson
import Network.HTTP.Req


main :: IO ()
-- You can either make your monad an instance of 'MonadHttp', or use
-- 'runReq' in any IO-enabled monad without defining new instances.
main = runReq defaultHttpConfig $ do
data AppState = AppState
  { latitude :: Maybe String
  , longitude :: Maybe String
  , url :: Maybe String
  }

initializeLatLon :: State AppState ()
initializeLatLon = do
  put (AppState { latitude = Nothing, longitude = Nothing, url = Nothing })
  lat <- liftIO $ putStr "Enter latitude: " >> getLine
  lon <- liftIO $ putStr "Enter longitude: " >> getLine
  modify (\s -> s { latitude = Just lat, longitude = Just lon })

createUrl :: State AppState ()
createUrl = do
  lat <- gets latitude
  lon <- gets longitude
  case (lat, lon) of
    (Just lat', Just lon') ->
      modify (\s -> s { url = Just $ "https://api.openweathermap.org/data/2.5/weather?lat=" ++ lat' ++ "&lon=" ++ lon' ++ "&appid=9525a467ef22974bc25346d4bc02de69" })
    _ -> return ()

getUrl :: AppState -> Maybe String
getUrl = url

getWeatherData :: IO ()
getWeatherData = do
  let initialState = AppState { latitude = Nothing, longitude = Nothing, url = Nothing }
      finalState = execState (initializeLatLon >> createUrl) initialState
  case getUrl finalState of
    Just url' -> do
      manager <- newTlsManager
      request <- parseRequest url'
      response <- httpLbs request manager
      putStrLn $ responseBody response
    Nothing -> putStrLn "Error: Missing latitude/longitude"


--test
-- $ runhaskell get-weather.hs

--1
--Enter latitude: 37.7749
--Enter longitude: -122.4194
--{"coord":{"lon":-122.42,"lat":37.77},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"base":"stations","main":{"temp":285.22,"feels_like":284.42,"temp_min":283.95,"temp_max":286.15,"pressure":1014,"humidity":65},"visibility":10000,"wind":{"speed":3.6,"deg":290},"clouds":{"all":1},"dt":1555501564,"sys":{"type":1,"id":5122,"message":0.0139,"country":"US","sunrise":1555471623,"sunset":1555520683},"timezone":-25200,"id":420006353,"name":"San Francisco","cod":200}

--note installazione dei pacchetti mancanti
--nel progetto, per il suo corretto funzionamento
-- cabal update
-- cabal update && cabal new-install --lib parallel HTTP-Simple
-- cabal update && cabal new-install --lib parallel mtl

--importazione della libreria `Network.Wreq` che viene utilizzata per effettuare richieste HTTP.
--Viene anche importata la libreria `Control.Monad.State` per gestire lo stato dell'applicazione.

import Network.Wreq 
import Control.Monad.State
import Network.HTTP.Client.TLS

--definizione di un tipo di dati `AppState` che contiene tre campi 
--`latitude`, `longitude`, e `url`, che possono essere opzionalmente presenti (`Maybe String`).

data AppState = AppState
  { latitude :: Maybe String
  , longitude :: Maybe String
  , url :: Maybe String
  }

--La funzione `initializeLatLon` è una funzione di stato utilizzata per inizializzare 
--le coordinate latitudinali e longitudinali della posizione. Utilizza `put` per impostare 
--l'applicazione allo stato iniziale, `liftIO` per effettuare l'input/output e `modify` per 
--aggiornare lo stato dell'applicazione.

initializeLatLon :: StateT AppState IO ()
initializeLatLon = do
  put $ AppState { latitude = Nothing, longitude = Nothing, url = Nothing }
  lat <- liftIO $ putStr "Enter latitude: " >> getLine
  lon <- liftIO $ putStr "Enter longitude: " >> getLine
  modify $ \s -> s { latitude = Just lat, longitude = Just lon }

--La funzione `createUrl` è utilizzata per creare l'URL per l'API OpenWeatherMap. 
--Utilizza `gets` per leggere le coordinate latitudinali e longitudinali dallo stato dell'applicazione,
--`>>=` per concatenare i risultati, e `modify` per aggiornare lo stato dell'applicazione con l'URL creato.

createUrl :: StateT AppState IO ()
createUrl = do
  liftM2 (,) (gets latitude) (gets longitude) >>= \(lat, lon) ->
    let url' = "https://api.openweathermap.org/data/2.5/weather?lat=" ++ lat ++ "&lon=" ++ lon ++ "&appid=9525a467ef22974bc25346d4bc02de69"
     in modify $ \s -> s { url = Just url' }

--La funzione `getWeatherData` è la funzione principale del programma. 
--Crea uno stato iniziale vuoto utilizzando `AppState` e `execStateT` per eseguire 
--le funzioni di stato `initializeLatLon` e `createUrl`. Viene quindi utilizzato `getUrl'` 
--per accedere all'URL creato nello stato dell'applicazione. Se l'URL esiste, viene effettuata 
--una richiesta HTTP all'API OpenWeatherMap utilizzando `newTlsManager` per creare un gestore 
--di richieste e `httpLbs` per effettuare la richiesta. La risposta viene quindi stampata sulla
--console utilizzando `putStrLn`. Se l'URL non esiste, viene stampato un messaggio di errore.

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
      putStrLn $ responseBody response
    Nothing -> putStrLn "Error: Missing latitude/longitude"

main :: IO ()
main = getWeatherData


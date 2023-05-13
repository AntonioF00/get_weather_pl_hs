{-# LANGUAGE OverloadedStrings #-}

-- importazione delle librerie
import Network.HTTP.Conduit (simpleHttp)
import qualified Data.ByteString.Lazy.Char8 as L

--funzione che prende in ingresso due stringhe e le concatena
concatenaStringhe :: String -> String -> String
concatenaStringhe stringa1 stringa2 = stringa1 ++ stringa2

--dichiarazione del modulo main
main :: IO ()
main = do
    --richiesta input della latutidine
    putStrLn "Inserisci la Latitudine:"
    --salvataggio in una variabile 'latitudine' il contenuto
    --in input inserito dall'utente
    latitudine <- getLine
    --richiesta input della longitudine
    putStrLn "Inserisci la Longitudine:"
    --salvataggio in una variabile 'longitudine' il contenuto
    --in input inserito dall'utente
    longitudine <- getLine
    --ouput di riepilogo che mostra i dati inseriti dall'utente
    putStrLn $ "Hai inserito: " ++ latitudine ++ " e " ++ longitudine
    --dichiarazione di tre variabili contenenti le parti della richiesta HTTP
    let stringa1 = "https://api.openweathermap.org/data/2.5/weather?lat="
        stringa2 = "&lon="
        stringa3 = "&appid=9525a467ef22974bc25346d4bc02de69"
        --concatenazione dei dati inseriti in input e delle stringhe conteneti la richiesta HTTP
        stringaConcatenata = concatenaStringhe (concatenaStringhe stringa1 latitudine) (concatenaStringhe stringa2 longitudine ++ stringa3)
    --richiesta http al server openweathermap che ritornerà in output le informazioni meteo
    response <- simpleHttp stringaConcatenata
    --stampa a video delle informazioni generate dalla richiesta API
    L.putStrLn response

-- test 
-- cabal install --lib http-conduit
-- ghc get-weather.hs
-- /get-weather.exe



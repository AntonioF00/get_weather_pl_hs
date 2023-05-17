    %% importazione delle librerie necessarie per il programma
    :- use_module(library(http/thread_httpd)).
    :- use_module(library(http/http_dispatch)).
    :- use_module(library(http/http_json)).

    %% definizione dei tipi di dati JSON supportati dal server.
    http_json:json_type('application/x-javascript').
    http_json:json_type('text/javascript').
    http_json:json_type('text/x-javascript').
    http_json:json_type('text/x-json').

    %%definizione dati dinamici dinamici che serviranno come variabili all'interno del
    %%server, latitudine per memorizzare il valore di latitudine inserito dall'utente
    %%longitudine per memorizzare il valore di longitudine inserito dall'utente
    %%url per memorizzare la stringha ri richiesta API creata tramite la concatenazione
    %%dei dati di latitutdine e longitudine

    :- dynamic latitudine/1, longitudine/1, url/1.

    %%La funzione `inizializza_lat_lon/2` è utilizzata per inizializzare le coordinate latitudinali e longitudinali 
    %%della posizione. Questa funzione utilizza `assertz` per asserire i fatti `latitudine/1` e `longitudine/1`.
    inizializza_lat_lon(Latitudine, Longitudine) :-
        assertz(latitudine(Latitudine)),
        assertz(longitudine(Longitudine)).

    %%Questa funzione utilizza i fatti `latitudine/1` e `longitudine/1`
    %%per costruire l'URL, che viene quindi asserito nel fatto `url/1`.
    crea_url :-
        latitudine(Lat),
        longitudine(Lon),
        atom_concat('https://api.openweathermap.org/data/2.5/weather?lat=', Lat, Url1),
        atom_concat(Url1,'&lon=',Url2),
        atom_concat(Url2,Lon,Url3),
        atom_concat(Url3,'&appid=9525a467ef22974bc25346d4bc02de69',Url),
        assertz(url(Url)).

    %%importazione la libreria `http/http_client`, che viene utilizzata per effettuare richieste HTTP.
    :- use_module(library(http/http_client)).

    %%La funzione `calcola_meteo/0` è la funzione principale del programma. Questa funzione utilizza il fatto `url/1` per 
    %%effettuare una richiesta HTTP all'API OpenWeatherMap. La risposta viene quindi scritta sulla console utilizzando `write`. 
    calcola_meteo() :-
        url(Url),
        http_get(Url, Response, []),
        write(Response).

%%test

%%1
%| ?- inizializza_lat_lon('45.46', '9.19').
%yes

%| ?- crea_url.
%yes

%| ?- calcola_meteo.
%{ "coord": { "lon": 9.19, "lat": 45.46 }, "weather": [ { "id": 802, "main": "Clouds", "description": "scattered clouds", "icon": "03d" } ], "base": "stations", "main": { "temp": 290.95, "feels_like": 290.6, "temp_min": 289.45, "temp_max": 292.46, "pressure": 1020, "humidity": 66 }, "visibility": 10000, "wind": { "speed": 1.34, "deg": 160 }, "clouds": { "all": 44 }, "dt": 1651727253, "sys": { "type": 2, "id": 2009385, "country": "IT", "sunrise": 1651695405, "sunset": 1651748492 }, "timezone": 7200


%%2

%?- inizializza_lat_lon('45.4642', '9.1900').
%true.

%?- crea_url.
%true.

%?- calcola_meteo.
%{ "coord":{ "lon":9.19, "lat":45.4642 }, "weather":[ { "id":800, "main":"Clear", "description":"clear sky", "icon":"01d" } ], "base":"stations", "main":{ "temp":292.87, "feels_like":291.52, "temp_min":291.15, "temp_max":294.59, "pressure":1012, "humidity":43 }, "visibility":10000, "wind":{ "speed":2.06, "deg":120 }, "clouds":{ "all":0 }, "dt":1620814447, "sys":{ "type":2, "id":2014603, "country":"IT", "sunrise":1620786364, "sunset":1620842344 }, "timezone":7200, "id":3169070, "name":"Milan", "cod":200 }
%true.

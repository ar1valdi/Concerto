Praca dyplomowa inżynierska Concerto o tytule "System wspierania zdalnego uczenia muzyki i koncertów online". 

# O aplikacji
Aplikacja Concerto to kompleksowy system wspierający zdalne uczenie muzyki i organizację koncertów online. Głównym celem aplikacji jest umożliwienie użytkownikom nauki muzyki poprzez oglądanie streamowanych koncertów na żywo oraz przeglądanie i analizowanie nut powiązanych z nagraniami. System pełni rolę zaawansowanego repozytorium multimedialnego, które łączy w sobie funkcjonalności przechowywania zasobów muzycznych, streamingu wideo w czasie rzeczywistym oraz nagrywania i archiwizacji koncertów. Aplikacja oferuje wielojęzyczne wsparcie dzięki dynamicznemu systemowi tłumaczeń zintegrowanemu z CMS, co pozwala na łatwe zarządzanie treścią i dostosowanie interfejsu do różnych użytkowników. Dzięki zaawansowanemu systemowi autoryzacji opartemu na Keycloak, każdy użytkownik ma dostęp jedynie do zasobów, do których został uprawniony, zapewniając bezpieczne i spersonalizowane środowisko do nauki muzyki.

# Główne funkcjonalności
Repozytorium zasobów z dostępem do katalogów per użytkownik. 
Możliwość nagrywania wideo i zapisywania go w aplikacji lub na urządzeniu.
Streaming na żywo w aplikacji.
Dynamiczne tłumaczenie całej aplikacji połączone z CMS (autorskie rozwiązania).
Zarządzanie użytkownikami przez Keycloak.

# Architektura
Projekt API w ASP.NET 9.0.
Frontend w Blazor WASM w .NET 9.0.
Baza danych postgres.
Dostawca tożsamości Keycloak.
Wersja webowa oraz PWA.

# O projekcie
Kontynuacja projektu rozwijanego w ramach pracy magisterskiej mgr Macieja Zakrzewskiego. W zastanej aplikacji było dużo funkcjonalności:
- tworzenie muzyki przez sieć (daw na stronie internetowej)
- workspaces - logicznie odseparwane podstrefy ze swoimi drzewami plików, sesjami nagraniowymi (nagrywane właśnie w daw) i forami (posty + komentarze)

Pierwszym zadaniem było uruchomienie aplikacji, co wymagało odtworzenia całej konfiguracji, której nie dostaliśmy razem z kodem. Aplikacja rozwijana była z postawionymi serwisami postgres, pgadmin oraz keycloak jako kontenery dockerowe.

Naszym zadaniem było odchudzić aplikację, usunąć sesje nagraniowe, fora i workspaces, a drzewo plików przeprojektować tak, aby było jedne dla całej aplikacji, a zasoby oddzielane były jedynie poprzez autoryzację na dostępach do plików.

Kolejnym zadaniem było dodanie lokalizacji do strony. Do tłumaczeń użyty został autroski mechanizm oparty na tłumaczeniach trzymanych w bazie danych, które można zmieniać zapewniając również CMS w aplikacji. Języki również można oraz usuwać, co pozwala na nieskończone możliwości dodawania nowych języków do strony.

Następnie należało usunąć komponent wideo JITSI i podmienić go na własny komponent opierający się na websocket, a streamowanie na peer-to-peer. 

Ostatnim krokiem była konteneryzacja aplikacji oraz wdrożenie na serwer preprodukcyjny VPS oraz serwer produkcyjny udostępniony nam przez Politechnikę Gdańską.



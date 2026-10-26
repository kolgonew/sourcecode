# Pochodzenie kodu i zasobów

BK-Rynek 3.0 zawiera materiały z lokalnych projektów dostarczonych przez użytkownika. Oryginałów nie zmieniano. Metadane pozostają w `docs/upstream`; licencje nie są ujednolicane.

| Składnik | Pochodzenie | Informacja źródłowa |
|---|---|---|
| ShapeShader, TextShader, MSDF atlas/vertex helpers, SvgShader/parser/ikony, RoundedTextureShader, BlurEffect, clipping, Tween/easing, proporcje i styl UI | `F:/SystemDLC-main/SystemDLC-main`, `client/render`, `client/data`, `client/gui/widget` | Zachowano README i fabric.mod.json w `docs/upstream/systemdlc`. README wskazuje W1xced; w dostarczonych metadanych nie ma deklaracji licencji. |
| Obsługa wejścia, formularzy, modele layoutu/kolorów, zaadaptowane MenuWindow/ConfigCard | ExpensiveSRC 4.1.3 / pakiet `aethereal` | Oryginalne fabric.mod.json deklaruje All-Rights-Reserved; readme zachowany. Stary DrawEngine GPU, jego bufory, shadery, blur i tekstury usunięto. Nazwa DrawEngine pozostała wyłącznie dla adaptera kontrolek do SystemDLC. |
| Bootstrap BK-Rynku, komendy, konfiguracja, migracja, cloud, adaptery i LegacySlotHighlight (oryginalne metody Panel z v1.21.1) | `D:/mc/bk-rynek dziala - smigabengla` | MIT, Copyright (c) 2026 bkubiakdev; pełny tekst w `docs/upstream/bk-rynek-MIT-LICENSE.txt`. |
| AutoMarket, scanner, zakup i sprzedaż: porównane z BKClient Clean; starszy wzorzec serializacji i testy Full | BKClient Clean 3.0.3 / 1.21.4; historyczne referencje Full | Dostarczone metadane: CC0-1.0. |
| Inter medium/semibold z rozszerzonymi glifami oraz dźwięki GUI | Atlasy Expensive z dodatkowymi glifami BKClient/BKClient-Addons; próbki BKClient | Pochodzenie atlasów zapisuje `tools/augment_fonts.py`; metadane Addons zachowane. Deklaracja klienta nie ustala odrębnych praw do fontów i sampli. |

Wariant SystemDLC nie kopiuje i nie uruchamia natywnej biblioteki systemdlc.dll, ClassRedefiner, kont, modułów gry ani sieciowego dostarczania zasobów. Shadery przeniesiono do namespace `bkrynek`, a zasoby fontów/ikon ładowane są lokalnie. Liquid glass i efekty ESP nie są potrzebne czarnemu panelowi rynku i nie są aktywowane.

Oryginalne atlasy SystemDLC mają niepełne pokrycie polskich znaków. Aby uniknąć różnych grubości tekstu w zależności od liter, wszystkie etykiety i pola korzystają z rozszerzonego Inter Medium, nagłówki z Inter Semibold, przez shader tekstowy SystemDLC. Pozostawione oryginalne atlasy dokumentują pochodzenie obsługiwanych fontów.

To lokalna integracja; nie nadano całości licencji MIT/open source i nie publikowano projektu. Metadane nie stanowią dodatkowego zezwolenia na rozpowszechnianie materiałów stron trzecich.

Fabric, Minecraft, Gson, Guava, LWJGL i JOML są dostarczane przez środowisko gry/Fabric/Gradle, zgodnie z własnymi licencjami; nie kopiowano binarnych bibliotek starego klienta.

Logo nagłówka: oryginalny przezroczysty plik użytkownika D:/projects/projects/mods-nextjs/public/bk-logo.png, skopiowany bez zmian na jego polecenie. Renderer portów 1.21.5+ korzysta z lokalnej warstwy zgodności ports/render-compat.

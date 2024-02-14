# MOBI-12 (Geinstrumenteerde hulpmiddelen)

## Probleemstelling
Voor de revalidatie van mensen met lichamelijke klachten (waaronder eg. motorische problemen) was er de noodzaak voor het revalidatieproces in kaart te kunnen brengen. Er waren al bestaande sensoren (Movella Dot Sense X), maar deze waren enkel te gebruiken via de aangeleverde applicatie welke vrij beperkt is en niet onder eigen beheer. Ten slotte kon deze applicatie niet online raadpleegbaar zijn. Hierdoor zijn er verschillende beperkingen, denk aan:

- Geen offline support (patienten thuis)
- Geen lange termijn analyse 
- Geen backup (data lokaal, verloren = verloren)

## Aanpak
Eerst en vooral is er een analyse gemaakt van de benodigdheden, hiervoor is er een use case diagram gemaakt alsook ruwe datamodellen zodat het duidelijk was hoe de structuur eruit zou zien. Het was hier niet erg evident om eerst met de front-end te beginnen omdat er bepaalde gegevens waren die we in de back-end moesten bijhouden die niet zichtbaar zijn op de front-end. 

Ook is er een Figma prototype gemaakt welke met de klant overlegd is zodat we goed konden inschatten wat de wensen precies waren op inhoudelijk vlak.

https://www.figma.com/file/jM85YEemp1JlE1XwK7KMya/MOBI-012-Prototypes?type=design&node-id=0%3A1&mode=design&t=uqADgVe87OyU2Ndv-1


## Doel Semester 1

Het doel in het 1ste semester was als volgt:
- Mobile app -> Sensordata lezen & versturen (Android)
- Dashboard -> Data uitlezen

Wat betreft framework is de keuze gegaan naar Flutter. Vorige ervaringen hiermee, alsook het feit dat er veel mogelijkheden zijn op dit platform maakt dit een goede keuze voor een cross-platform applicatie. Er is ook gedacht aan React, maar dit leek minder ideaal voor deze toepassing.


## Mobile App

Het versturen van de sensordata via een mobile app had echter wat benodigdheden. Zo was er een tussenlaag nodig om vanuit Flutter data te kunnen verzenden naar de sensoren (via een SDK) en omgekeerd, een zogenaamde "Middleware". Deze is geschreven in Kotlin.

Gezien het project goed was opgesplitst was het implementeren van de SDK een losstaand iets van de front-end zelf. 

Ondertussen werd ook de front-end dus gemaakt. Er was voordien al overlegd hoe deze eruit zou zien dus dit was puur een kwestie van het bestaande ontwerp om te zetten in Flutter code. 

Zodra zowel deze front-end als de tussenlaag rond waren, zijn we over gegaan naar het versturen van deze data naar onze databank. Als databank hebben we gekozen voor **Firebase**. Dit was de eenvoudigste keuze omdat deze in de cloud zit en deze vrij all-in is voor het Flutter platform. Zowel sensordata als authenticatie is opgeslagen in **Firebase**. 

De app is in feite stand-alone. De applicatie zelf is puur gefocused op het connecteren van de sensoren en de data hiervan te sturen naar een centraal punt. Dit betekent dat er tijdens semester 1 geen onderscheid gemaakt tussen een patient, opvolger en administrator op de app zelf.

Link naar Github repo: https://github.com/Thomas-More-Digital-Innovation/2324-MOBI-012-Monitoringapplicatie-Mobile-App 

## Dashboard

Het dashboard was ook een opsplitsing binnen dit project. Als achterliggende databank werd Firebase gebruikt, net zoals bij de mobile app. Dit zorgde ervoor dat de verbinding naar de back-end hetzelfde blijft en het geheel dus minder complex maakt. 

De keuze van platform voor dit dashboard is een wellicht controversiële. We hebben namelijk gekozen voor **Flutter**, net zoals bij de mobile app. Initïeel hebben we getwijfeld tussen **NextJS**, **React** en **Flutter**. Onze eerste keuze ging in principe naar NextJS, alleen zou het gebruik van een andere programmeertaal en andere libraries mogelijks voor een extra complex geheel vormen. We hebben mede gekozen voor Flutter omdat we de connectie met de back-end dan eenvoudigweg konden overnemen van de mobile app, zonder dat er twee verschillende back-ends beheerd zouden moeten worden.

Link naar Github repo: https://github.com/Thomas-More-Digital-Innovation/2324-MOBI-012-Monitoringapplicatie-Web-App

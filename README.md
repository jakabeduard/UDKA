# UDKA

Dokumentáció: Ajtó melletti személyek számának követése lézertávolság mérés alapján (Nexys A7 FPGA használatával)
I. Elméleti megvalósítás:
1. Bevezetés
A célunk egy ajtó mellé elhelyezett rendszer kifejlesztése, amely képes nyomon követni a belépő és kilépő személyek számát. A rendszer működése a két érzékelő lézeres távolságmérő szenzorok segítségével valósul meg, amelyek az ajtó előtt helyezkednek el. A szenzorok az ADC (analóg-digital converter) segítségével csatlakoznak a Nexys A7 FPGA platformhoz. Az FPGA eszköz elemzi a két szenzor által szolgáltatott adatokat, és ennek függvényében kezeli a személyek számát, hozzáadva vagy kivonva azokat egy számlálóból (inkrementális számláló).
2. Működési elv
2.1. Lézeres távolságmérés
A rendszer két lézertávolságmérőt használ. Az érzékelők folyamatosan mérik az ajtó előtt elhaladó személyek mozgását. Az ADC segítségével a mérési adatok digitális formátumban kerülnek feldolgozásra, így az FPGA képes ezeket az adatokat olvasni és értelmezni.
2.2. Szenzorok csatlakoztatása
A lézeres távolságmérő szenzorok analóg jelei az ADC-n keresztül kerülnek továbbításra az FPGA felé. Az ADC feladata, hogy az analóg feszültség jeleket digitális értékekre konvertálja, amelyeket az FPGA feldolgoz. Az FPGA a mért változást összeveti a beállított referenciaértékekkel, amelyek alapján eldönti, hogy melyik irányban halad a személy (belépés vagy kilépés).
2.3. Szenzorok által mért távolságok és az inkrementális számláló
Az ajtón elhelyezett két szenzor különböző pozíciókat érzékel, ami nem is annyira  fontos, esetunkben csak az számit, hogy melyik mér előbb. 
•	Időben ha az első  aztán a második szenzor mér változást:  belépő személyek számára ad információt.
•	Míg időben a második aztán  az első  szenzor mér változást:  a kilépő személyek számáról vonatkozoan  ad információt.

  
Az FPGA az érzékelt irányok alapján vezérli egy inkrementális számláló működését. Ha egy személy belép, a számláló értéke növekszik, míg ha kilép, a számláló értéke csökken.
3. Implementáció a Nexys A7 FPGA-n
3.1. Hardware (Nexys A7)
A Nexys A7 FPGA egy fejlett fejlesztői platform, amely tartalmazza a szükséges analóg-digitális átalakítót, a belső logikai blokkokat és a külső interfészeket a szenzorok csatlakoztatásához. A szenzorok kimenetei az ADC-n keresztül kerülnek az FPGA-ba, ahol a digitális jeleket feldolgozzuk.
3.2. ADC használata
Az ADC szerepe a szenzorok analóg jeleinek digitális értékekre történő konvertálása. Az ADC egy analóg jelet mér, és azt egy bináris kódolt értékké alakítja, amelyet az FPGA képes értelmezni. Az ADC által biztosított adatokat folyamatosan figyelni kell, hogy pontosan meghatározhassuk a személyek mozgását az ajtó előtt.
3.3. FPGA logika
A következő főbb lépések zajlanak az FPGA-n belül:
1.	Az ADC-n keresztül folyamatosan beérkező távolságadatok feldolgozása.
2.	A két szenzor mért értékeinek összehasonlítása időben a beállított referenciaértékekkel.
3.	Az inkrementális számláló növelése vagy csökkentése a belépő vagy kilépő személyek száma szerint.
4.	A számláló aktuális értékének kijelzése, ha szükséges, egy kijelzőn vagy egyéb kimeneti eszközt használva.
3.4. Szoftver és algoritmus
A szoftver, amely az FPGA-n fut, felelős a szenzorok adatainak feldolgozásáért és a számláló logikájának kezeléséért. A következő lépések szükségesek a működéshez:
1.	Adatgyűjtés: Az ADC-ről érkező adatokat folyamatosan figyeljük.
2.	Adatfeldolgozás: Az FPGA összehasonlítja az érzékelők mért távolságait a beállított küszöbértékekkel.
3.	Számláló vezérlés: A mért t időbeli változások alapján a rendszer meghatározza a belépő vagy kilépő személyek számát, és növeli vagy csökkenti a számlálót.
4.	Kimenet: A rendszer a számláló aktuális értékét kiírja egy kijelzőre, vagy más kimeneti eszközre.
4. Használat
1.	Szenzorok telepítése: A két lézeres távolságmérőt az ajtó azonos oldalára kell telepíteni. Az érzékelők az ajtón belépő és kilépő személyeket érzékelik.
2.	Számláló követése: Az FPGA folyamatosan frissíti a személyek számát, és ezt a számot megjeleníti a kimeneti eszközhöz csatlakoztatott kijelzőn.
3.	Bemeneti és kimeneti adatok: A rendszer figyeli, hogy melyik szenzor érzékel hamarabb, és ennek megfelelően növeli vagy csökkenti a számlálót.
5. Konklúzió
Ez a rendszer lehetővé teszi a személyek számának nyomon követését egy ajtón, a lézeres távolságmérő szenzorok és az FPGA alapú adatfeldolgozás kombinálásával. A rendszer képes automatikusan hozzáadni vagy kivonni személyeket a számlálóból, amely segíthet az ajtó előtti mozgás nyomon követésében, például forgalomfigyelés vagy biztonsági alkalmazások esetén.
II. Gyakorlati megvalósítás:
1. Hardver kapcsolás:

   

 
 
Szenzor 1, 2
2. SPI protokol tervezés:
 

 
 
 
 
2. SPI protokol megvalósítása és tesztelése  :
 




 



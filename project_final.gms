Set i Hotspots
 /LESVOS
 SAMOS
 CHIOS
 LEROS
 KOS/;

Parameter r(i) number of refugees at each hotspot
 /LESVOS       8789
 SAMOS         3957
 CHIOS         2100
 LEROS         695
 KOS           1268/;

Parameter priority(i) number of refugees at each hotspot
 /LESVOS       0.93
 SAMOS         1
 CHIOS         0.42
 LEROS         0.27
 KOS           0.60/;

Set j Ports
 /PIRAEUS_PORT
 KERAMOTI_PORT
 RAFINA_PORT
 PERAMA_PORT/;

Set k existing camps
 /SKARAMANGAS
 SCHISTO
 ELEONAS
 ELEFSINA
 LAVRIO
 THIVA
 KATO_MILIA
 VERIA
 DIAVATA
 KAVALA
 VAGIOCHORI
 NEA_KAVALA/;

Set g new mainland camps
/Keratea
Gramatiko
Oinoi
Oinofyta
Petra
Edessa
Dorkas
Palaiokomi
Drama
Xanthi/;


Set w Supply warehouses
/Supermarket1
Supermarket2
Supermarket3
Supermarket4
Supermarket5/;


Parameter rp(k) number of existing refugees at each old camp
 /SKARAMANGAS   1700
 SCHISTO        818
 ELEONAS        486
 ELEFSINA       125
 LAVRIO         251
 THIVA          825
 KATO_MILIA     301
 VERIA          308
 DIAVATA        833
 KAVALA         389
 VAGIOCHORI     349
 NEA_KAVALA     825/;
 
 
Parameter capOldCamp(k) Capacity of each old camp
 /SKARAMANGAS   3224
 SCHISTO        970
 ELEONAS        700
 ELEFSINA       300
 LAVRIO         359
 THIVA          894
 KATO_MILIA     510
 VERIA          364
 DIAVATA        936
 KAVALA         450
 VAGIOCHORI     552
 NEA_KAVALA     1088/;
 
Table distHotspotsToPorts(i,j) 
$ondelim
$include hotspots_to_ports.csv
$offdelim
;

Table distPortsToOldCamps(j,k) 
$ondelim
$include port_to_old_camps.csv
$offdelim
;

Table distPortsToNewCamps(j,g) 
$ondelim
$include port_to_new_camps.csv
$offdelim
;

Table distWarehousesToOldCamps(w,k) 
$ondelim
$include warehouses_to_old_camps.csv
$offdelim
;

Table distWarehousesToNewCamps(w,g) 
$ondelim
$include warehouses_to_new_camps.csv
$offdelim
;

Scalar M                very big nmumber /1e100/;
Scalar truck_fuel        Diesel fuel cost (Euros per l) /1.371/;
Scalar vehicle_consumption Consumption (l per km) /0.22/; 
Scalar truck_capacity Truck capacity /20/;

* Sea transportation scalars
Scalar ship_fuel        Diesel fuel cost (Euros per l) /1.371/;
Scalar ship_consumption Consumption (l per km) /100/; 
Scalar ship_capacity Truck capacity /450/;
Scalar theta   package cost per refugee per day (bottle of water and 2 meals)  /10.5/;


* Setting up the sea and land transportation cost parameters
Parameter seacost(i,j)   Sea transportation cost (Euros);
          seacost(i,j)   = (ship_fuel*ship_consumption*distHotspotsToPorts(i,j))/ship_capacity;

* Assumptions: only one type of ferry boat is used for refugee transportation

Parameter landcostold(j,k)   Land transportation cost (Euros);
          landcostold(j,k)   = (truck_fuel*vehicle_consumption*distPortsToOldCamps(j,k))/truck_capacity;
          
* Assumptions: only Stayer military trucks are used for refugee transportation
Parameter landcostnew(j,g)   Land transportation cost (Euros);
          landcostnew(j,g)   = (truck_fuel*vehicle_consumption*distPortsToNewCamps(j,g))/truck_capacity;
          

Parameter cSupplyOldCamp(w, k)      supply cost from warehouse to camp per refugee for 1 year;
          cSupplyOldCamp(w, k)      = 30* (theta + (truck_fuel*vehicle_consumption*distWarehousesToOldCamps(w,k))/truck_capacity);

Parameter cSupplyNewCamp(w, g)      supply cost from waregouse to camp per refugee for 1 year;
          cSupplyNewCamp(w, g)      = 30* (theta + (truck_fuel*vehicle_consumption*distWarehousesToNewCamps(w,g))/truck_capacity);

Scalar setupCostPerRefugee  setup cost per refugee in a camp in dollars /1000/; 


Scalar capacitySmallCamp        capacity of small camp /600/;
Scalar capacityLargeCamp        capacity of large camp /1100/;

Scalar costLargeCamp        setup cost of large camp;
       costLargeCamp        = setupCostPerRefugee*capacityLargeCamp;
Scalar costSmallCamp        Setup cost of small camp;
       costSmallCamp        = setupCostPerRefugee*capacitySmallCamp; 

$if not set B $set B 1e6
Scalar budget               total budget for transportation supply and setup /%B%/;


Variables
     x1(i,j)             refugees from hotspot i to port j
     x2(j,k)            refugees from port j to camp k (old camps)
     x3(j,g)             refugees from port j to camp g (new camps)
     sOldCamps(w,k)     supplies from warehouse w to old camps k
     sNewCamps(w,g)     supplies from warehouse w to new camps g
     
     uLarge(g)          binary var whether a large warehouse is built
     uSmall(g)          binary var whether a small camp is built  
    
Positive variables x1, x2, x3, sOldCamps, sNewCamps;
Binary variable uLarge, uSmall;

Equations
     capacityOldCamp(k)        capacity at camp k
     capacityNewCamp(g)        capacity at camp g
     pplTransported(j)     all ppl transported to port j must be transported to camps
     refuAvailable(i)   refugees transported less than or equal available
     supplyOld(k)         supply to camp k
     supplyNew(g)         supply to camp g
     cost               budget constraint
     obj                maximize z
     tt                 total number of refugees
     bin(g)             binary vars for small or large camp only one can be selected;     
Variable
     z number of people transferred from ports to camps
     ttt total number of ppl for parsing purposes only;

obj ..   z=e= sum((i,j), priority(i)*x1(i,j));

tt ..    ttt =e= sum((i,j), x1(i,j));

bin(g) ..        uSmall(g)+uLarge(g) =l= 1;
capacityOldCamp(k) ..   rp(k) + sum(j, x2(j,k)) =l= capOldCamp(k);
capacityNewCamp(g) ..   sum(j, x3(j,g)) =l= capacitySmallCamp*uSmall(g) + capacityLargeCamp*uLarge(g);
pplTransported(j) ..     sum(i, x1(i,j)) =e= sum(k, x2(j,k)) + sum(g, x3(j,g));
refuAvailable(i) ..    r(i)=g=sum(j, x1(i,j));
supplyOld(k) ..        sum(j, x2(j, k)) =l= sum(w, sOldCamps(w,k));
supplyNew(g) ..        sum(j, x3(j, g)) =l= sum(w, sNewCamps(w,g));
cost ..          sum((i,j), seacost(i,j)*x1(i,j))
                 + sum((j,k), landcostold(j,k)*x2(j,k))
                 + sum((j,g), (landcostnew(j,g)*x3(j,g)))
                 + sum((w,k), cSupplyOldCamp(w,k)*sOldCamps(w,k))
                 + sum((w,g), cSupplyNewCamp(w,g)*sNewCamps(w,g)) 
                 + sum(g, uLarge(g)*costLargeCamp)
                 + sum(g, uSmall(g)*costSmallCamp)
                    =l= budget;

Model transport /all/ ;
Solve transport  using MIP maximizing z;

Display x1.l, ttt.l, uSmall.l, uLarge.l, cost.l;
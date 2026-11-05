Firstly, the FAR OUT competition rules give some starting conditions. We set our max altitude to 5000 feet above the ground. We are making a Category A rocket, so the total volume of our pressurant and propellant (fuel and oxidizer) must be less than 8 liters. It is also mandated that our rocket Isp is greater than 100 seconds. For safety reasons, the rocket must have a thrust to weight ratio or TWR greater than 8, and greater than 10 for every year after 2027. A higher TWR gives more points, as does a higher Isp. **Therefore the set TWR of the rocket is 12 and the Isp will be set as high as possible given other constraints**.

Starting with parameters of the Mojave Sphinx and the BHR modified design called the Phoenix, both use certain designs that limit certain parameters. Both also are used as examples to give rough estimates for this rockets design. The Phoenix was simply a Mojave Sphinx designed with a smaller engine and a lot of landing hardware.

The Mojave Sphinx uses a pressure blowdown system where the pressure from the tanks forces the propellants into the chamber. Most rockets using this system use an inert pressurant to pressurize the fuel or oxidizer or both. The Mojave sphinx uses liquid nitrous oxide ($N_2O$) and isopropyl alcohol (IPA) for fuel and oxidizer. The liquid nitrous is self-pressurizing and removes the requirement for a pressurant for the oxidizer. The tank design uses a piston to pressurize the fuel using the oxidizer. This creates more risk of explosion because if the seals on the piston fail the propellants mix in the tank, however it removes the need for a pressurant. 

The main decision between using a pressurant system and a piston system is the desired pressure. The current piston design can reach a maximum tank pressure of about 450 psi, which drops to about 300-350 psi over the course of a burn. It is possible to improve this by heating the nitrous inside the propellant tank before launch, which could get the tank pressure up to 750-1000 psi, but the drop in pressure during the burn would still be present as the nitrous vaporizes and cools down again. If a pressurant design is used, the pressure limit is now the yield pressure of the tanks. The Mojave Sphinx used a 1/8" aluminum tube, which at a diameter of 4 inches can hold about 2,000 psi of pressure (need calculation). This comes with limitations on the pressurant dissolving into the fuel and oxidizer, or sudden pressure jumps heating the oxidizer to the point of decomposition. Using a pressurant system also means that some of the tank volume going to the propellants now needs to go to the pressurant, and the total volume of propellant that can be used is now lower. This is the trade off, and some preliminary calculations need to be done to decide which is best (comparing Isp of a higher chamber pressure to the total impulse (which I will reference as deltaV to account for the mass of the rocket) of a larger amount of propellant).

### Weight and Thrust:
The ideal weight of the propellants is the full 8 liter volume filled with the ideal oxidizer to fuel (O/F) ratio for the rocket. This ideal O/F ratio is determined by CEA, but for the sake of a rough calculation it is assumed to be stoichiometric here (preliminary CEA runs show that stoichiometric is close to the best). The stoichiometric O/F for nitrous and IPA is found by the balanced chemical equation below.

$C_3H_8O+9N_2O → 3CO_2+4H_2O+9N_2$

O/F ratio is $\frac{n_{ox}*\mu_{ox}}{n_{fu}*\mu_{fu}}$ where n is the number of moles and $\mu$ is the molecular weight of the compound. 
$\mu_{IPA}=60.10\frac{g}{mol}$
$\mu_{N_2O}=44.013\frac{g}{mol}$
With this, the stoichiometric O/F ratio is 6.591.

Assuming that the pressurant will take 1 liter of the tank volume (hopefully a worst case scenario), 7 liters of propellant at an O/F ratio of 6.591 allows for 6.078 liters of nitrous and 0.922 liters of IPA. Assuming a density of 785 $\frac{kg}{m^3}$ for IPA and 907 $\frac{kg}{m^3}$ for nitrous, the weight of the propellants is about 6.237 kg or 13.75 lbs. 

All the test data for the Sphinx that I have is for half fires, where we added half the fuel and what I am assuming is half the oxidizer. However, I do not know as the numbers were a bit arbitrary, so I am going to compare tank sizes for an estimated mass. The Sphinx tank is a 3.75 inch diameter (from the inside) cylinder that is 30 inches long (accounting for the bulkheads and piston plus some error, it is 35 inches from outside end to end). This gives a volume of 331.34 cubic inches or 5.43 liters. The Sphinx weighed about 55 lbs, so that gives a tank size to weight ratio of 0.098727. Given that we are using 8 liters of tank (7 for propellant 1 for pressurant), the projected weight of the new rocket is 81.03 lbs. This is very heavy, and with the TWR requirement, our engine would have to produce 972 lbs of thrust.

If we assume that the rocket will be more efficient with weight than the Sphinx through design choices, then the rocket could be much lighter and the required thrust could be lower. The Sphinx tank only weighed 10 lbs dry. That means that about 33lbs were coming from just the rocket body. 10 lbs alone were coming from the avionics bay. It is not likely that extreme weight savings could be made, but for a bigger rocket, I believe that the weight could be lowered to 55 to 70 lbs. 

Assuming a rocket weight of 60 lbs, the engine must produce 720 lbs of thrust, so the target thrust is 725 lbs (there is already significant margin in the TWR requirement, so it is not necessary to add more here).

### Pressure Budget
10/27/28

After a discussion with Robert and Jeremy, it is decided that we will use a pressurant system. The pressurant to be used has not been decided since it will have to be a liquid or supercritical fluid at the pressures we need which means potential mixing of the pressurant and propellants in the tanks. This will be resolved later.

For now, the pressurant pressure is assumed to be 8273.71 kPa (1200 psi), which will pressurize the propellant tanks to 6894.76 kPa (1000 psi) due to assumed losses due to temperature of the pressurant and friction losses. It is now required to calculate the chamber pressure attainable with this tank pressure. The new rocket design is a pressure fed blowdown system, with no pumps, cooling channels around the nozzle, venturis, turbines, or pre-burners. This means that a pressure budget from the tanks to the chamber only include the pressure change from the tank to the injector, and the pressure change from the injector to the chamber. For this, the change in pressure from the tank is assumed to follow the equation below.

$\Delta P_{tank}=-\frac{\rho V^2}{2}+h\rho g_0-35kPa$
Where the first term is the pressure loss due to the propellant going from stationary to moving through the pipes (dynamic loss), the second term is the pressure gained by gravity through the pipes, and the last term is the assumed friction loss due to the pipes. For the pressure change over the injector, it is assumed that the injector pressure loss is 20% of the chamber pressure since our engine is not throttled.

See the matlab file pressure_budget.m for the calculations to find the chamber pressure.
Chamber pressure is determined to be 805.61 kPa

### Final List of Starting Parameters
- Thrust: 725 lbs
- Weight: 60 lbs
- Chamber pressure: 5717.91 kPa or 829.31 psi
- Target altitude: 5000 ft
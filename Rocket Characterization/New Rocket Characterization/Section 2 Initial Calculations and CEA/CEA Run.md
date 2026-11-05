Using Chemical Equilibrium with Applications or CEA from NASA, I input the following parameters:

Problem type: Rocket
Pressure: 829.31 psia
Fuel: IPA at 100% at 293 Kelvin
Oxidizer: N2O at 280.37 Kelvin
O/F: 4.5 to 7.5 at steps of 0.25
Final: Keep default settings but select frozen and equilibrium (equilibrium assumes that the propellants burn perfectly, and frozen assumes that all chemical reactions stop at the throat of the nozzle)

Run CEA, click on the output file, and copy paste the CEA output into a text file.

Next, open a CMD terminal in the folder with both the .txt file and cea_csv.py. Type "python cea_to_csv.py XXXXXXX.txt" and replace XXX with the file name of the .txt file. This will create a .csv file that you can then put into excel or matlab. (I use excel because of how the .csv file is formatted, it does not cooperate with excel without some tweaks)

From the excel file in this folder (cea_new_rocket_output2.csv), I have created these graphs for the USAFA nozzle (the one ideally expanded for 8000 feet).

![[Chamber Temp and MW vs OF Ratio.png]]

![[Pasted image 20261104221553.png]]

From this CEA analysis, the ideal O/F Ratio is determined to be 5.0. This will allow for a lower chamber temperature of about 3250K (2976.85C or 5390.33F), while keeping the Isp high, around 260 (assuming the Isp is closer to equilibrium conditions than frozen conditions).

Using the initial conditions from section 1, the mass flow rate can be determined from:
$I_{sp}=\frac{F}{\dot{m}*g_0}$

With this the mass flow rate is determined to be 1.2644 kg/s.
Using the same math from Section 1, 7 liters of propellant at an O/F ratio of 5 becomes 5.8333 liters of nitrous and 1.1667 liters of IPA. At the same densities of 785 $\frac{kg}{m^3}$ for IPA and 907 $\frac{kg}{m^3}$ for nitrous, the weight of the propellants is about 5.2908 kg of nitrous, 0.9159 kg of IPA, and a total mass of 6.2067 kg or 13.683 lbs (which compares to the initial estimate of 6.237 kg or 13.75 lbs).
With the total propellant mass and required mass flow rate, the estimated burn time for this motor is 4.9088 seconds.


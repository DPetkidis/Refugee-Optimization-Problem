# Refugee Optimization Problem 

This project tackles the problems faced by both refugees and the Greek government. It optimises the transfer of the refugees from the overcrowded island hotspots to mainland camps via marine and land routes. At the same time, the possibility of building new camps with different sizes to accommodate more refugees is being examined and the supply provision is optimized to both existing and potentially new camps. All this takes place with respect to a certain budget. Sensitivity analysis is also conducted to evaluate different scenarios based on various budgets.
<br /> The project was part of a scientific poster presentation for the University of Edinburgh.

<br /> The code is written in GAMS, a high-level modeling system for mathematical optimization.

## Running the sensitivity analysis 📈

The budget parameter was considered as a command line input argument to the gams model (B).

A single run of the model could be achieved by excuting the following command from the command line given that gams is correctly installed and confirgured:

```
 gams project_final.gms --B=3e6
```

### Analysis Script 🔧💻

The sensitivity_analysis.sh bash script is used to run the GAMS model under different budgets and then the output files are parsed. 

The script genrates multiple GAMS lst result files named in the following format:
```
runXX.lst  # where XX corresponds to the iteration number
```
The script generates three extra files:
```
* z.txt: contains the maximized value of the objective function. each line corresponds to a budget in sequential order (500,000 - 15,000,000 euros)
* uSmall.txt: contains the number of small camps built (follows same order as z.txt)
* uLarge.txt contains the number of large camp built (follows same order as z.txt)
````

## Poster Layout 📖👈

![Poster (left)](https://user-images.githubusercontent.com/24207683/94851838-e60cdf80-0420-11eb-9651-92d963f57eda.PNG)\
![Poster (center)](https://user-images.githubusercontent.com/24207683/94852070-40a63b80-0421-11eb-8afa-6a1c687685a9.PNG)\
![Poster (right)](https://user-images.githubusercontent.com/24207683/94852087-469c1c80-0421-11eb-9da9-6f1fe42a4b43.PNG)

# ICST-Paper-Submission
# Dead Code Detection

This project aims to detect dead code segments found in Smart Contracts using Model Checker Engines.

## Pre-requisites

### SOLC
We have used Solidity Compiler version 0.8.16 for this project.
```bash 
sudo apt-get install solc
```

### GCC
The C++ compiler used for this project.
```bash
sudo apt-get install build-essential
```

## Getting things ready

For the demostration of this project, we have used [./uploadedFiles/Ballot](Ballot.sol) to identify the dead code segments. To use any other smart contract, please paste it in the uploadedFiles folder and follow the instructions below.

## Running the application

To run the application, open a terminal inside the "Smart Contract Validator" folder.

Use the command
```bash
node app.js
```
to start the program.

You will be prompted to enter the name of the smart contract you want to assess, in this case we enter "Ballot"
You will then be prompted to enter the Model Checker Engine you would like to use. You can enter either "BMC" or "CHC".

The application starts and outputs the results. This might take a few seconds.
You can view the results in the command line interface, or under the Results folder.

## Code

app.js file calls the appropriate shell script depending on the Model Checker Engine chosen.
The shell scripts are [asserterBMC](asserterBMC.sh) and [asseterCHC](asserterCHC.sh).

The shell scripts go through the following steps.

### Comment Remover

We use [Comment_Remover.cpp](Comment_Remover.cpp) to remove the comments present in the smart contract as they might hinder with the results.

### Assertion Injection

To identify the dead code segments, we utilise model checker engines with assertions as targets. Therefore, we use an Assertion Injector [assertionInjector](assertionInjector.cpp) to add assertions at every conditional statement found in the smart contract.

The annotated smart contract is stored in the corresponding Results folder.

### Model Checker Engine

We then proceed to use the model checker engine available in Solidity Compiler, choosing assertions as our model checker targets.

### Result Extractor

The results found by the Model Checker Engine are extracted in a readable format using [Result_Extractor](Result_Extractor.cpp). The results are stored in the corresponding Results folder.

## Results

We detect assertion violations using the Model Checker Engine. Violation detected indicate the conditional statements that do not form a dead code segment, and can therefore be used to establish which conditional statements are never triggered, thus forming a dead code segment block.

## Experiments

We have provided all the smart contracts used for comparative analysis in the paper under the Smart Contracts folder.
To reproduce the results using any of those smart contracts, copy and paste the file into the uploadedFiles folder. (ask rahul and aditya if change needed, should we keep all smart contracts under uploadedFiles in the start itself)
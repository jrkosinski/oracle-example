# ETH Smart Contract Oracles Part 1: Setup and Orientation 

## Intro 

Ethereum Smart Contracts. More than just "the new hot thing", it's my belief that they (or something related) are poised to change the way that humans do business with one another in the upcoming new age of the internet. Time will tell if that's the case. 

This is the first of a three part article on eth smart contract development with Solidity, most specifically exploring the contentious issue of the use of contracts with so-called "oracles" - which are basically contracts which pump data into the blockchain for use by other contracts. 

The goal of this, part 1 of the series, is not to get into oracles, the philosophy behind them, or even very deeply into what they are; the goal of this part is simply to: 
- get you set up with building smart contracts with truffle 
- build a smart contract project which will serve us in parts 2 and 3
- introduce a few concepts related to ethereum smart contracts and coding of smart contracts 
- introduce the compile/run/debug cycle with truffle and smart contracts 


### Software Requirements 
- any major OS will work, though some of the installation & setup will of course be different. I have done all of this on ubuntu Linux (16.04). I have also had no problems setting up the environment on windows. I have not tried Mac, though I am aware that it's common to do so on Mac as well. 
- it is not necessary to run a full eth node; we will use truffle which comes with its own testnet. If you know a bit about what you're doing you can use any other testnet of your choosing; truffle's local dev testnet is just the easiest & most accessible for purposes of this tutorial. 

### Knowledge Requirements 
- basic knowledge of how blockchain works 
- understanding of what a blockchain-based smart contract is 
- some basic hello-worldish experience with smart contract development will be helpful, but not necessary if you're smart & ambitious (and I know that you are) 

This article series *can* serve as a very first introduction to smart contracts, but it ramps up very quickly into more advanced concepts. If it's your first eth smart contract tutorial, be prepared to climb to altitude quickly. If you feel confident, great; if not, feel free to get a simpler 'hello world' type of tutorial or two under your belt first. Here are a few, for example: 

- https://cryptozombies.io/
- https://codeburst.io/build-your-first-ethereum-smart-contract-with-solidity-tutorial-94171d6b1c4b

A caveat: the smart contract space, being so new, changes quickly. Solidity syntax features that were new when this article was written may be deprecated or obsoleted by the time you're reading this. Geth versions may have come & go. So, be prepared if necessary to adapt the information in this article to the new landscape of the future; if you're serious about learning smart contract development, then I have faith in you. 


### Description of Example App

Use case: betting on boxing matches. Users can choose a boxing match, and make a bet on the winner (for simplicity's sake, you just pick the winner, nothing more fancy than that). When the winner is declared, the house (contract owner) takes a predetermined and transparent cut, the losers lose their stake, and the winners split the pot. The amount of the winners' take is determined by the size of their bet. 

#### Brief Introduction: What is an Oracle?

Smart contracts are a new thing, they've yet to take the mainstream, and so many aspects of how they will work have not yet been hammered out and standardized. I will briefly explain the impetus behind the idea of the "oracle", and - be patient - we'll get into it in more depth in later parts. 

Programming blockchain contracts is not like programming a client-server app. All data with which the contract interacts, must already be on the blockchain. There is no calling *out* of the blockchain. Not only is it not supported by the language, it's not supported by the blockchain paradigm. The contract can take bets in the form of ethereum currency, store them in the contract, and release them to the correct wallet addresses according to a formula, when the winner of a match is declared. But how does the contract know the winner? It can't query a REST API or anything like that. It can only use data that's already in the blockchain! Many many use cases of smart contracts run into a similar problem - they are seriously limited unless they can interact with the world outside the blockchain. 

If the contract can only interact with data on the blockchain, an obvious solution is to inject the necessary data into the blockchain. And that's what an oracle is. An oracle is another contract, which injects data into the blockchain, allowing other contracts to consume it. While that may raise questions about trust and trustlessness, just accept for now that that's what an oracle is. In our example use case, the oracle will be the contract that injects data about boxing matches into the blockchain, and the winners of those matches. 

## Setup 

For basic setup, we will install: 
- geth (optional for now)
- truffle 
- ganache-cli (optional)
- a development environment (optional) 

This article does not have the space to be a full guide to setup of the environment, but acts as just a rough guide; but that's ok because there are already plenty of more complete setup guides for your particular OS, and the internet doesn't really need a new one. So I will take you quickly down the path, and point you towards some resources for getting more details as needed. Be prepared to install requirements and prereqs, as your system requires and as google directs you. 

### Install geth (optional) 
Geth is go-ethereum, the ethereum core software; while it's not necessary for this exercise at all, it would behoove any would-be ethereum developer to have it & be familiar with it. It will be necessary if you're ever going to deploy your smart contract to the live ethereum network. 
- http://www.talkcrypto.org/blog/2018/01/23/what-is-geth/
- https://github.com/ethereum/go-ethereum/wiki/Installation-Instructions-for-Ubuntu
- https://github.com/ethereum/go-ethereum/wiki/Installation-instructions-for-Windows

### Install truffle 
Truffle is the main thing we're going to use for development, and absolutely is a requirement for this guide. Find & follow the specific instructions for your OS to install truffle. Below are some links that will hopefully help you. 
- https://truffleframework.com/docs/truffle/getting-started/installation
- https://github.com/trufflesuite/truffle
- https://truffleframework.com/tutorials/how-to-install-truffle-and-testrpc-on-windows-for-blockchain-development

### Install ganache-cli (optional) 
I recommend installing ganache-cli to use as another testing tool, though we won't actually use it for our tutorial. It's optional. 
- https://github.com/trufflesuite/ganache-cli

### Development Environment 
It would be more than possible to do this whole tutorial with any simple text editor, like Notepad++, gedit, vi, or any text editor or IDE of your choosing. I personally am using Visual Studio Code with the following extensions: 
- solidity
- solidity extended 
- material icon theme 

(the extensions are not required, they just make for a better coding environment) 

## Running the Code 


## Separate the Oracle 


## Testing and Debugging 


## Conclusion 

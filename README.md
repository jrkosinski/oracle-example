# ETH Smart Contract Oracles Part 2: Solidity Code Features

## Intro 

In the last (1st) segment of this three-parter, we went through a little tutorial that gave us a simple contract-with-oracle pair. The mechanisms and processes of getting set up (with truffle), compiling the code, deploying to a test network, running and debugging was described; however many of the details of the code were glossed over in a hand-wavy manner. So now as promised, we'll get into looking at some of those language features which are unique to Solidity smart contract development, and unique to this particular contract-oracle scenario. While we can't painstakingly look at every single detail (I will leave that to you in your further studies, if you wish), we will try to hit upon the most striking, most interesting, and most important features of the code. 

In order to facilitate this, I recommend that you open up either your own version of the project (if you have one), or have the code handy for reference. The full code at this point can be found here: 
[https://github.com/jrkosinski/oracle-example/tree/part2-step1](https://github.com/jrkosinski/oracle-example/tree/part2-step1)

## Solidity 

Solidity is not the only smart contract development language available, but I think it's safe enough to say that it's the most common and most popular in general, for Ethereum smart contracts. Certainly it's the one that has the most popular support and information, at the time of this writing. Solidity is object-oriented and Turing-complete. That said, you will quickly realize its built-in (and fully intentional) limitations, which make smart contract programming feel quite different from ordinary let's-do-this-thing hacking. 

### Solidity Version 

The first line of every Solidity code poem: 
`
pragma solidity ^0.4.17;
`
The version numbers that you see are going to differ, as Solidity, still in its youth, is changing quickly. 0.4.17 is the version that I've used in my examples; latest version at time of this writing is 0.4.25. The latest version at this time you're reading this may well be something different. Many nice features are in the works (or at least planned) for Solidity, which we will discuss presently. 

[Solidity versions](https://github.com/ethereum/solidity/releases)

Pro tip: you can also specify a range of versions (though I don't see this done too often), like so:
`
pragma solidity >=0.4.16 <0.6.0;
`

### Language Features 

Solidity has many language features that are familiar to most modern programmers, as well as some that are distinct and (to me at least) unusual. It's said to have been inspired by C++, Python and JavaScript - all of which are well familiar to me personally, and yet Solidity seems quite distinct from any of those languages. 

#### contract 

The .sol file is the basic unit of code. In [BoxingOracle.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/BoxingOracle.sol), note the 37th line:  
`
contract BoxingOracle is Ownable {
` 

As the class is the basic unit of logic in object-oriented languages, the contract is the basic unit of logic in Solidity. Suffice it to simplify it for now to say that the contract is the 'class' of Solidity (for object-oriented programmers this is an easy leap). 

#### constructors 

#### inheritance 
		- support multiple inheritance? 

Solidity contracts fully support inheritance, and it works as you'd expect; private contract members are not inherited, whereas protected and public ones are. Overloading and polymorphism are supported as you'd expect. 

`
contract BoxingOracle is Ownable {
` 

In the above statement, the "is" keyword is denoting inheritance. BoxingOracle inherits from Ownable. Multiple inheritance is also supported in Solidity. Multiple inheritance is indicated by a comma-delimited list of class names, like so: 

`
contract Child is ParentA, ParentB, ParentC {
...
`

While (in my opinion) it's not a good idea to get overly intricate with when structuring your inheritance model, here's an interesting article on Solidity in regard to the so-called "Diamond Problem": 
[https://ethereum.stackexchange.com/questions/21060/multiple-inheritance-and-linearization](https://ethereum.stackexchange.com/questions/21060/multiple-inheritance-and-linearization)

#### enums 

Enums are supported in Solidity: 

`
    enum MatchOutcome {
        Pending,    //match has not been fought to decision
        Underway,   //match has started & is underway
        Draw,       //anything other than a clear winner (e.g. cancelled)
        Decided     //index of participant who is the winner 
    }
`

As you'd expect (not different from familiar languages), each enum value is assigned an integer value, beginning with 0. As stated in the Solidity docs, enum values are convertible to all integer types (e.g. uint, uint16, uint32, etc), but implicit conversion is not allowed. Which means that they must be cast explicity (to uint, for example). 

[Solidity Docs: Enums](https://solidity.readthedocs.io/en/develop/types.html#enums)
[Enums Tutorial](https://boostlog.io/@bily809/solidity-tutorial-5-5abf43ed0814730093a2f00e) 

#### structs 

Structs are another way, like enums, to create a user-defined data type. Structs are familiar to all C/C++ foundation coders and old guys such as myself. An example of a struct, from line 45 of [BoxingOracle.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/BoxingOracle.sol): 

`
//defines a match along with its outcome
    struct Match {
        bytes32 id;
        string name;
        string participants;
        uint8 participantCount;
        uint date; 
        MatchOutcome outcome;
        int8 winner;
    }
`

Note to all old C programmers: struct "packing" in Solidity is a thing, but there are some rules and caveats. Don't necessarily assume that it works the same as in C; check the docs and be aware of your situation, to ascertain whether or not packing is going to help you in a given case. 

[Solidity Struct Packing](https://solidity.readthedocs.io/en/v0.4.21/miscellaneous.html) 

Once created, structs can be addressed in your code as native data types. Here's an example of the syntax for 'instantiation' of the struct type created above: 

`
Match match = Match(id, "A vs. B", "A|B", 2, block.timestamp, MatchOutcome.Pending, 1); 
`

#### data types 
	
This brings us to the very basic subject of data types in Solidity. What data types does solidity support? Solidity is statically-typed, and at the time of this writing data types must be explicitly declared and bound to variables. 

[Solidity Data Types](https://solidity.readthedocs.io/en/v0.4.24/types.html)

##### Booleans 

Boolean types are supported under the name *bool* and values *true* or *false*

##### Numeric types 

Integer types are supported, both signed and unsigned, from int8/uint8 to int256/uint256 (that's 8-bit integers to 256-bit integers, respectively). The type uint is shorthand for uint256 (and likewise int is short for int256). 

Notably, floating-point types are *not* supported. Why not? Well, for one thing, when dealing with monetary values, floating-point variables are well known to be a bad idea (in general of course), because value can be lost into thin air. Ether values are denoted in wei, which is 1/1000000000000000000th of an ether, and that must be enough precision for all purposes; you cannot break an ether down into smaller parts. 

Fixed point values are partially supported at this time. According to the Solidity docs: *Fixed point numbers are not fully supported by Solidity yet. They can be declared, but cannot be assigned to or from.* 

[https://hackernoon.com/a-note-on-numbers-in-ethereum-and-javascript-3e6ac3b2fad9](https://hackernoon.com/a-note-on-numbers-in-ethereum-and-javascript-3e6ac3b2fad9)

**NOTE**: in most cases, it's better to just use uint, as decreasing the size of the variable (to uint32, for example), can actually increase gas costs rather than decrease them as you might expect. As a general rule of thumb, use uint unless you are certain you have a good reason for doing otherwise. 

##### String Types 

There is also no string data type in Solidity There are good reasons for these omissions, please believe me. 


##### Date types 

There is no native Date type in Solidity per se, as there is in Javascript for example (oh no, Solidity's sounding worse & worse with every paragraph!?). Dates are natively addressed as timestamps of type uint (uint256). They are generally handles as Unix-style timestamps (seconds rather than milliseconds), as the block timestamp is a unix-style timestamp. In cases where you find yourself needing human-readable dates for various reasons, there are open-source libraries available. You might notice that I've used one in BoxingOracle: 
[DateLib.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/DateLib.sol). OpenZeppelin also has date utilities as well as many other types of general utility libraries. (We'll get to the *library* feature of Solidity shortly) 


		- address 
		- link to 
#### mappings 
#### return values 
		- cannot do structs 
		- tuples 
#### require 
#### modifiers 
		- underscore
		- msg.sender 

#### import 

## BoxingBets: the Client Contract 

## BoxingOracle: the Oracle Contract 

## Conclusion 

## Further Optional Steps

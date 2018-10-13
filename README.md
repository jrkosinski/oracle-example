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

#### Contract 

The .sol file is the basic unit of code. In [BoxingOracle.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/BoxingOracle.sol), note the 9th line:  

`
contract BoxingOracle is Ownable {
` 

As the class is the basic unit of logic in object-oriented languages, the contract is the basic unit of logic in Solidity. Suffice it to simplify it for now to say that the contract is the 'class' of Solidity (for object-oriented programmers this is an easy leap). 

#### Inheritance 

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

#### Enums 

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

#### Structs 

Structs are another way, like enums, to create a user-defined data type. Structs are familiar to all C/C++ foundation coders and old guys such as myself. An example of a struct, from line 17 of [BoxingOracle.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/BoxingOracle.sol): 

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

#### Data Types 
	
This brings us to the very basic subject of data types in Solidity. What data types does solidity support? Solidity is statically-typed, and at the time of this writing data types must be explicitly declared and bound to variables. 

[Solidity Data Types](https://solidity.readthedocs.io/en/v0.4.24/types.html)

##### Booleans 

Boolean types are supported under the name *bool* and values *true* or *false*

##### Numeric types 

Integer types are supported, both signed and unsigned, from int8/uint8 to int256/uint256 (that's 8-bit integers to 256-bit integers, respectively). The type uint is shorthand for uint256 (and likewise int is short for int256). 

Notably, floating-point types are *not* supported. Why not? Well, for one thing, when dealing with monetary values, floating-point variables are well known to be a bad idea (in general of course), because value can be lost into thin air. Ether values are denoted in wei, which is 1/1000000000000000000th of an ether, and that must be enough precision for all purposes; you cannot break an ether down into smaller parts. 

Fixed point values are partially supported at this time. According to the Solidity docs: *Fixed point numbers are not fully supported by Solidity yet. They can be declared, but cannot be assigned to or from.* 

[https://hackernoon.com/a-note-on-numbers-in-ethereum-and-javascript-3e6ac3b2fad9](https://hackernoon.com/a-note-on-numbers-in-ethereum-and-javascript-3e6ac3b2fad9)

**NOTE**: in most cases, it's best to just use uint, as decreasing the size of the variable (to uint32, for example), can actually increase gas costs rather than decrease them as you might expect. As a general rule of thumb, use uint unless you are certain you have a good reason for doing otherwise. 

##### String Types 

The string data type in Solidity is a funny subject; you may get different opinions depending on who you talk to. There is a string data type in Solidity, that is a fact. My opinion, probably shared by most, is that it doesn't offer much functionality. String parsing, concatenation, replace, trim, even counting the length of the string: all of those things you've likely come to expect from a string type are not present, and so are your responsibility (if you need them). Some people use bytes32 in place of string; that can be done as well. 

[fun article about Solidity strings](https://hackernoon.com/working-with-strings-in-solidity-c4ff6d5f8008)

My opinion: it might be a fun exercise to write your own string type and publish it for general use. 

##### Address Type

Unique perhaps to Solidity, we have an *address* datatype, specifically for Ethereum wallet or contract addresses. It's a 20 byte value specifically for storing addresses of that particular size. In addition, it has type members specifically for addresses of that kind. 

`
address internal boxingOracleAddr = 0x145ca3e014aaf5dca488057592ee45305d9b3a22; 
`

[Address Data Types](https://ethereum.stackexchange.com/questions/34024/when-exactly-address-datatype-should-be-used)

##### DateTime Types 

There is no native Date or DateTime type in Solidity per se, as there is in Javascript for example (oh no, Solidity's sounding worse & worse with every paragraph!?). Dates are natively addressed as timestamps of type uint (uint256). They are generally handles as Unix-style timestamps (seconds rather than milliseconds), as the block timestamp is a unix-style timestamp. In cases where you find yourself needing human-readable dates for various reasons, there are open-source libraries available. You might notice that I've used one in BoxingOracle: 
[DateLib.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/DateLib.sol). OpenZeppelin also has date utilities as well as many other types of general utility libraries (We'll get to the *library* feature of Solidity shortly).
Pro tip: [OpenZeppelin](https://openzeppelin.org/) is a good source (but of course not the only good source) for both knowldege and pre-written generic code that may help you to build your contracts up. 

#### Mappings 

Notice that line 11 of [BoxingOracle.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/BoxingOracle.sol) defines something called a *mapping*: 

`
mapping(bytes32 => uint) matchIdToIndex;
`

A mapping in Solidity is a special data type for quick lookups; essentially a lookup table or similar to a hashtable, wherein (in this case) the data contained lives on the blockchain itself (when the mapping is defined, as it is here, as a class member). During the course of the contract's execution, we can add data to the mapping (similar to adding data to a hashtable), and later look up those values that we've added. Note again that in this case, the data that we addd is added to the blockchain itself, so it will persist. If we add it to the mapping today in New York, some guy a week from now in Istanbul can read it. 

Example of adding to the mapping, from line 71 of [BoxingOracle.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/BoxingOracle.sol): 

`
matchIdToIndex[id] = newIndex+1
`

Example of reading from the mapping, from line 51 of [BoxingOracle.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/BoxingOracle.sol): 
`
uint index = matchIdToIndex[_matchId]; 
`

Items can also be removed from the mapping. It's not used in this project, but it would look like this: 

`
delete matchIdToIndex[_matchId];
`
 
#### Return Values 

As you may have noticed, Solidity may have a bit of a superficial resemblance to Javascript, but it does not inherit much of Javascript's looseness of types and definitions. A contract code must be defined in a rather strict and restricted manner (and this is probably a good thing, considering the use case). With that in mind, consider the function definition from line 40 of [BoxingOracle.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/BoxingOracle.sol)

`
function _getMatchIndex(bytes32 _matchId) private view returns (uint) { ... }
`

Ok so, let's first just do a quick overview of what's contained here. *function* marks it as a function. *_getMatchIndex* is the function name (the underscore is a convention that indicates a private member - we will discuss later). It takes one argument, named *_matchId* (this time the underscore convention is used to denote function arguments) of type *bytes32*. The keyword *private* actually makes the member private in scope, *view* tells the compiler that this function does not modify any data on the blockchain, and finally: 

`
returns (uint)
`

This says that the function returns a uint (a function that returns void would simply have no *returns* clause here). Why is uint in parentheses? That's because Solidity functions can and often do return *typles*. 

Consider now, the following definition from line 166: 

`
function getMostRecentMatch(bool _pending) public view returns (
        bytes32 id,        
        string name,         
        string participants,        
        uint8 participantCount,        
        uint date,         
        MatchOutcome outcome,         
        int8 winner) { ... }
`

Check out the return clause on this one! It returns one, two... 7 different things. Ok so, this function returns these things as a tuple. Why? In the course of developing, you will often find yourself needing to return a struct (if it was Javascript you'd want to return a json object, probably). Well, as of this writing (in the future this may change) Solidity doesn't support returning structs from public functions. So you have to return tuples instead. If you're a Python guy you may be comfortable with tuples already. Many languages don't really support them though, at least not in this way. 

See line 159 for an example of returning a tuple as a return value: 

`
return (_matchId, "", "", 0, 0, MatchOutcome.Pending, -1);
`

And how do we accept the return value of something like this? We can do like so: 

`
var (id, name, part, count, date, outcome, winner) = getMostRecentMatch(false); 
`

Alternatively, you can declare the variables explicitly beforehand, with their correct types: 

`
//declare the variables 
bytes32 id; 
string name; 

... etc... 

int8 winner; 

//assign their values 
(id, name, part, count, date, outcome, winner) = getMostRecentMatch(false); 
`

And now we have declared 7 variables to hold the 7 return values, which we can now use. Otherwise, supposing that we wanted just only one or two of the values, we can say: 

`
//declare the variables 
bytes32 id; 
uint date;

//assign their values 
(id,,,,date,,) = getMostRecentMatch(false); 
`

See what we did there? We got just the two that we were interested in. Check out all of those commas ... we have to count them carefully! 		

#### Imports 

Lines 3 and 4 of [BoxingOracle.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/BoxingOracle.sol) are imports: 

`
import "./Ownable.sol";
import "./DateLib.sol";
`
As you probably expect, these are importing definitions from code files that exist in the same contracts project folder as BoxingOracle.sol. 

#### Modifiers 

Notice that the function definitions have a bunch of modifiers attached. First, there is visibility: private, public, internal, and external. [function visibility](https://forum.ethereum.org/discussion/3344/function-visibility-whats-the-difference-between-private-and-internal-if-any). 

Furthermore, you'll see keywords *pure* and *view*. These indicate to the compiler what sort of changes the function will make, if any. This is important because such a thing is a factor in the final gas cost of running the function. See here for explanation: 
[Solidity Docs](https://solidity.readthedocs.io/en/v0.4.24/contracts.html)

Finally, what I really want to discuss, are custom modifiers. Have a look at line 61 of [BoxingOracle.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/BoxingOracle.sol): 

`
function addMatch(string _name, string _participants, uint8 _participantCount, uint _date) onlyOwner public returns (bytes32) {
`

Note the *onlyOwner* modifier just before the "public" keyword. This indicates that *only the owner* of the contract may call this method! While very important, this is not a native feature of Solidity (though maybe it will be in the future). Actually, "onlyOwner" is an example of a custom modifier that we create ourselves, and use. Let's have a look. 

First, the modifier is defined in the file [Ownable.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/Ownable.sol), which you can see we have imported on line 3 of [BoxingOracle.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/BoxingOracle.sol): 

`
import "./Ownable.sol"
`

Note that, in order to make use of the modifier, we've made *BoxingOracle* inherit from *Ownable*. Inside of [Ownable.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/Ownable.sol), on line 25, we can find the definition for the modifier inside of the *Ownable* contract: 

`
modifier onlyOwner() {
	require(msg.sender == owner);
	_;
}
`

(this Ownable contract, by the way, is taken from one of [OpenZeppelin](https://openzeppelin.org/)'s public contracts)

Note that this thing is declared as a modifier, indicating that we can use it as we have, to modify a function. Note that the meat of the modifier is a 'require' statement. Require statements are kind of like asserts, but not for debugging. If the condition of the require statement fails, then the function will throw an exception. So to paraphrase this "require" statement: 

`
require(msg.sender == owner);
`

We could say it means: 

`
if (msg.send != owner) 
	throw an exception; 
`

And in fact, in Solidity 0.4.22 and higher, we can add an error message to that require statement: 

`
require(msg.sender == owner, "Error: this function is callable by the owner of the contract, only"); 
`

Finally, in the curious-looking line: 

`
_; 
`

... the underscore is short-hand for "here execute the full content of the modified function". So in effect, the require statement will be executed first, followed by the actual function. So it's like pre-pending this line of logic to the modified function. 

There are of course more things that you can do with modifiers. Check the docs: [Docs](https://solidity.readthedocs.io/en/v0.4.24/common-patterns.html) 


## Libraries 

There is a language feature of Solidity known as the *library*. We have an example in our project, at [DateLib.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/DateLib.sol). 

This is a library for better easier handling of date types. It's imported into BoxingOracle at line 4: 

`
import "./DateLib.sol";
`

... and it's used at line 13: 

`
using DateLib for DateLib.DateTime;
`

*DateLib.DateTime* is a struct that's expored from the DateLib contract (it's exposed as a member, see line 4 of [DateLib.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/DateLib.sol)) and we're declaring here that we're "using" the DateLib library for a certain data type. So the methods and operations declared in that library will apply to the data type that we've said it should. That's is how a library is used in Solidity. 

For a more clear example, check out some of [OpenZeppelin](https://openzeppelin.org/)'s libraries for numbers, such as [SafeMath](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol). These can be applied to native (numeric) Solidity data types (whereas here we've applied a library to a custom data type), and are widely used. 

## Interfaces 

As in mainstream object-oriented languages, interfaces are supported. Interfaces in Solidity are defined as contracts, but the function bodies are omitted for the functions. For an example of an interface definition, see [OracleInterface.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/client/contracts/OracleInterface.sol). In this example, the interface is used as a stand-in for the oracle contract, the content of which resides in a separate contract with a separate address. 

## Naming Conventions 

Of course, naming conventions are not a global rule; as programmers, we know that we're free to follow the coding and naming conventions that appeal to us. On the other hand, we do want others to feel comfortable reading and working with our code, so some degree of standardization is desirable. 

## Project Overview

So now that we've gone over some general language features present in the code files in question, we can begin to take a more specific look at the code itself, for this project. 

So, let's clarify the purpose of this project, once again. The purpose of this project is to provide a semi-realistic (or pseudo-realistic) demonstration and example of a smart contract that uses an oracle. At its heart, this is just a contract calling into another separate contract. 

The business case of the example can be stated as such: 
- A user wants to make bets of varying sizes on boxing matches, paying money (ether) for the bets and collecting his/her winnings when and if he/she wins. 
- A user makes these bets via a smart contract (in a real-life use case, this would be a full DApp with a web3 front end; but we are only examining the contracts side) 
- A separate smart contract - the oracle - is maintained by a third party. Its job is to maintain a list of boxing matches with their current states (pending, in progress, finished, etc.) and, if finished, the winner. 
- The main contract gets lists of pending matches from the oracle, and presents these to users as "bettable" matches. 
- The main contract accepts bets up until the start of a match
- After a match is decided, the main contract divvies up the winnings and losings according to a simple algorithm, takes a cut for itself, and pays out the winnings upon request (losers simply lose their entire stake). 

The betting rules: 
- There is a defined, minimum bet (defined in wei) 
- There is no maximum bet; users can bet any amount that they like, above the minimum
- Users can place bets up until such time as the match becomes "in progress" 

Algorithm for dividing the winnings: 
- All bets received are placed into a "pot"
- A small percentage is removed from the pot, for the house
- Each winner gets awarded a proportion of the pot, directly proportional to the relative size of their bets
- Winnings are calculated as soon as the very first user requests the results, after the match is decided
- Winnings are awarded upon request by the user 
- In case of a draw, no one wins - everyone gets their stake back, and the house takes no cut


![architecture](/images/oracle-flow.png)


## BoxingOracle: the Oracle Contract 

### Main Functions Provided

The oracle has two interfaces, you could say: one presented to the "owner" and maintainer of the contract, and one presented to the general public; that is, contracts which consume the oracle. The the maintainer, it offers functionality for feeding data into the contract; essentially taking data from the outside world and putting it onto the blockchain. To the public, it offers read-only access to said data. It's important to note that the contract itself restricts non-owners from editing any data, but read-only access to that data is publicly granted without restriction. 

To users: 
- List all matches 
- List pending matches 
- Get details of a specific match 
- Get status and outcome of a specific match 

To owner: 
- Enter a match 
- Change status of match 
- Set outcome of match 

User story: 
- A new boxing match is announced and confirmed for May 9th. 
- I, the contract's maintainer (perhaps I am a well-known sports network or a new outlet), add the upcoming match to the oracle's data on the blockchain, with the status "pending". Anyone or any contract may now query and use this data however they like. 
- When the match begins, I set the status of that match to "in progress". 
- When the match ends, I set the status of the match to "completed", and modify the match data to denote the winner. 

### Oracle Code Review 

This review is based entirely on [BoxingOracle.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/oracle/contracts/BoxingOracle.sol); line numbers reference that file.

On lines 10 and 11, we declare our storage place for Matches: 

`
	Match[] matches; 
	mapping(bytes32 => uint) matchIdToIndex; 
`

*matches* is just a simple array for storing Match instances, and the mapping is just a facility for mapping a unique match id (a bytes32 value) to its index in the array. So that if someone hands us a raw id of a match, we can use this mapping to locate it. 

On line 17, our Match structure is defined and explained: 

`
    //defines a match along with its outcome
    struct Match {
        bytes32 id;             //unique id
        string name;            //human-friendly name (e.g. Jones vs. Holloway)
        string participants;    //a delimited string of participant names
        uint8 participantCount; //number of participants (always 2 for boxing matches!) 
        uint date;              //GMT timestamp of date of contest
        MatchOutcome outcome;   //the outcome (if decided)
        int8 winner;            //index of the participant who is the winner
    }

    //possible match outcomes 
    enum MatchOutcome {    
        Pending,    //match has not been fought to decision       
        Underway,   //match has started & is underway        
        Draw,       //anything other than a clear winner (e.g. cancelled)        
        Decided     //index of participant who is the winner         
    }
`

Line 61: function *addMatch* is for use only by the contract owner; it allows for the addition of a new match to the stored data. 

Line 80: function *declareOutcome* allows the contract owner to set a match as "decided", setting the participant who won. 

Lines 102-166: the following functions are all callable by the public. This is the read-only data that is open to the public in general: 
- function *getPendingMatches" returns a list of ids of all matches whose current state is Pending. 
- function *getAllMatches* returns a list of ids of all matches. 
- function *getMatch* returns the full details of a single match, specified by id. 

Lines 193-204 declare functions that are mainly for testing, debugging, and diagnostics. 
- function *testConnection* just tests that we are able to call the contract 
- function *getAddress* returns the address of this contract 
- function *addTestData* adds a bunch of test matches to the list of matches 

Feel free to explore around the code a bit before moving on to the next steps. I suggest running the oracle contract again in debug mode (as described in Part 1 of this series), call different functions, and examine the results. 

## BoxingBets: the Client Contract 

It's important to define what the client contract (the betting contract) is responsible for, and what it's not responsible for. The client contract is *not* responsible for maintaining lists of real boxing matches or declaring their outcomes. We "trust" (yes I know, there's that sensitive word - uh oh - we will discuss in Part 3) the oracle for that service. The client contract is responsible for accepting bets. It's responsible for the algorithm that divvies up the winnings, and transfers them to the winners' accounts, based on the outcome of the match (as received from the oracle). 

Furthermore, everything is pull-based, there are no events or pushes. The contract pulls data in from the oracle. The contract pulls the outcome of the match from the oracle (in response to user request), and the contract calculates winnings and transfers them in response to user request. 

### Main Functions Provided
- List all pending matches 
- Get details of a specific match 
- Get status and outcome of a specific match 
- Place a bet 
- Request/receive winnings

### Client Code Review 

This review is based entirely on [BoxingBets.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/client/contracts/BoxingBets.sol); line numbers reference that file.

Lines 12 and 13, the first lines of code in the contract, define some mappings in which we'll store our contract's data. 
Line 12 maps user addresses to lists of ids. This is mapping a user to a list of ids of bets which belong to the user. So, for any given user address, we can quickly get a list of all bets that have been made by that user. 

`
    mapping(address => bytes32[]) private userToBets;
`

Line 13 maps a match's unique id, to a list of Bet instances. With this we can, for any given match, get a list of all bets that have been made for that match. 

`
    mapping(bytes32 => Bet[]) private matchToBets;
`

Lines 17 and 18 are related to the connection to our oracle. First, in the *boxingOracleAddr* variable, we store the address of the oracle contract (set to zero by default). We could hard-code the oracle's address, but then we'd never be able to change it (not being able to change the oracle's address could be a good or bad thing - we can discuss in Part 3). The next line creates an instance of the oracle's interface (which is defined in [OracleInterface.sol](https://github.com/jrkosinski/oracle-example/blob/part2-step1/client/contracts/OracleInterface.sol)) and stores it in a variable. 

`
    //boxing results oracle     
    address internal boxingOracleAddr = 0;    
    OracleInterface internal boxingOracle = OracleInterface(boxingOracleAddr); 
`

If you jump ahead to line 58, you'll see the *setOracleAddress* function, in which this oracle address can be changed, and in which the *boxingOracle* instance is re-instantiated with a new address. 

Line 21 defines our minimum bet size, in **wei**. This is of course actually a very small amount, just 0.000001 ether. 

![wei](/images/nowei.jpg)

`
    uint internal minimumBet = 1000000000000;
` 

On lines 58 and 66 respectively, we have the *setOracleAddress* and the *getOracleAddress* functions. The *setOracleAddress* has the *onlyOwner* modifier, because only the owner of the contract can switch out the oracle for another oracle (probably not a good idea! but we will discuss in Part 3). The *getOracleAddress* function, on the other hand, is publicly callable; anyone can see what oracle is being used. 

`
function setOracleAddress(address _oracleAddress) external onlyOwner returns (bool) {...

function getOracleAddress() external view returns (address) { ....
`

On lines 72 and 79, we have the *getBettableMatches* and *getMatch* functions, respectively. Note that these are simply forwarding the calls on to the oracle, and returning the result.  

`
function getBettableMatches() public view returns (bytes32[]) {...

function getMatch(bytes32 _matchId) public view returns ( ....
`

The *placeBet* function is a very important one (line 108). 

`
function placeBet(bytes32 _matchId, uint8 _chosenWinner) public payable { ...
`

A striking feature of this one is the *payable* modifier; we've been so busy discussing general language features that we have not yet touched upon the centrally important feature of being able to send money along with function calls! That's basically what it is - it's a function which can accept an amount of money along with any other arguments and data sent. 

We need this here because this is where the user simultaneously defines what bet they're going to make, how much money they intend to have riding on that bet, and actually send the money. The *payable* modifier enables that. Before accepting the bet, we do a bunch of checks to ensure the validity of the bet. The first check on line 111 is: 

`
require(msg.value >= minimumBet, "Bet amount must be >= minimum bet");
`

The amount of money sent is stored in *msg.value*. Assuming that all of the checks pass, on line 123 we will transfer that amount into ownership of the oracle, taking ownership of that amount away from the user, and into the contract's possession:

`
address(this).transfer(msg.value);
`

Finally, on line 136, we have a testing/debugging helper function that will help us to know whether or not the contract is connected to a valid oracle: 

`
    function testOracleConnection() public view returns (bool) {    
        return boxingOracle.testConnection();         
    }
`

## Conclusion 

*And this is actually as far as this example goes; just accepting the bet.* The functionality for dividing up the winnings and paying out, as well as some other logic was intentionally left out, in order to keep the example simple enough for our purpose, which is simply to demonstrate the use of an oracle with a contract. That more complete and complex logic exists in another project currently, which is an extension of this example and is still in development. 

So now we have a better understanding of the codebase, and have used it as a vehicle and jumping-off point to discuss some of the language features offered by Solidity. The main purpose of this three-part series is to demonstrate and discuss the use of a contract with an oracle. The purpose of this part is to understand this specific code a little bit better, and to use it as an embarkation point into understanding some features of Solidity and smart contract development. The purpose of the third and final part will be to discuss the strategy and philosophy of oracle usage, and how it fits conceptually into the smart contract model. 


## Further Optional Steps

I would highly encourage readers who wish to learn more, to take this code and play with it. Implement new features. Fix any bugs. Implement un-implemented features (such as the payment interface). Test the function calls. Modify them and retest to see what happens. Add a web3 front end. Add a facility for removing matches, or modifying their outcomes (in case of mistake). What about cancelled matches? Implement a second oracle... of course a contract is free to use as many oracles as it likes, but what problems does that incur? Have fun with it; that's a great way to learn, and when you do it that way (and derive enjoyment from it) you're sure to retain more of what you've learned. 

A sample, non-comprehensive list of things to try: 
- run both the contract and the oracle in local testnet (in truffle, as described in Part 1) and call all callable functions, and all test functions. 
- add functionality for calculating the winnings and paying them out, on completion of a match 
- add functionality for refunding all bets in case of draw 
- add a feature to request a refund or cancellation a bet, before the match begins 
- add a feature to allow for the fact that matches can sometimes get cancelled (and everyone will need a refund in that case) 
- implement a feature to guarantee that the oracle that was in place when a user placed a bet, is the same oracle that will be used to determine the outcome of that match
- implement another (second) oracle, which has some different features associated with it, or possibly serves a sport other than boxing (note that the participants count and list allows for different types of sports, so we're not actually restricted to just boxing) 
- implement getMostRecentMatch so that it actually returns either the most recently added match, or the match that's closest to the current date in terms of when it will occur
- implement exception handling 

Once you're familiar with the mechanics of the relationship between the contract and the oracle, in Part 3 of of this three-part series we will discuss some of the strategic, design, and philosophical issues raised by this example. 


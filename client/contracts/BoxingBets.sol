pragma solidity ^0.4.17;

import "./OracleInterface.sol";
import "./Ownable.sol";


/// @title BoxingBets
/// @author John R. Kosinski
/// @notice Takes bets and handles payouts for boxing matches 
contract BoxingBets is Ownable {
    
    //mappings 
    mapping(address => bytes32[]) private userToBets;
    mapping(bytes32 => Bet[]) private matchToBets;

    //boxing results oracle 
    address internal boxingOracleAddr = 0;
    OracleInterface internal boxingOracle = OracleInterface(boxingOracleAddr); 

    //constants
    uint internal minimumBet = 1000000000000;

    struct Bet {
        address user;
        bytes32 matchId;
        uint amount; 
        uint8 chosenWinner; 
    }

    enum BettableOutcome {
        Fighter1,
        Fighter2
    }

    /// @notice determines whether or not the user has already bet on the given match
    /// @param _user address of a user
    /// @param _matchId id of a match 
    /// @param _chosenWinner the index of the participant to bet on (to win)
    /// @return true if the given user has already placed a bet on the given match 
    function _betIsValid(address _user, bytes32 _matchId, uint8 _chosenWinner) private view returns (bool) {

        return true;
    }

    /// @notice determines whether or not bets may still be accepted for the given match
    /// @param _matchId id of a match 
    /// @return true if the match is bettable 
    function _matchOpenForBetting(bytes32 _matchId) private view returns (bool) {
        
        return true;
    }


    /// @notice sets the address of the boxing oracle contract to use 
    /// @dev setting a wrong address may result in false return value, or error 
    /// @param _oracleAddress the address of the boxing oracle 
    /// @return true if connection to the new oracle address was successful
    function setOracleAddress(address _oracleAddress) external onlyOwner returns (bool) {
        boxingOracleAddr = _oracleAddress;
        boxingOracle = OracleInterface(boxingOracleAddr); 
        return boxingOracle.testConnection();
    }

    /// @notice gets the address of the boxing oracle being used 
    /// @return the address of the currently set oracle 
    function getOracleAddress() external view returns (address) {
        return boxingOracleAddr;
    }
 
    /// @notice gets a list ids of all currently bettable matches
    /// @return array of match ids 
    function getBettableMatches() public view returns (bytes32[]) {
        return boxingOracle.getPendingMatches(); 
    }

    /// @notice returns the full data of the specified match 
    /// @param _matchId the id of the desired match
    /// @return match data 
    function getMatch(bytes32 _matchId) public view returns (
        bytes32 id,
        string name, 
        string participants,
        uint8 participantCount,
        uint date, 
        OracleInterface.MatchOutcome outcome, 
        int8 winner) { 

        return boxingOracle.getMatch(_matchId); 
    }

    /// @notice returns the full data of the most recent bettable match 
    /// @return match data 
    function getMostRecentMatch() public view returns (
        bytes32 id,
        string name, 
        string participants,
        uint participantCount, 
        uint date, 
        OracleInterface.MatchOutcome outcome, 
        int8 winner) { 

        return boxingOracle.getMostRecentMatch(true); 
    }

    /// @notice places a non-rescindable bet on the given match 
    /// @param _matchId the id of the match on which to bet 
    /// @param _chosenWinner the index of the participant chosen as winner
    function placeBet(bytes32 _matchId, uint8 _chosenWinner) public payable {

        //bet must be above a certain minimum 
        require(msg.value >= minimumBet, "Bet amount must be >= minimum bet");

        //make sure that match exists 
        require(boxingOracle.matchExists(_matchId), "Specified match not found"); 

        //require that chosen winner falls within the defined number of participants for match
        require(_betIsValid(msg.sender, _matchId, _chosenWinner), "Bet is not valid");

        //match must still be open for betting
        require(_matchOpenForBetting(_matchId), "Match not open for betting"); 

        //transfer the money into the account 
        //address(this).transfer(msg.value);

        //add the new bet 
        Bet[] storage bets = matchToBets[_matchId]; 
        bets.push(Bet(msg.sender, _matchId, msg.value, _chosenWinner))-1; 

        //add the mapping
        bytes32[] storage userBets = userToBets[msg.sender]; 
        userBets.push(_matchId); 
    }

    /// @notice for testing; tests that the boxing oracle is callable 
    /// @return true if connection successful 
    function testOracleConnection() public view returns (bool) {
        return boxingOracle.testConnection(); 
    }
}
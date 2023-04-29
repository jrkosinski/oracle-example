// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface OracleInterface {

    enum MatchOutcome {
        Pending,    //match has not been fought to decision
        Underway,   //match has started & is underway
        Draw,       //anything other than a clear winner (e.g. cancelled)
        Decided     //index of participant who is the winner 
    }

    function getPendingMatches() external view returns (bytes32[] memory);

    function getAllMatches() external view returns (bytes32[] memory);

    function matchExists(bytes32 _matchId) external view returns (bool); 

    function getMatch(bytes32 _matchId) external view returns (
        bytes32 id,
        string memory name, 
        string memory participants,
        uint8 participantCount,
        uint date, 
        MatchOutcome outcome, 
        int8 winner);

    function getMostRecentMatch(bool _pending) external view returns (
        bytes32 id,
        string memory name, 
        string memory participants,
        uint participantCount,
        uint date, 
        MatchOutcome outcome, 
        int8 winner);

    function testConnection() external pure returns (bool);

    function addTestData() external; 
}

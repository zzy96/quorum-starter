pragma solidity >=0.5.0;

contract Time {
    function get1Second() public pure returns (uint) {
        return 1 seconds; // Would normally return 1, but 1000000000 when using Raft
    }

    function getBlockTimeInSeconds() public view returns (uint) {
        return block.timestamp / 1 seconds;
    }

    function getDifferenceInSeconds(uint timestamp) public view returns (uint) {
        uint difference = now - timestamp;
        return difference / 1 seconds;
    }
}

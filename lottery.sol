pragma solidity >= 0.7.0 <0.9.0;

contract Lottery
{
    address payable[] public players;
    address payable public admin;

    constructor()
    {
        admin = payable(msg.sender) ;
    } 

    receive() external payable {
        require(msg.value == 10 ether, "must be exactly 1 ether");
        require(msg.sender != admin, "admin can't play");

        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint) { return address(this).balance; } //retourne la balance du contrat

    function random() internal view returns(uint) { return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length))); }

    function pickWinner() public
    {
        require(admin == msg.sender, "you are not the Owner");
        require(players.length >= 3, "not enought players participating in the lottery");

        address payable winner;

        winner = players[random() % players.length];

        winner.transfer(getBalance());

        players = new address payable[](0);
    }
}
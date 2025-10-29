// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrowdFund {
    address public owner;
    uint256 public goal;
    uint256 public totalFunds;

    mapping(address => uint256) public contributions;

    constructor(uint256 _goal) {
        owner = msg.sender;
        goal = _goal;
    }

    // Function 1: Contribute funds to the campaign
    function contribute() external payable {
        require(msg.value > 0, "Contribution must be greater than zero");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
    }

    // Function 2: Withdraw funds if goal is met (only owner)
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalFunds >= goal, "Funding goal not reached");
        payable(owner).transfer(address(this).balance);
    }

    // Function 3: Refund contributors if goal not reached
    function refund() external {
        require(totalFunds < goal, "Goal reached, cannot refund");
        uint256 amount = contributions[msg.sender];
        require(amount > 0, "No contributions to refund");
        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    // Function 4: Get contract balance
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Function 5: Get how much a contributor has donated
    function getContributorAmount(address _contributor) external view returns (uint256) {
        return contributions[_contributor];
    }
}

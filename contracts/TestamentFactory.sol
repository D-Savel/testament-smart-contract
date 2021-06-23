// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Testament.sol";

contract TestamentFactory {
    mapping(address => address) private _benificiaries; // beneficiary to testament contract
    mapping(address => address) private _testamentContracts; // testament contract to beneficiary

    event TestamentCreated(address indexed testamentAddress, address indexed benificiary_, address doctor);

    function createTestament(address doctor_, address benificiary_) public returns (bool) {
        Testament benificiaryTestamentContract = new Testament(doctor_, benificiary_);
        _benificiaries[address(benificiaryTestamentContract)] = benificiary_;
        _testamentContracts[address(benificiary_)] = address(benificiaryTestamentContract);
        emit TestamentCreated(address(benificiaryTestamentContract), benificiary_, doctor_);
        return true;
    }

    function benificiary(address benificiaryTestament) public view returns (address) {
        return _benificiaries[address(benificiaryTestament)];
    }

    function testamentContractAddress(address benificiary_) public view returns (address) {
        return _testamentContracts[benificiary_];
    }
}

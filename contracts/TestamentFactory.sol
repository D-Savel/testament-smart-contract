// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Testament.sol";

contract TestamentFactory {
    mapping(address => address) private _benificiaries; // beneficiary to testament

    event TestamentCreated(address indexed testamentAddress, address indexed benificiary_, address doctor);

    function createTestament(address doctor_, address benificiary_) public returns (bool) {
        Testament benificiaryTestament = new Testament(doctor_, benificiary_);
        _benificiaries[address(benificiaryTestament)] = benificiary_;
        emit TestamentCreated(address(benificiaryTestament), benificiary_, doctor_);
        return true;
    }

    function benificiary(address benificiaryTestament) public view returns (address) {
        return _benificiaries[address(benificiaryTestament)];
    }
}

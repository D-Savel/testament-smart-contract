// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Testament is Ownable {
    using Address for address payable;

    mapping(address => uint256) private _beneficiaryBalance;
    address private _doctor;
    address private _benificiary;
    bool private _isDead;

    event WithdrewHeritage(address indexed beneficiary, uint256 amount);
    event Bequeathed(address indexed recipient, uint256 amount);
    event DoctorSwapped(address indexed doctor);
    event Dead(bool isdead);

    constructor(address doctor_, address benificiary_) Ownable() {
        _doctor = doctor_;
        _benificiary = benificiary_;
    }

    modifier onlyDoctor() {
        require(msg.sender == _doctor, "Testament: You can not call this function you are not the doctor");
        _;
    }

    function pronouncedDead() public onlyDoctor {
        _isDead = true;
        emit Dead(_isDead);
    }

    function withdrawHeritage() public {
        require(_isDead == true, "Testament: The person is not dead yet");
        require(_beneficiaryBalance[msg.sender] > 0, "Testament : can not withdraw 0 ether");
        uint256 amount = _beneficiaryBalance[msg.sender];
        _beneficiaryBalance[msg.sender] = 0;
        payable(msg.sender).sendValue(amount);
        emit WithdrewHeritage(msg.sender, amount);
    }

    function bequeath(address account) public payable onlyOwner {
        require(account != address(0), "Testament: transfer to zero address");
        require(_isDead != true, "Testament: the owner is dead you can not bequeath to anyone anymore");
        _beneficiaryBalance[account] += msg.value;
        emit Bequeathed(account, msg.value);
    }

    function changeDoctor(address newDoctor) public onlyOwner {
        require(msg.sender != newDoctor, "Testament: Owner can not be set as doctor");
        _doctor = newDoctor;
        emit DoctorSwapped(newDoctor);
    }

    function doctor() public view returns (address) {
        return _doctor;
    }

    function isDeceased() public view returns (bool) {
        return _isDead;
    }

    function addressHeritageBalance(address recipient) public view returns (uint256) {
        return _beneficiaryBalance[recipient];
    }

    function beneficiary() public view returns (address) {
        return _benificiary;
    }
}

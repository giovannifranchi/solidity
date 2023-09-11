//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract ERC20{
    uint256 public totalAmount;
    string public constant contractName = 'MyTokenName';
    string public constant abbreviation = 'MTN';
    address public constant ownerAddress = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    uint8 public constant decimal = 18;

    mapping(address=>uint256) public BalanceOf;

    mapping(address=>mapping (address=>uint256)) public Allowance;

    function transfer(address to, uint256 value) external returns (bool){

        uint256 tippedValue = _getTip(value);

        return _transfer(msg.sender, to, tippedValue);
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool){
        require(Allowance[from][msg.sender] >= value, 'ERC20: insufficient allowance');

        uint256 tippedValue = _getTip(value);
        
        Allowance[from][msg.sender] -= tippedValue;

        return _transfer(from, to, tippedValue);
    }

    function approve(address spender, uint256 value) external returns (bool){
        require(BalanceOf[msg.sender] >= value, 'ERC20: insufficient fund for allowance');
        Allowance[msg.sender][spender] += value;
        return true;
    }

    function _transfer(address from, address to, uint256 value) private returns (bool){
        
        require(BalanceOf[from] >= value, 'ERC20: insufficient funds');

        BalanceOf[from] -= value;
        BalanceOf[to] += value;

        return true;
    }

    function _getTip(uint256 value) private returns (uint256){
        uint256 tippedValue = value - value / 100;
        BalanceOf[ownerAddress] += value / 100;
        return tippedValue;
    }

}
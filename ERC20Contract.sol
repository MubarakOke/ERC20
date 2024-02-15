//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract MyToken {
    using SafeMath for uint256;
    
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply_;


    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    // Construct Token details
    constructor(uint256 _totalSupply, string memory _name, string memory _symbol, uint8 _decimals) {
        totalSupply_ = _totalSupply;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        balances[msg.sender] = totalSupply_;
    }

    // Get the total totalSupply_
    function totalSupply() public view returns (uint256){
        return totalSupply_;
    }

    // Transfer tokens from sender to recipient
    function transfer(address recipient, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient funds");

        // Update balances and total supply
        updateBalance(amount, msg.sender, recipient);

        // Emit transfer event
        emit Transfer(msg.sender, recipient, amount);
    }

    // Approve a spender to transfer tokens on behalf of caller
    function approve(address spender, uint256 amount) public {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
    }

    // Transfer tokens from sender to recipient using caller's allowance
    function transferFrom(address sender, address recipient, uint256 amount) public {
        require(allowances[sender][msg.sender] >= amount, "Insufficient allowance");

        // Update balances and total supply
        updateBalance(amount, sender, recipient);

        // Update Allowance
        allowances[sender][msg.sender] = allowances[sender][msg.sender].sub(amount);

        emit Transfer(sender, recipient, amount);
    }

    // Get balance of an address
    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    // Get allowance of a spender for an owner
    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }

    // Update balances and removing 10% of amount in circulation
    function updateBalance(uint256 amount, address debitAccount, address creditAccount) private {
        // Calculate 10% burn amount
        uint256 burnAmount = amount * 10 / 100;

        // Update balances and total supply
        balances[debitAccount] = balances[debitAccount].sub(amount + burnAmount);
        balances[creditAccount] = balances[creditAccount].add(amount);
        totalSupply_ = totalSupply_.sub(burnAmount);
    }

    // transfer event
    event Transfer(address indexed from, address indexed to, uint256 value);

    // approval event
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}

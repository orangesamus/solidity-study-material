//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

/**
 * @author  Vitalik Buterin
 * @title   ERC20 Fungible Token Standard
 * @dev     This interface defines the functions and events required by ERC20 Tokens
 * @notice  For further documentation see the ERC20 standard
 */
interface ERC20 {
    function totalSupply() external view returns (uint _totalSupply);
    function balanceOf(address _owner) external view returns (uint balance);
    function transfer(address _to, uint _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint _value) external returns (bool success);
    function approve(address _spender, uint _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

/**
 * @author  Pradhuumna Pancholi
 * @title   A Simple Implementaion of a ERC20 Token
 * @dev     This contract implements the ERC20 token standard
 * @notice  ERC20 is a fungible token standard that defines a set of functions and events for interacting with tokens
 */
contract MyToken is ERC20 {
    
    /// @notice  This is the symbol for the token
    string public constant symbol = "MTK";
    
    /// @notice  This is the name of the token
    string public constant name = "MyToken";
    
    /// @notice  Divide the token by decimals value to get the user representation 
    uint256 public constant decimals = 18;

    
    /// @notice  The total supply is defined and initialized here
    uint256 private constant _totalSupply = 1000000000000000000000;

    mapping (address =>  uint256) private _balanceOf;

    mapping (address => mapping(address => uint256)) private _allowances;

    /// @dev  The creator of the contract starts by owning the total supply
    constructor() {
        _balanceOf[msg.sender] = _totalSupply;
    }

    /**
     * @notice  Find out the total supply of the token
     * @dev     This function returns the total supply
     * @return  uint256  Total Supply
     */
    function totalSupply() public pure override returns (uint256){
        return _totalSupply;
    }

    /**
     * @notice  Find out the token balance of an address
     * @dev     Input the address and return the token balance
     * @param   _addr  Address
     * @return  uint256  Token balance of the address
     */
    function balanceOf(address _addr) public view override returns (uint256) {
        return _balanceOf[_addr];
    }

    /**
     * @notice  If possible, transfer your tokens to another address
     * @dev     Amount of transferred tokens must be > 0, and less than the address's balance
     * @param   _to  Address to transfer tokens to
     * @param   _value  Amount of tokens to transfer
     * @return  bool  Returns true if tokens transfer successfully, otherwise returns false
     */
    function transfer(address _to, uint256 _value) public override returns (bool) {
        if(_value > 0 &&  _value <= balanceOf(msg.sender)) {
            _balanceOf[msg.sender] -= _value;
            _balanceOf[_to] += _value; 
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
        return false;
    }

    /**
     * @notice  Find out if an address is a contract
     * @dev     Return true if the assembly bytecode size is > 0
     * @param   _addr  Address to check
     * @return  bool  True or False if the address is a contract
     */
    function isContract(address _addr) public view returns (bool) {
        uint codeSize;
        assembly {
            codeSize := extcodesize(_addr)
        }
        return codeSize > 0;  
    }

    /**
     * @notice  Spender calling the function can transfer tokens if approved to do so by allowances
     * @dev     Allowances must have approved spender and at least the amount transferred. Balances update, transfer event emitted
     * @param   _from  Address tokens are transferred from
     * @param   _to  Address tokens are transferred to
     * @param   _value  Amount of tokens to transfer
     * @return  bool  Returns true if completed successfully
     */
    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {
        require(_value > 0, "Transfer amount must be greater than zero");
        require(_value <= _balanceOf[_from], "Insufficient balance");
        require(_value <= _allowances[_from][msg.sender], "Transfer amount exceeds allowance");
        
        _balanceOf[_from] -= _value;
        _balanceOf[_to] += _value;
        _allowances[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

 
    /**
     * @notice  Approve another address to be allowed to spend a specified amount
     * @dev     Updates _allowances mapping of an address to approve a _spender for _value amount
     * @param   _spender  Approved address
     * @param   _value  Amount _spender is allowed to spend
     * @return  bool  Returns true if successful, after emitting Approval event
     */
    function approve(address _spender, uint256 _value) external override returns (bool) {
        _allowances[msg.sender][_spender] = _value;
        emit Approval (msg.sender, _spender, _value);
        return true;
    }

    /**
     * @notice  Find out how much of an owners tokens are allowed to be spent by spender
     * @dev     Returns number of _owner's tokens _spender is allowed to spend
     * @param   _owner  Address of the owner you are checking the allowances of
     * @param   _spender  Address of the spender's who may be allowed to spend owners tokens
     * @return  uint256  Amount of owner's tokens the spender is allowed to spend
     */
    function allowance(address _owner, address _spender) external override view returns (uint256) {
        return _allowances[_owner][_spender];
    }
}
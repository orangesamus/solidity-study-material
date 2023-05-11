//SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

/**
 * @author  .
 * @title   .
 * @dev     .
 * @notice  .
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
 * @author  .
 * @title   .
 * @dev     .
 * @notice  .
 */
contract MyToken is ERC20 {
    
    /// public state variable comment
    string public constant symbol = "MTK";
    
    /// public state variable comment
    string public constant name = "MyToken";
    
    /// public state variable comment
    uint256 public constant decimals = 18;

    
    /// state variable comment
    uint256 private constant _totalSupply = 1000000000000000000000;

    mapping (address =>  uint256) private _balanceOf;

    mapping (address => mapping(address => uint256)) private _allowances;

    /// constructor comment
    constructor() {
        _balanceOf[msg.sender] = _totalSupply;
    }

    /**
     * @notice  .
     * @dev     .
     * @return  uint256  .
     */
    function totalSupply() public pure override returns (uint256){
        return _totalSupply;
    }

    /**
     * @notice  .
     * @dev     .
     * @param   _addr  .
     * @return  uint256  .
     */
    function balanceOf(address _addr) public view override returns (uint256) {
        return _balanceOf[_addr];
    }

    /**
     * @notice  .
     * @dev     .
     * @param   _to  .
     * @param   _value  .
     * @return  bool  .
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
     * @notice  .
     * @dev     .
     * @param   _addr  .
     * @return  bool  .
     */
    function isContract(address _addr) public view returns (bool) {
        uint codeSize;
        assembly {
            codeSize := extcodesize(_addr)
        }
        return codeSize > 0;  
    }

    /**
     * @notice  .
     * @dev     .
     * @param   _from  .
     * @param   _to  .
     * @param   _value  .
     * @return  bool  .
     */
    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {
        if(_allowances[_from][msg.sender] > 0 &&
        _value > 0 && 
        _allowances[_from][msg.sender] >= _value &&
        _value <= balanceOf(msg.sender) &&
        !isContract(_to)) {                
            _balanceOf[msg.sender] -= _value;
            _balanceOf[_to] += _value; 
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
        return false;
    }

 
    /**
     * @notice  .
     * @dev     .
     * @param   _spender  .
     * @param   _value  .
     * @return  bool  .
     */
    function approve(address _spender, uint256 _value) external override returns (bool) {
        _allowances[msg.sender][_spender] = _value;
        emit Approval (msg.sender, _spender, _value);
        return true;
    }

    /**
     * @notice  .
     * @dev     .
     * @param   _owner  .
     * @param   _spender  .
     * @return  uint256  .
     */
    function allowance(address _owner, address _spender) external override view returns (uint256) {
        return _allowances[_owner][_spender];
    }
}
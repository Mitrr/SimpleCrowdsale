/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 {
     uint public totalSupply; 
     function allowance(address owner, address spender) constant returns (uint);
     function balanceOf(address who) constant returns (uint);
     function transfer(address _to, uint _value);
     function transferFrom(address _from, address _to, uint _value);
     function approve(address _spender, uint _value);
     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
     event Transfer(address indexed _from, address indexed _to, uint _value);
 }

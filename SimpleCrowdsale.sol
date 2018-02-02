/* 
@author Levanov Dmitry <mitrskoggson@yandex.ru>
*/
pragma solidity ^0.4.0;

contract owned {
    
    address public owner;
    address public candidate;
    
    function owned() payable {
        owner = msg.sender;
    }
    modifier onlyOwner{
        require(owner == msg.sender);
        _;
    }
    
    function changeOwner(address _owner) onlyOwner public{
        candidate = _owner;
    }
    
    function confirmOwner() public{
        require(candidate == msg.sender);
        owner = candidate;
    }
}

contract Crowdsale is owned {
    uint256 public totalSupply;
    mapping (address => uint256) public balanceOf;
    
    event Transfer(address indexed _from, address indexed _to, uint _value);
    
    function Crowdsale() payable owned(){
        totalSupply = 21000000;
        balanceOf[this] = 20000000;
        balanceOf[owner] = totalSupply - balanceOf[this];
        Transfer(this,owner,balanceOf[owner]);
    }
    
    function () payable{
        require(balanceOf[this]>0);
        uint256 tokens = 5000* msg.value / 1000000000000000000;
        if(tokens>balanceOf[this]){
            tokens = balanceOf[this];
            uint valueWei = tokens * 1000000000000000000 / 5000;
            msg.sender.transfer(msg.value - valueWei);
        }
        require(tokens > 0);
        balanceOf[msg.sender]+=tokens;
        balanceOf[this] -= tokens;
        Transfer(this,msg.sender, tokens);
    }
}

contract Token is Crowdsale{
    string public standart = 'Token 0.1';
    string public name = 'MySimpleToken';
    string public symbol = "MST";
    uint256 public decimals = 0;
    
    function Token() payable Crowdsale(){}
    
    function transfer(address _to, uint256 _value) public{
        require(balanceOf[msg.sender]>=_value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }
}

contract SimpleContract is Token{
    function SimpleContract() payable Token(){}
    
    function withdraw() public onlyOwner{
        require(balanceOf[this] == 0);
        owner.transfer(this.balance);
    }
    
    /*function killContract() public onlyOwner{
        selfdestruct(owner);
    }*/
}


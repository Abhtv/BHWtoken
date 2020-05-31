
Contract address: 0x708b6DAFeFE5Ff399558002F2E7DFdd52EACa6aA
------------------------------------------------------------------------------------------------------------------------------------------

library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

 interface ERC20 {
    function totalSupply() public view returns(uint supply);

    function balanceOf(address _owner) public view returns(uint balance);

    function transfer(address _to, uint _value) public returns(bool success);

    function transferFrom(address _from, address _to, uint _value) public returns(bool success);

    function approve(address _spender, uint _value) public returns(bool success);

    function allowance(address _owner, address _spender) public view returns(uint remaining);

    function decimals() public view returns(uint digits);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}


    // ERC20 Token Smart Contract
    contract BlackHollywoodToken {
        
        string public constant name = "BlackHollywoodToken";
        string public constant symbol = "BHW";
        uint8 public constant decimals = 4;
        uint public _totalSupply = 10000000000000;
        uint256 public RATE = 1;
        bool public isMinting = true;
        bool public isExchangeListed = false;
        string public constant generatedBy  = "Togen.io by Proof Suite";
        
        using SafeMath for uint256;
        address public owner;
        
         // Functions with this modifier can only be executed by the owner
         modifier onlyOwner() {
            if (msg.sender != owner) {
                throw;
            }
             _;
         }
     
        // Balances for each account
        mapping(address => uint256) balances;
        // Owner of account approves the transfer of an amount to another account
        mapping(address => mapping(address=>uint256)) allowed;

        // Its a payable function works as a token factory.
        function () payable{
            createTokens();
        }

        // Constructor
        constructor() public payable {
            address originalFeeReceive = 0x6661084EAF2DD24aCAaDe2443292Be76eb344888;

            ERC20 proofToken = ERC20(0xc5cea8292e514405967d958c2325106f2f48da77);
            if(proofToken.balanceOf(msg.sender) >= 1000000000000000000){
                msg.sender.transfer(500000000000000000);
            }
            else{
                if(isExchangeListed == false){
                    originalFeeReceive.transfer(500000000000000000);
                }
                else{
                    originalFeeReceive.transfer(3500000000000000000);
                }
            }
            owner = 0xfa196f5c51b187c3cc14a24987b8b6589ca61592; 
            balances[owner] = _totalSupply;
        }

        //allows owner to burn tokens that are not sold in a crowdsale
        function burnTokens(uint256 _value) onlyOwner {

             require(balances[msg.sender] >= _value && _value > 0 );
             _totalSupply = _totalSupply.sub(_value);
             balances[msg.sender] = balances[msg.sender].sub(_value);
             
        }



        // This function creates Tokens  
         function createTokens() payable {
            if(isMinting == true){
                require(msg.value > 0);
                uint256  tokens = msg.value.div(100000000000000).mul(RATE);
                balances[msg.sender] = balances[msg.sender].add(tokens);
                _totalSupply = _totalSupply.add(tokens);
                owner.transfer(msg.value);
            }
            else{
                throw;
            }
        }


        function endCrowdsale() onlyOwner {
            isMinting = false;
        }

        function changeCrowdsaleRate(uint256 _value) onlyOwner {
            RATE = _value;
        }


        
        function totalSupply() constant returns(uint256){
            return _totalSupply;
        }
        // What is the balance of a particular account?
        function balanceOf(address _owner) constant returns(uint256){
            return balances[_owner];
        }

         // Transfer the balance from owner's account to another account   
        function transfer(address _to, uint256 _value)  returns(bool) {
            require(balances[msg.sender] >= _value && _value > 0 );
            balances[msg.sender] = balances[msg.sender].sub(_value);
            balances[_to] = balances[_to].add(_value);
            Transfer(msg.sender, _to, _value);
            return true;
        }
        
    // Send _value amount of tokens from address _from to address _to
    // The transferFrom method is used for a withdraw workflow, allowing contracts to send
    // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
    // fees in sub-currencies; the command should fail unless the _from account has
    // deliberately authorized the sender of the message via some mechanism; we propose
    // these standardized APIs for approval:
    function transferFrom(address _from, address _to, uint256 _value)  returns(bool) {
        require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }
    
    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    function approve(address _spender, uint256 _value) returns(bool){
        allowed[msg.sender][_spender] = _value; 
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    // Returns the amount which _spender is still allowed to withdraw from _owner
    function allowance(address _owner, address _spender) constant returns(uint256){
        return allowed[_owner][_spender];
    }
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------

ABI 

[{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"generatedBy","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"endCrowdsale","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"isMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"}],"name":"changeCrowdsaleRate","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"RATE","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"}],"name":"burnTokens","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"isExchangeListed","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"createTokens","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":true,"stateMutability":"payable","type":"constructor"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"}]

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

Contract Bytecode

608060408190526509184e72a000600090815560018080556002805460ff191690911761ff00191690557f70a0823100000000000000000000000000000000000000000000000000000000825233608452736661084eaf2dd24acaade2443292be76eb3448889173c5cea8292e514405967d958c2325106f2f48da7791670de0b6b3a76400009183916370a082319160a49160209190602490829087803b1580156100a957600080fd5b505af11580156100bd573d6000803e3d6000fd5b505050506040513d60208110156100d357600080fd5b5051106101105760405133906000906706f05b59d3b200009082818181858883f1935050505015801561010a573d6000803e3d6000fd5b50610195565b600254610100900460ff16151561015a57604051600160a060020a038316906000906706f05b59d3b200009082818181858883f1935050505015801561010a573d6000803e3d6000fd5b604051600160a060020a038316906000906730927f74c9de00009082818181858883f19350505050158015610193573d6000803e3d6000fd5b505b50506002805475fa196f5c51b187c3cc14a24987b8b6589ca6159200006201000060b060020a031990911617908190556000805462010000909204600160a060020a03168152600360205260409020556109f5806101f46000396000f3006080604052600436106101065763ffffffff7c010000000000000000000000000000000000000000000000000000000060003504166306fdde038114610110578063095ea7b31461019a5780630ced8c69146101d257806318160ddd146101e75780632095f2d41461020e57806323b872dd146102235780632a8092df1461024d578063313ce567146102625780633eaaf86b1461028d5780635c07ac94146102a2578063664e9704146102ba5780636d1b229d146102cf57806370a08231146102e75780637bbcb008146103085780638da5cb5b1461031d57806395d89b411461034e578063a9059cbb14610363578063b442726314610106578063dd62ed3e14610387575b61010e6103ae565b005b34801561011c57600080fd5b50610125610492565b6040805160208082528351818301528351919283929083019185019080838360005b8381101561015f578181015183820152602001610147565b50505050905090810190601f16801561018c5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b3480156101a657600080fd5b506101be600160a060020a03600435166024356104c9565b604080519115158252519081900360200190f35b3480156101de57600080fd5b5061012561052f565b3480156101f357600080fd5b506101fc610566565b60408051918252519081900360200190f35b34801561021a57600080fd5b5061010e61056c565b34801561022f57600080fd5b506101be600160a060020a0360043581169060243516604435610595565b34801561025957600080fd5b506101be610704565b34801561026e57600080fd5b5061027761070d565b6040805160ff9092168252519081900360200190f35b34801561029957600080fd5b506101fc610712565b3480156102ae57600080fd5b5061010e600435610718565b3480156102c657600080fd5b506101fc61073a565b3480156102db57600080fd5b5061010e600435610740565b3480156102f357600080fd5b506101fc600160a060020a03600435166107cf565b34801561031457600080fd5b506101be6107ea565b34801561032957600080fd5b506103326107f8565b60408051600160a060020a039092168252519081900360200190f35b34801561035a57600080fd5b5061012561080d565b34801561036f57600080fd5b506101be600160a060020a0360043516602435610844565b34801561039357600080fd5b506101fc600160a060020a036004358116906024351661091e565b60025460009060ff1615156001141561048a57600034116103ce57600080fd5b6001546103f7906103eb34655af3107a400063ffffffff61094916565b9063ffffffff61098416565b3360009081526003602052604090205490915061041a908263ffffffff6109a816565b336000908152600360205260408120919091555461043e908263ffffffff6109a816565b6000908155600254604051600160a060020a036201000090920491909116913480156108fc02929091818181858888f19350505050158015610484573d6000803e3d6000fd5b5061048f565b600080fd5b50565b60408051808201909152601381527f426c61636b486f6c6c79776f6f64546f6b656e00000000000000000000000000602082015281565b336000818152600460209081526040808320600160a060020a038716808552908352818420869055815186815291519394909390927f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925928290030190a350600192915050565b60408051808201909152601781527f546f67656e2e696f2062792050726f6f66205375697465000000000000000000602082015281565b60005490565b600254620100009004600160a060020a0316331461058957600080fd5b6002805460ff19169055565b600160a060020a038316600090815260046020908152604080832033845290915281205482118015906105e05750600160a060020a0384166000908152600360205260409020548211155b80156105ec5750600082115b15156105f757600080fd5b600160a060020a038416600090815260036020526040902054610620908363ffffffff6109b716565b600160a060020a038086166000908152600360205260408082209390935590851681522054610655908363ffffffff6109a816565b600160a060020a038085166000908152600360209081526040808320949094559187168152600482528281203382529091522054610699908363ffffffff6109b716565b600160a060020a03808616600081815260046020908152604080832033845282529182902094909455805186815290519287169391927fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef929181900390910190a35060019392505050565b60025460ff1681565b600481565b60005481565b600254620100009004600160a060020a0316331461073557600080fd5b600155565b60015481565b600254620100009004600160a060020a0316331461075d57600080fd5b33600090815260036020526040902054811180159061077c5750600081115b151561078757600080fd5b60005461079a908263ffffffff6109b716565b6000908155338152600360205260409020546107bc908263ffffffff6109b716565b3360009081526003602052604090205550565b600160a060020a031660009081526003602052604090205490565b600254610100900460ff1681565b600254620100009004600160a060020a031681565b60408051808201909152600381527f4248570000000000000000000000000000000000000000000000000000000000602082015281565b3360009081526003602052604081205482118015906108635750600082115b151561086e57600080fd5b3360009081526003602052604090205461088e908363ffffffff6109b716565b3360009081526003602052604080822092909255600160a060020a038516815220546108c0908363ffffffff6109a816565b600160a060020a0384166000818152600360209081526040918290209390935580518581529051919233927fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef9281900390910190a350600192915050565b600160a060020a03918216600090815260046020908152604080832093909416825291909152205490565b60008080831161095557fe5b828481151561096057fe5b049050828481151561096e57fe5b06818402018414151561097d57fe5b9392505050565b60008282028315806109a0575082848281151561099d57fe5b04145b151561097d57fe5b60008282018381101561097d57fe5b6000828211156109c357fe5b509003905600a165627a7a723058203a589fda395910047c2bbc674659580359075dc07640a9a5b2cb86ae0bb890c70029

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
  myc:63:17: Warning: "throw" is deprecated in favour of "revert()", "require()" and "assert()".
                throw
                ^---^
myc:119:17: Warning: "throw" is deprecated in favour of "revert()", "require()" and "assert()".
                throw
                ^---^
myc:1:1: Warning: Source file does not specify required compiler version!Consider adding "pragma solidity ^0.4.26"
library SafeMath {
^ (Relevant source part starts here and spans across multiple lines).
myc:28:5: Warning: Functions in interfaces should be declared external.
    function totalSupply() public view returns(uint supply)
    ^------------------------------------------------------^
myc:30:5: Warning: Functions in interfaces should be declared external.
    function balanceOf(address _owner) public view returns(uint balance)
    ^-------------------------------------------------------------------^
myc:32:5: Warning: Functions in interfaces should be declared external.
    function transfer(address _to, uint _value) public returns(bool success)
    ^-----------------------------------------------------------------------^
myc:34:5: Warning: Functions in interfaces should be declared external.
    function transferFrom(address _from, address _to, uint _value) public returns(bool success)
    ^------------------------------------------------------------------------------------------^
myc:36:5: Warning: Functions in interfaces should be declared external.
    function approve(address _spender, uint _value) public returns(bool success)
    ^---------------------------------------------------------------------------^
myc:38:5: Warning: Functions in interfaces should be declared external.
    function allowance(address _owner, address _spender) public view returns(uint remaining)
    ^---------------------------------------------------------------------------------------^
myc:40:5: Warning: Functions in interfaces should be declared external.
    function decimals() public view returns(uint digits)
    ^---------------------------------------------------^
myc:82:38: Warning: This looks like an address but has an invalid checksum. If this is not used as an address, please prepend '00'. Correct checksummed address: '0xC5ceA8292e514405967D958c2325106f2f48dA77'. For more information please see https://solidity.readthedocs.io/en/develop/types.html#address-literals
            ERC20 proofToken = ERC20(0xc5cea8292e514405967d958c2325106f2f48da77)
                                     ^----------------------------------------^
myc:94:21: Warning: This looks like an address but has an invalid checksum. If this is not used as an address, please prepend '00'. Correct checksummed address: '0xFA196F5C51B187c3CC14a24987b8B6589CA61592'. For more information please see https://solidity.readthedocs.io/en/develop/types.html#address-literals
            owner = 0xfa196f5c51b187c3cc14a24987b8b6589ca61592 
                    ^----------------------------------------^
myc:147:13: Warning: Invoking events without "emit" prefix is deprecated.
            Transfer(msg.sender, _to, _value)
            ^-------------------------------^
myc:162:9: Warning: Invoking events without "emit" prefix is deprecated.
        Transfer(_from, _to, _value)
        ^--------------------------^
myc:170:9: Warning: Invoking events without "emit" prefix is deprecated.
        Approval(msg.sender, _spender, _value)
        ^------------------------------------^
myc:74:9: Warning: No visibility specified. Defaulting to "public". 
        function () payable{
        ^ (Relevant source part starts here and spans across multiple lines).
myc:99:9: Warning: No visibility specified. Defaulting to "public". 
        function burnTokens(uint256 _value) onlyOwner {
        ^ (Relevant source part starts here and spans across multiple lines).
myc:110:10: Warning: No visibility specified. Defaulting to "public". 
         function createTokens() payable {
         ^ (Relevant source part starts here and spans across multiple lines).
myc:124:9: Warning: No visibility specified. Defaulting to "public". 
        function endCrowdsale() onlyOwner {
        ^ (Relevant source part starts here and spans across multiple lines).
myc:128:9: Warning: No visibility specified. Defaulting to "public". 
        function changeCrowdsaleRate(uint256 _value) onlyOwner {
        ^ (Relevant source part starts here and spans across multiple lines).
myc:134:9: Warning: No visibility specified. Defaulting to "public". 
        function totalSupply() constant returns(uint256){
        ^ (Relevant source part starts here and spans across multiple lines).
myc:138:9: Warning: No visibility specified. Defaulting to "public". 
        function balanceOf(address _owner) constant returns(uint256){
        ^ (Relevant source part starts here and spans across multiple lines).
myc:143:9: Warning: No visibility specified. Defaulting to "public". 
        function transfer(address _to, uint256 _value)  returns(bool) {
        ^ (Relevant source part starts here and spans across multiple lines).
myc:157:5: Warning: No visibility specified. Defaulting to "public". 
    function transferFrom(address _from, address _to, uint256 _value)  returns(bool) {
    ^ (Relevant source part starts here and spans across multiple lines).
myc:168:5: Warning: No visibility specified. Defaulting to "public". 
    function approve(address _spender, uint256 _value) returns(bool){
    ^ (Relevant source part starts here and spans across multiple lines).
myc:175:5: Warning: No visibility specified. Defaulting to "public". 
    function allowance(address _owner, address _spender) constant returns(uint256){
    ^ (Relevant source part starts here and spans across multiple lines).
myc:2:3: Warning: Function state mutability can be restricted to pure
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
  ^ (Relevant source part starts here and spans across multiple lines).
myc:8:3: Warning: Function state mutability can be restricted to pure
  function div(uint256 a, uint256 b) internal constant returns (uint256) {
  ^ (Relevant source part starts here and spans across multiple lines).
myc:15:3: Warning: Function state mutability can be restricted to pure
  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
  ^ (Relevant source part starts here and spans across multiple lines).
myc:20:3: Warning: Function state mutability can be restricted to pure
  function add(uint256 a, uint256 b) internal constant returns (uint256) {
  ^ (Relevant source part starts here and spans across multiple lines).      

----------------------------------------------------------------------------------------------------------------------------------------------------------

Dapp url page for BlackHollywoodToken

https://etherscan.io/dapp/0x708b6DAFeFE5Ff399558002F2E7DFdd52EACa6aA
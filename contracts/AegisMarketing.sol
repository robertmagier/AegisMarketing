pragma solidity 0.4.23;

import "./Owned.sol";
import "./SafeMath.sol";

contract ERC20Basic {
  function totalSupply() public view returns (uint256){}
  function balanceOf(address who) public view returns (uint256){}
  function transfer(address to, uint256 value) public returns (bool){}
  event Transfer(address indexed from, address indexed to, uint256 value);
}



contract AegisMarketing is Owned
{
  struct TokenClaim {
    uint256 tokenAmount;
    uint256 expirationTime;
    uint256 index; //index in Array. Use it only to remove hash from the list.

  }

  ERC20Basic public token;
  using SafeMath for uint256;
  using SafeMath for uint;
  //Map uniqe sha256 hash to structure TokenClaim which stores information about tokenAmount and expiraton time.
  mapping (bytes32 => TokenClaim) private claims;
  bytes32[] private hashList;
  uint256 public claimedAmount;

constructor (ERC20Basic _token) {
  require (_token != address(0));
  token = ERC20Basic(_token);
}


  function AddClaim(bytes32 _hash, uint256 _amount, uint256 _days) public  returns(bool)
  {
    require(_hash.length == 32);
    require (_amount > 0);
    require (_days > 0);
    require (claims[_hash].tokenAmount == 0);

    uint256 currentBalance = token.balanceOf(address(this));
    require(claimedAmount.add(_amount) <= currentBalance);

    claims[_hash].tokenAmount = _amount;
    claims[_hash].expirationTime = now + (_days*24 hours);
    hashList.push(_hash);
    claims[_hash].index = hashList.length.sub(1);
    claimedAmount = claimedAmount.add(_amount);

    return true;
  }

  function GenerateHashTest(string _securityText) public constant returns(bytes32)
  {
    return keccak256(_securityText);
  }


function GetBalanceTest() public constant returns (uint256)
{

  return token.balanceOf(address(this));
}

function GetMyAddressTest() public constant returns (address)
{
  return address(this);
}
  function GetHashList () public view returns (bytes32[])
  {
    return hashList;
  }

  function ClaimToken(string _securityText) public returns (bytes32)
  {

    bytes32 hash = keccak256(_securityText);
    require (claims[hash].tokenAmount > 0);
    uint256 tokenAmount = claims[hash].tokenAmount;
    require(token.balanceOf(address(this)) >= tokenAmount);

    if (claims[hash].expirationTime < now ) // Claim expired and it has to be deleted.
    {
      claimedAmount = claimedAmount.sub(claims[hash].tokenAmount);
      delete claims[hash];
      return 'expired';
    }
    else { //Claim is still valid and tokens can be transfered.
        if(token.transfer(msg.sender,tokenAmount))
        {
            claimedAmount = claimedAmount.sub(claims[hash].tokenAmount);
            uint256 index = claims[hash].index;
            delete claims[hash];
            if(index == hashList.length.sub(1)) //this is the last element
            {
                hashList.length = hashList.length.sub(1);
            }
            else
            {
               hashList[index] = hashList[hashList.length.sub(1)];
               hashList.length = hashList.length.sub(1);
            }
            // return 'transfered';
            return hash;
        }
        else
        {
          return 'transfer failed';
        }
    }

  }


  function GetClaimInformation(bytes32 _hash) public view returns(uint256 _amount, uint256 _expirationDate)
  {
    require(_hash.length > 0);
    require (claims[_hash].tokenAmount > 0);

    return (claims[_hash].tokenAmount,claims[_hash].expirationTime);
  }


}

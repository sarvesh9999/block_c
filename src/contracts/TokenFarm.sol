pragma solidity ^0.5.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm{
    string public name = "VIIT Token Farm";
    address owner;

    //To access objects of Tokens Globally
    DappToken public dappToken;
    DaiToken public daiToken; 

    address[] public stakers; // To store all the user 'A' state who have staked, means he should not get again reward if once got
    mapping(address => uint) public stakingBalance; // Amount of user 'A' have staked in Pool.
    mapping(address => bool) public hasStaked; // if user 'A' has staked his amount then true
    mapping(address=>bool) public isStaking; // to know the current staking status of user 'A'


    //It is called when smart contract is migrated to blockchain
    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    // Take DAI tokens from USER 'A' and add it to pool i.e TokenFarm
    function stakeTokens(uint _amount) public{

        require(_amount > 0, "amount cannot be 0");
        // To transfer DAI tokens from User 'A' to TokenFarm (pool)
        daiToken.transferFrom(msg.sender, address(this), _amount);

        // Update staking Balance of user 'A' he has in pool
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        //
        if(!hasStaked[msg.sender]){
            //Add user 'A' to stakers like he has got reward now no further reward will be granted to him
            stakers.push(msg.sender);
        }

        //Mark user 'A' as True cause he has staked his amount into pool
        hasStaked[msg.sender] = true;

        //
        isStaking[msg.sender] = true;
    }

    // Issue tokens i.e DAPP Reward
    function issueToken() public{
        require(msg.sender == owner, "caller must be the owner");

        //Iterating in all stakers who have staked their DAI in pool
        for (uint i=0; i<stakers.length; i++) {
            address recipient = stakers[i]; // Take user 'A' from stakers
            uint balance = stakingBalance[recipient]; // take the amount/balance user 'A' has invested in pool
            if(balance > 0) {
                dappToken.transfer(recipient, balance);  // transfer dapp tokens to user 'A'
            }
        }
        
        //For ex. if user 'A' has invested 100 DAI in pool then reward him 100 Dapp tokens
    }

    // Unstake or remove tokens from Pool
    function unstakeTokens() public{
        uint balance = stakingBalance[msg.sender];
        
        require(balance>0, "Staking Balance should be greater than 0");
        daiToken.transfer(msg.sender, balance);

        //set Staking balance to 0
        stakingBalance[msg.sender] = 0;

        //set Staking status to false
        isStaking[msg.sender] = false;
    }
}
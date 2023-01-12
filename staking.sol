// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";//Import openzeppelin ERC20 token to not create our ERC20 token from scratch
contract staking is ERC20{ //Create staking contract and inherit contract to Openzeppelin ERC20 to get the functionalities inside the Openzeppelin contract


mapping(address => uint) public staked;//Create a mapping address with uint named staked, make it public: to map people's address with the amount
mapping(address => uint) private stakedFromTS;//Create another mapping address with uint named stakedfromTimestamp, make it private; so that no one else is able to call this function 
//to map people's address with the starting time of staking 
//Create a Constructor with the token inside —> to be able to initialize the token coming from openzeppelin (cf. line 54 openzeppelin contract)  
constructor() ERC20("Dera Token", "DTK"){ 
_mint(msg.sender, 10**18);//call local variable mint from Openzeppelin: to be able to mint, we need the account (address) of the person that is doing the requirement to mint (msg.sender) + the total amount that will be in that account 

}

function stake(uint amount) public{//Declare a function stake() make it public, and is taking an input from the frontend which is telling how much the person wants to stake with the platform 

    require(amount >0, "Amount is less than 0"); //Check if the person has money to stack, Require that the inputed amount is greater than 0 to have something tangible because it is impossible to stake 0 , else show an error that amount is less than 0 

    require(balanceOf(msg.sender) >= amount, "You do not have up to that amount");//Require that the balance of msg.sender(address of the person that is calling the contract) is greater than or equal to the inputted amount
    //to make sure that he is not trying to stack more than he has in his account 

    _transfer(msg.sender, address(this), amount); //Confirming the transfer to the platform by taking the money out of the person’s account 
    //(from line 115 of Openzeppelin, using the new local variable _transfer)

if(staked[msg.sender] > 0){ //If statement to call the claim function if the person has staked with the platform and check if the staked amount by msg.sender is greater than 0, he has access to the claim function
claim(); 
}

//refers to 2nd mapping stakedfromTS (l.10) capturing when msg.sender is starting to stake —> assign and update the particular time he starts staking to now
stakedFromTS[msg.sender] = block.timestamp;//to keep his record with the staking platform

staked[msg.sender]+= amount;//assign and adding the amount staked to address of msg.sender and 
// recorded amount staked of msg.sender is increased by adding the inputed amount --> adding the amount to the record of the person staking 

}

function unstake(uint amount) public{//Declare function unstake (in case the person has changed his mind and wants his money back), 
//is public and takes in the inputted amount 
    require(amount >0, "Amount is less or equal to 0");//1st requirement to check if the amount inputed is greater than 0, 
    require(staked[msg.sender] >=amount, "You did not stake with us");//2ndly check staked amount by msg.sender is actually greater than 
    //the amount inputed --> to confirm that the person has staked with the platform, else show error 

    _transfer(address(this), msg.sender, amount);//Transfer the money from the balance of the address instance of this contract to msg.sender 

stakedFromTS[msg.sender] = block.timestamp;//Update stakedfromtimestamp to know the exact time the unstake action has taken place
staked[msg.sender] -= amount;// Deducting the inputed amount from msg.sender already staked amount 

}

function claim() public{//Declare claim function to claim the money with the reward 
require(staked[msg.sender] > 0, "You did not stake with us");//1st Check if staked amount is greater than 0, else it will show that 
//the person hasn't stake with the platform

uint secondsStaked = block.timestamp - stakedFromTS[msg.sender];//Create a new variable secondsStake to capture the total time in seconds 
//the person has spent staking on the platform, to know the total period of staking by subtracting now with the time the person has started staking 

uint reward = staked[msg.sender] * secondsStaked / 3.154e7;//variable reward to know the reward: Multiplying the balance amount that was staked 
//by msg.sender with the secondsStake variable (the total period of staking) and dividing it by the number of seconds in a year (because second is the standard unit of time)

_mint(msg.sender, reward);//Call function _mint from ERC20, it is minting the reward into the account of the person that is calling this claim function (msg.sender)
stakedFromTS[msg.sender] = block.timestamp;//update the timestamp the reward was claimed 

}

}



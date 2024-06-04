// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract userss{
   //mapping (address => address[]) public users;
    address[] users; 
    mapping(address => bool) participated;
    uint256 public constant WAIT_BLOCKS_LIMIT = 3 ;
    uint256 public registeredCount ;
    uint256 public _registeredLimit ;
    uint256 constant REGISTERING_PARTICIPANTS = 1;
    uint256 constant REGISTERING_FINISHED = 2;
    uint256 constant WAITING_FOR_RANDOMNESS = 3;
    uint256 constant SOLVING_LOTERRY = 4;
    uint256 constant LOTTERY_SOLVED = 5;
    uint256 public waitingStartBlockNumber;
    bool public lotterySolved;
    
    constructor(uint256 _limit) public{
        waitingStartBlockNumber = 0;
        registeredCount = 0;
        _registeredLimit = _limit;
    }
    
    
    
    function check () public payable{
        
        if(getStage(block.number)==REGISTERING_PARTICIPANTS){
            processAddingUser(msg.sender);
        }
        else{
            if(getStage(block.number)==REGISTERING_FINISHED){
                require(msg.value == 0);
                waitingStartBlockNumber = block.number;
                emit ClosingList(waitingStartBlockNumber);
            }
            else{
                if(getStage(block.number)==WAITING_FOR_RANDOMNESS){
                        require(msg.value == 0);
                        
                        revert();
                }
                else{
                    if(getStage(block.number)==SOLVING_LOTERRY){
                        require(msg.value == 0);
                        processSolvingLottery(block.number);
                    }
                    else{        
                        revert();
                    }
                }
            }
        }
    }
    
    
    function getStage(uint256 blockNum) private view returns(uint256) {
        if(registeredCount<_registeredLimit){
            return REGISTERING_PARTICIPANTS;
        }
        else{
            if(waitingStartBlockNumber==0
                || blockNum-waitingStartBlockNumber>=256 
                ){
                return REGISTERING_FINISHED;
            }
            else
            {
                if(blockNum-waitingStartBlockNumber<WAIT_BLOCKS_LIMIT){
                    return WAITING_FOR_RANDOMNESS;
                }
                else{
                    if(lotterySolved == true){
                        return LOTTERY_SOLVED;
                    }
                    else{
                        return SOLVING_LOTERRY;
                    }
                }
            }
        }
    }
    
    function processAddingUser(address sender) private{
        require(participated[sender]==false);
        require(registeredCount<_registeredLimit);
        participated[sender] = true;
        users.push(sender);
        registeredCount = registeredCount+1;
        emit UserRegistered(sender);
    }
    
    function processSolvingLottery(uint256 blockNum) public   {
        uint256 luckyNumber = uint256(blockhash(waitingStartBlockNumber+WAIT_BLOCKS_LIMIT));
        luckyNumber = luckyNumber % _registeredLimit;
       payable (users).transfer(address(this).balance);
        emit UseRewarded(users[luckyNumber],blockNum);
        lotterySolved = true;
    }
    
    event ClosingList(uint256 blockNum);
    event UserRegistered(address adr);
    event UseRewarded(address adr,uint256 blockNum);
}
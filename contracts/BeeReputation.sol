pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract BeeReputation is Ownable {

    struct PlatformStruct {
        address sharingPlatform;
        bytes32 userId;
    }

    event BootstrapNewUserReputation(address platform, bytes32 userId, uint8 initialRepScore);
    event UpdateUserReputation(address platform, bytes32 userId, uint8 newRepScore);

    // whitelist platforms
    mapping(address => PlatformStruct) public whitelistedPlatforms;
    // userId mapped to platform specific rep score
    mapping(bytes32 => mapping(address => uint8)) public reputation;
    mapping(bytes32 => uint8) public averageReputation;
    // platform admins
    mapping(address => address) public platformAdmins;

    function BeeReputation() public {
        //TODO: initilize with bootstrap reputation
    }

    function addPlatformToWhitelist(address _platform, address _admin) public onlyOwner {
        //TODO: add platform and admin addresses
    }

    function updateReputation(address _platform, bytes32 _userId, uint8 _newScore) public onlyOwner returns(bool success) {
        // TODO: check for whitelistedPlatforms and admin
        require(_newScore > 0);
        if(reputation[_userId][_platform] > 0) {
            reputation[_userId][_platform] = _newScore;
            UpdateUserReputation(_platform, _userId, _newScore);
        } else if(reputation[_userId][_platform] == 0){
            reputation[_userId][_platform] = _newScore;
            BootstrapNewUserReputation(_platform, _userId, _newScore);
        } else return false;

        return true;
        // check address of score to be updated
        // update specified score

    }

    function remove(address platform) public onlyOwner {
        // remove specified platform from reputation system
        revert();
    }

    // User needs to call approve on token address before calling
    function boostReputationWithBees(uint256 amount) public {
        ERC20 tokenContract = ERC20(beeTokenAddress);
        require(tokenContract.transferFrom(msg.sender, this, amount));
    }

    function ownerWithdrawBee() external onlyOwner {
        ERC20 tokenContract = ERC20(beeTokenAddress);
        uint256 tokenBalance = tokenContract.balanceOf(this);
        require(tokenContract.transfer(owner, tokenBalance));
    }

    function ownerWithdrawEther() external onlyOwner {
        owner.transfer(this.balance);
    }

    function checkPlatfomReputation(address _platform, bytes32 _userId) public view returns(uint8 repScore) {
        // spit out the reputation score of an individual
        uint8 userScore = reputation[_userId][_platform];
        return userScore;
    }

    function checkAvgReputation(bytes32 _userId) public view returns(uint8 repScore) {
        uint8 avgScore = averageReputation[_userId];
        return avgScore;
    } 

}

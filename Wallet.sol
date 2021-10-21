pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Wallet {
    /*
     Exception codes:
      100 - message sender is not a wallet owner.
      101 - invalid transfer value.
    */

    uint16 constant WITHOUT_COMMISION = 0;
    uint16 constant WITH_COMMISION = 1;
    uint16 constant SEND_ALL_AND_DESTROY = 160;

    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
        tvm.accept();
        _;
    }

    function sendWithoutMyCommission(address dest, uint128 value, bool bounce) public checkOwnerAndAccept{
        // This function will send value without commision at your expense
        dest.transfer(value, bounce, WITHOUT_COMMISION);
    }

    function sendWithMyCommission(address dest, uint128 value, bool bounce) public checkOwnerAndAccept{
        // This function will send value with commision at your expense
        dest.transfer(value, bounce, WITH_COMMISION);
    }

    function sendAllBalanceAndDestroy(address dest, uint128 value, bool bounce) public checkOwnerAndAccept{
        // This function will send all balance value and then destroy account
        // contract's status will be "Not initialized"
        dest.transfer(value, bounce, SEND_ALL_AND_DESTROY);
    }
}

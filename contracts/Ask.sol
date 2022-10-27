// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Interfaces.sol";
import "./PhatRollupReceiver.sol";

contract Ask is PhatRollupReceiver, AskReply, Ownable {

    /// @dev indicate req count
    uint next = 0;

    /// @dev Hash of expected reply parameters are kept to verify that
    /// the response will be done with the correct parameters.
    mapping(uint => bytes32) private askIdToProof;

    /// @dev mapping id to reply address and fn
    mapping(uint => address) private askIdToReplyTo;
    mapping(uint => bytes4) private askIdToFn;

    /// @dev mapping anchor address, so we can use it to check the sender 
    mapping(uint => address) private askIdToAnchor;

    /// @dev ask fn will push request to PhatQueuedAnchor contract
    /// contract address and fn selector should be passed in for callback
    function ask(
        address anchor,
        address replyTo, // caller's address/ football gambling contract
        bytes4 fn, // callback function
        bytes calldata payload//request data
    ) external override returns (uint askId) {
        // TODO check subscriber

        require(anchor != address(0), "anchor address not set");
        require(
            replyTo != address(this),
            "replyTo address cannot be Ask contract"
        );
        uint id = next;

        askIdToReplyTo[id] = replyTo;
        askIdToFn[id] = fn;

        askIdToProof[id] = keccak256(abi.encodePacked(id, replyTo, fn));

        IPhatQueuedAnchor(anchor).pushRequest(abi.encode(id, payload));

        next++;
        return id;
    }

    function onPhatRollupReceived(address _from, bytes calldata payload)
        public
        override
        returns (bytes4)
    {

        (
            uint id,
            bytes memory data
        ) = abi.decode(payload, (uint, bytes));

        address anchor = askIdToAnchor[id];

        require(anchor == _from, "wrong msg sender");

        address replyTo = askIdToReplyTo[id];
        bytes4 fn = askIdToFn[id];


        require(
            keccak256(abi.encodePacked(replyTo, fn)) == askIdToProof[id],
            "Invalid reply"
        );

        (bool ok, bytes memory ack) = replyTo.call(
            abi.encodeWithSelector(fn, data)
        );

        delete askIdToProof[id];
        delete askIdToReplyTo[id];
        delete askIdToFn[id];

        if (ok) {
            emit Replied(_from, ack);
        } else {
            emit FailedReply(
                _from,
                "reply to caller contract fn failed"
            );
        }
        return ROLLUP_RECEIVED;
    }
}

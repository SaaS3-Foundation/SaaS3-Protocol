// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Interfaces.sol";

contract Ask is AskReply, Ownable {

    /// @dev indicate req count
    uint public next = 0;

    /// @dev mapping id to reply address and fn
    mapping(uint => address) private askIdToReplyTo;
    mapping(uint => bytes4) private askIdToFn;

    /// @dev mapping anchor address, so we can use it to check the sender 
    mapping(uint => address) private askIdToAnchor;

    /// @dev ask fn will push request to PhatQueuedAnchor contract
    /// contract address and fn selector should be passed in for callback
    function ask(
        address anchor,
        address replyTo,
        bytes4 fn,
        bytes calldata payload
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

        emit Asked (
            anchor,
            id,
            address(this),
            replyTo,
            fn,
            abi.encode(id, payload)
        );

        next++;
        return id;
    }

    function reply(uint256 id, bytes calldata payload) external override {

        address replyTo = askIdToReplyTo[id];
        require(replyTo != address(0), "replyTo address not found");

        bytes4 fn = askIdToFn[id];
        require(fn != bytes4(0), "callback fn not found");

        (bool ok, bytes memory ack) = replyTo.call(
            abi.encodeWithSelector(fn, payload)
        );

        delete askIdToReplyTo[id];
        delete askIdToFn[id];

        address anchor = askIdToAnchor[id];
        if (ok) {
            emit Replied(anchor, ack);
        } else {
            emit FailedReply(
                anchor,
                "reply to caller contract fn failed"
            );
        }
    }
}

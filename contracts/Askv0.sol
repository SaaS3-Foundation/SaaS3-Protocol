// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Interfaces.sol";

contract Askv0 is IsAsking, Mo, Ownable {
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
        require(replyTo != address(0), "replyTo address not set");
        require(
            replyTo != address(this),
            "replyTo address cannot be Ask contract"
        );
        require(
            fn == bytes4(keccak256("reply(uint256,bytes)")),
            "invalid callback fn"
        );

        uint id = next;

        askIdToReplyTo[id] = replyTo;
        askIdToFn[id] = fn;

        emit Asked(anchor, id, replyTo, fn, payload);

        next++;
        return id;
    }

    function reply(uint256 id, bytes calldata payload)
        external
        override
        onlyOwner
    {
        address replyTo = askIdToReplyTo[id];
        require(replyTo != address(0), "replyTo address not found");

        bytes4 fn = askIdToFn[id];
        require(fn != bytes4(0), "callback fn not found");

        (bool ok, bytes memory ack) = replyTo.call(
            abi.encodeWithSelector(fn, payload)
        );

        // delete it anyway
        // we won't reply it again
        // requester should re-ask if needed
        delete askIdToReplyTo[id];
        delete askIdToFn[id];

        if (ok) {
            emit Replied(id, address(this), replyTo, fn, payload);
        } else {
            emit ReplyFailed(
                id,
                address(this),
                replyTo,
                fn,
                string(ack),
                payload
            );
        }
    }
}

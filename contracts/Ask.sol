// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Interfaces.sol";
import "./PhatRollupReceiver.sol";

contract Ask is PhatRollupReceiver, IsAsking, Ownable {
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
        address replyTo,
        bytes4 fn,
        bytes calldata payload
    ) external override returns (uint askId) {
        require(anchor != address(0), "anchor address not set");
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

        askIdToAnchor[id] = anchor;

        IPhatQueuedAnchor(anchor).pushRequest(abi.encode(id, payload));

        next++;
        return id;
    }

    function onPhatRollupReceived(address _from, bytes calldata payload)
        public
        override
        returns (bytes4)
    {
        (uint id, bytes memory data) = abi.decode(payload, (uint, bytes));

        address anchor = askIdToAnchor[id];

        require(msg.sender == anchor, "wrong msg sender, not anchor!");

        address replyTo = askIdToReplyTo[id];
        bytes4 fn = askIdToFn[id];

        (bool ok, bytes memory ack) = replyTo.call(
            abi.encodeWithSelector(fn, id, data)
        );

        if (!ok) {
            emit ReplyFailed(id, _from, replyTo, fn, string(ack), payload);
        } else {
            emit Replied(id, _from, replyTo, fn, payload);
        }

        delete askIdToReplyTo[id];
        delete askIdToFn[id];

        return ROLLUP_RECEIVED;
    }
}

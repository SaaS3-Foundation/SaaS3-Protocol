//SPDX-License-Identifier: MIT
// This demo contract is generated automatically by saas3
// EDIT it to adapt to your own dAPI
pragma solidity 0.8.9;
import "./Ask.sol";

contract SimpileTest {
    int public price;

    address private saas3;

    constructor(address _addr) {
      saas3 = _addr;   
   }

    function get_price(
        address anchor,
        bytes calldata parameters
    ) external {
        // check msg sender
        Ask c = Ask(saas3);
        // you can hardcode paramters
        // bytes memory parameters = bytes("...");

        c.ask(
            anchor,
            address(this), //
            this.anything.selector, // 
            parameters);// ethereum, usd, ethereum.usd
    }

    function anything(bytes calldata data) public {
        // decode the data here
        price = abi.decode(data, (int));
    }

}





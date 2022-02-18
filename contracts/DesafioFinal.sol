// SPDX-License-Identifier: MIT

// > 1. Tratamos siempre de usar un rango de versiones para evitar errores de incompatibilidad.
// pragma solidity ^0.8.0;
// > 1. refactor:
pragma solidity >=0.7.0 <0.9.0;

contract Desafio {
    // > 2. Las variables privadas no son tan privadas asi que la quitamos y usamos otra validacion.
    // uint256 private pin;
    // > 2a. refactor:
    address owner;
    mapping(address => uint256) balances;

    // > 2b.
    // constructor(uint256 ownerPin) {
    //     pin = ownerPin;
    // }

    // > 2b. refactor:
    constructor() {
        owner = msg.sender;
    }

    // > 2c.
    // function min(uint256 ownerPin, uint256 amount) public {
    //     require(pin == ownerPin, "El pin no es correcto");
    //     balances[msg.sender] += amount;
    // }

    // 2c. refactor:
    function mint(uint256 amount) public {
        require(owner == msg.sender, "El usuario no es el owner.");
        balances[msg.sender] += amount;
    }

    function depositar() public payable {
        balances[msg.sender] += msg.value;
    }

    // > 3. Funcion vulnerable a reentrancy
    // function retirar() public {
    //     require(balances[msg.sender] > 0);
    //     msg.sender.call{value: balances[msg.sender]}("");
    //     balances[msg.sender = 0];
    // }

    // > 3a. refactor:
    function retirar() public {
        require(balances[msg.sender] > 0);
        uint256 monto = balances[msg.sender];
        balances[msg.sender] = 0; // movemos esta linea para evitar reentrancy.
        (bool resultado, ) = msg.sender.call{value: monto, gas: 1000000}(""); // ajustamos el gas limit.
        if (!resultado) revert(); // agregamos una excepcion para revertirlo.
    }
}

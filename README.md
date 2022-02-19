# 📝 Notas del Curso de Seguridad en Smart Contracts

@SebastianPerez

- Clase1: [Importancia de la seguridad en el desarrollo de contratos](#Importancia-de-la-seguridad-en-el-desarrollo-de-contratos)
- Clase2: [Buenas prácticas](#Buenas-prácticas)
- Clase3: [Problema con tx.origin](#Problema-con-tx.origin)
- Clase4: [Dependencia con timestamp](#Dependencia-con-timestamp)
- Clase5: [Overflow y underflow](#Overflow-y-underflow)
- Clase6: [Variables privadas](#Variables-privadas)
- Clase7: [DelegateCall](#DelegateCall)
- Clase8: [Gas insuficiente](#Gas-insuficiente)
- Clase9: [Forzar envío de Ethers](#Forzar-envío-de-Ethers)
- Clase10: [Reentrancy simple](#Reentrancy-simple)
- Clase11: [Reentrancy cruzado](#Reentrancy-cruzado)
- Clase12: [Denegación por reversión](#Denegación-por-reversión)
- Clase13: [Denegación por límite de gas](#Denegación-por-límite-de-gas)
- Clase14: [Desafío](#Desafío)
- Clase15: [Respuestas](#Respuestas)

## Importancia de la seguridad en el desarrollo de contratos

- Inmutabilidad
- Incentivos económicos
- Confianza

## Buenas prácticas

### Cosas a tener en cuenta

#### Controlar el uso de gas, es controlar el uso de nuestros contratos

Una correcta utilización del gas hace que los métodos, funciones y el uso de nuestro contrato sea aprovechado al máximo, que sea muy eficiente y que ayude a reducir costos a nivel financiero, sobre todo evitar posibles usos incorrectos del gas, por ejemplo si  exponemos una llamada externa en nuestros contratos, vamos a evitar que puedan hacer excesivas operaciones con el control correcto del gas, por lo tanto siempre que se pueda en una llamada externa hay que poner un limite de gas, un tope, para que justamente el contrato o el código que se vaya a utilizar luego de la llamada externa no aproveche esta utilización del gas para hacer algo malintencionado.

También tenemos a mano las librerías, lo bueno de las librerías es que no tenemos que reinventar la rueda, es decir, cuando vamos a escribir un código, para resolver determinada operación, no tenemos que replantearnos y volver a escribir todo el desarrollo, sino que podemos aprovechar estos contratos que ya están escritos, y están auditados, entonces es una gran medida de seguridad para poder utilizar y sobre todo ganar tiempo a nivel de desarrollo, no olvidemos que muchas de estas librerías que están publicadas hoy, están hechas por desarrolladores que son expertos.

#### Control de accesos

El control de Acceso va a limitar que un usuario que no tenga permisos pueda ejecutar funciones en nuestros contratos, sobre todo esto va a prevenir que de repente en un token pueda venir un usuario y pueda emitir monedas sin ser administrador/owner por lo tanto, tomar estas medidas y controlar el correcto uso del contrato a nivel de roles y permisos es una gran medida de seguridad para prevenir que estos usuarios accedan y ejecuten acciones que no queremos en nuestros contratos

#### Bloquear el contrato

Imaginemos que ocurre algún problema o detectamos alguna falla o comportamiento indebido en el uso del contrato, automáticamente podemos bloquear el contrato, podemos dejar en pausa y podemos tomar alguna medida al respecto: ej, tratar de actualizar una version distinta al contrato para no perder la información y también arreglar el error o simplemente evitar que una falla o vulnerabilidad siga siendo atacada, entonces podemos poner en pausa nuestro contrato

#### Tenemos que tener en cuenta

Si aplicamos gestión de permisos, de roles, o simplemente bloqueamos el contrato, vamos a estar atentando contra la descentralizarían del mismo, entonces aca tenemos que ser muy cuidadosos en que nuestro proyecto, nuestro contrato no se convierta en algo descentralizado si no deseamos que asi sea, lo mejor para los escenarios descentralizados es justamente que la misma red, o participantes gestionen que todo funcione de forma correcta, pero en algunos casos el control de acceso nos va a servir de gran manera

#### Transferencias y Hook

Un tema fundamental a la hora de interactuar con los distintos contratos en la red son las transferencias y las funciones que reciben transferencias de parte de los contratos, por lo tanto son conceptos que tenemos que entender bien en profundidad, muchos de los ataques vienen por el lado de no conocer a fondo por no saber como se realizan estas transacciones o como se realizan a nivel de seguridad, por ej establecer un limite de gas, entonces entendiendo muy bien el flujo de transferencias y de recepción de ethers en la red, evita que nuestros contratos tengan muchísimos factores de ataques de los que están siendo explotados y que nosotros podamos prevenir entendiendo bien conceptos

## Problema con tx.origin

Esto, más que un problema, es una precaución que debemos tener por una vulnerabilidad que tiene que ver con el ***“origen de una transacción”***. Para esto, vamos a remarcar una de las variables que están disponibles en Solidity, relacionada con la transacción: tx.origin, la cual nos informa sobre el origen de una posible transacción.

Diferencias

- **tx.origin** = el origen del mensaje
- **msg.sender** = emisor del mensaje

A simple vista pueden parecer exactamente iguales, porque a la hora de hacer una transferencia de cuenta a cuenta van a devolver el mismo valor, pero qué pasa si, tenemos un usuario que es dueño de un contrato (a través de una cuenta, claramente) y le establece permisos de acceso, cuestión de que solamente esa cuenta pueda acceder al contrato; esta validación de permisos, si se hace con “tx.origin” puede dar un valor distinto al “msg.sender” si la llamada se hace a través de un contrato.

Por ejemplo, en vez de llamar a un contrato que está protegido desde una cuenta, imaginemos el camino en que el dueño del contrato, interactúa con un contrato intermediario, es decir, así como tenemos los problemas de phishing en la red de internet donde un usuario “cae en una trampa”, en este caso, nosotros sin saberlo podemos interactuar o realizar una transacción con un contrato que tiene código malicioso, y este contrato puede realizar una llamada al contrato que está protegido, entonces qué pasa… a la hora de realizar esta segunda transacción, cuando reciba la transacción el contrato protegido, va a recibir valores distintos para el “origen de la transacción” y el “envío del mensaje”. El “envío del mensaje” va a indicar que la dirección es la del contrato intermediario, pero el “origen de la transacción” sigue siendo la cuenta original.

Por lo tanto, si el chequeo del permiso lo hacemos contra “tx.origin” lo que vamos a tener es la cuenta del usuario, y por ende, nos va a dar la “sensación” de que está accediendo el usuario, y que tiene permisos para hacerlo, cuando en realidad quien está accediendo es un contrato intermediario.

En definitiva, el uso de “tx.origin” para el chequeo de permisos y de roles puede ser un problema.

## Dependencia con timestamp

Una solución segura para ese problema de generar números aleatorios es haciendo uso de Oracles, recordemos que la blockchain de Ethereum es determinista.

## Overflow y underflow

El problema de los límites. La falla de overflow y underflow ocurre solamente en variables de tipo “enteras”. Pensemos en el “contador de km” o el “contador de visitas” el cual es un contador secuencial que va sumando e incrementando valores enteros de forma que cuando se alcanza el máximo valor posible representable en el contador, vuelve a empezar de cero. Por ejemplo, llegamos al máximo “999” y al siguiente incremento volvemos a iniciar de “000”. Lo mismo ocurre si volvemos hacia atrás, de “000” disminuimos un valor, nos vamos al máximo posible de este ejemplo que sería “999”.

En el caso de las variables enteras va a suceder lo mismo, porque si almacenamos un valor en cero y le restamos uno, nos iremos al máximo valor posible representable en ese tipo de variable, y eso va a depender del tamaño de número entero que hayamos elegido. Y viceversa.

Esto llevado a un balance, es una falla muy grave, dado que ocurriría que un balance en cero, pasaría a tener el máximo valor representable. Esto aplica a los números enteros, no importa si es con signo positivo o negativo.

Afortunadamente, desde la versión 0.8 de Solidity, este problema ya está resuelto por el “compilador”, es decir, si tenemos alguna operación con un número entero que tiene el problema de overflow, ya el “compilador” ejecuta una acción de error, por lo tanto no tenemos que preocuparnos.

Pero qué pasa… en el mundo de contratos inteligentes, encontraremos muchos contratos que están implementados en versiones anteriores del compilador y que, lamentablemente, aún cuentan con este problema.

De modo que la solución es:

- Actualizar el compilador a las últimas versiones, y llevar los contratos a la versión del compilador,
- Utilizar librerías para operar de manera segura.

## Variables privadas

- Nada es realmente privado.

> Links:
>
> - [https://github.com/platzi/curso-seguridad-smart-contracts/tree/main/contratos](https://github.com/platzi/curso-seguridad-smart-contracts/tree/main/contratos)

## DelegateCall

Tenemos la posibilidad de llamar a contratos externos desde nuestro contrato, hacer llamadas externas por medio de la función call, call va a permitir realizar un parámetro que a traves de la firma que tiene, va a poder localizar una función que esta localizada en otro contrato y ejecutarla asi como si estuviera en nuestro contrato, esto se llama llamada externa, también podemos enviar saldo, mintear el gas, etc.

¿Que pasa cuando hacemos este tipo de llamadas? Todo el código que esta alojado en el código externo, se aloja en un contexto separado del nuestro, es decir, va a tener sus propias variables, su propia ejecución que no va a estar ligada al nuestro, es lo esperable si hacemos una llamada externa, queremos que se ejecute en su propio contexto y que después nos devuelva el resultado deseado.

Existe una llamada similar a call, en sentido de estructura, por ejemplo delegateCall no permite enviar transacciones, pero si permite llamar a funciones que esta en otro contrato, y la diferencia esta llamada que hacemos al otro contrato por medio de delegateCall trabajan en el contexto del contrato original, es decir si modificamos una variable o si llamamos a una función, vamos a estar haciéndolo sobre el contrato original, asi que tenemos que muchísimo cuidado al usar delegateCall.

## Gas insuficiente

> Links:
>
> - [https://github.com/platzi/curso-seguridad-smart-contracts/blob/main/contratos/GasInsuficiente.sol](https://github.com/platzi/curso-seguridad-smart-contracts/blob/main/contratos/GasInsuficiente.sol)

## Forzar envío de Ethers

- **NO USAR** la función **SelfDestruct**, esta función transfiere los fondos del contrato a otra cuenta y luego elimina el contacto de la red. El problema es que no hay garantías de que suceda de ese modo, ya se de que transfiera los fondos como de que se elimine por completo de la red, incluso puede llegar a eliminarse de algunos nodos y de otros no, generando luego problemas al sincronizar...

## Reentrancy simple

***Reentrancy simple:*** ataca a una función especifica llamándola nuevamente antes de cerra su ejecución, creando un ciclo hasta vaciar la cuenta.

> Links:
>
> - [https://github.com/platzi/curso-seguridad-smart-contracts/blob/main/contratos/Reentrancy.sol](https://github.com/platzi/curso-seguridad-smart-contracts/blob/main/contratos/Reentrancy.sol)

## Reentrancy cruzado

***Reentrancy cruzado:*** ataca primero a una función usándola como llave de entrada al contrato, para poder atacar a una segunda función y asi poder acreditarle fondos a alguna cuenta.

> Links:
>
> - [https://github.com/platzi/curso-seguridad-smart-contracts/blob/main/contratos/ReentrancyCross.sol](https://github.com/platzi/curso-seguridad-smart-contracts/blob/main/contratos/ReentrancyCross.sol)

## Denegación por reversión

El contrato atacante utiliza la función revert() para interrumpir el correcto funcionamiento de nuestro contrato.

> Links:
>
> - [https://github.com/platzi/curso-seguridad-smart-contracts/blob/main/contratos/DoS.sol](https://github.com/platzi/curso-seguridad-smart-contracts/blob/main/contratos/DoS.sol)

## Denegación por límite de gas

...

## Desafío

Ver ```./contracts/DesafioFinal.sol```

> Links:
>
> - [https://github.com/platzi/curso-seguridad-smart-contracts/blob/main/contratos/DesafioFinal.sol](https://github.com/platzi/curso-seguridad-smart-contracts/blob/main/contratos/DesafioFinal.sol)
> - [Juego para hackear SmartContracts - https://capturetheether.com/](https://capturetheether.com/)

---

## Respuestas

### ***1. ¿Por qué es importante escribir correctamente los contratos que se implementan en la red de Ethereum?***

✅ Porque no se puede alterar su código fuente una vez subido.

### ***2. ¿Qué medida podemos tomar para controlar el gas en una llamada externa?***

✅ Establecer un límite de gas.

### ***3. ¿Por qué conviene utilizar librerías?***

✅ Porque su código ya ha sido probado y auditado.

### ***4. ¿Qué rol es habitual para el control de acceso a un contrato?***

✅ Owner

### ***5. ¿Qué modificador define que una función puede recibir pagos en Ether?***

✅ payable

### ***6. ¿En qué caso se diferencian tx.origin y msg.sender?***

✅ Cuando el contrato es llamado por otro contrato.

### ***7. ¿Por qué no es bueno utilizar el timestamp del bloque para operaciones críticas?***

✅ Porque se puede manipular su valor.

### ***8. ¿Qué tipo de dato era afectado por Overflow y Underflow?***

✅ int

### ***9. ¿Qué función de web3 devela el contenido del almacenamiento del contrato?***

✅ getStorageAt

### ***10. ¿Que característica tiene la llamada delegatecall?***

✅ No permite value como parámetro

### ***11. ¿Qué debemos hacer para prevenir el problema del gas insuficiente?***

✅ Controlar el retorno de la llamada externa.

### ***12. ¿Cómo se llama la función que puede enviar Ether salteando las funciones de recepción de Ether de los contratos?***

✅ selfdestruct

### ***13. ¿Qué error facilita el ataque de reentrancy?***

✅ Modificar el estado del contrato al final de la función

### ***14. ¿Qué característica deben tener dos funciones para que se pueda realizar un Reentrancy Cruzado?***

✅ Deben compartir el mismo estado

### ***15. ¿Cómo se evita una denegación de servicio por reversión?***

✅ Separando las llamadas externas de la modificación del estado del contrato.

### ***16. ¿Qué pasa si el límite de gas es menor al gas requerido por una función en tiempo de ejecución?***

✅ La función no se ejecutará en su totalidad y es probable que se revierta.

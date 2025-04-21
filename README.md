# Proyecto Racket

**Lenguajes y Paradigmas**  
**Docente: El JuanGui**

### Integrantes

- Felipe Villa Jaramillo
- Luis Pablo Goez
- Juan Pablo Cardona Bedoya

## Implementación de un Carrito de Compras con Perfiles en Racket

### Descripción del Proyecto

Este proyecto implementa una aplicación en Racket que simula un carrito de compras con dos tipos de perfiles de usuario: **Cliente** y **Vendedor**. La aplicación permite gestionar un inventario de productos, realizar compras simuladas y manejar un sistema de inicio de sesión con credenciales predefinidas en el código.

#### Estructura del Proyecto

1. **Perfiles de Usuario**

   - **Cliente:** Representado mediante la estructura `(client id username password balance)`, donde se almacena un identificador único, nombre de usuario, contraseña y saldo disponible.
   - **Vendedor:** Representado mediante la estructura `(seller id username password)`, que incluye un identificador único, nombre de usuario y contraseña.

2. **Productos**

   - Los productos están definidos mediante la estructura `(product id name price stock seller-id)`, que incluye un identificador único, nombre, precio, cantidad en stock y el identificador del vendedor que los agregó.

3. **Inventario**

   - El inventario es una lista de productos gestionada mediante una variable de parámetro (`inventory`).

4. **Funciones Principales**

   - **Inicio de Sesión:** La función `login` permite autenticar a los usuarios (clientes o vendedores) mediante sus credenciales.
   - **Gestión del Inventario:**
     - `view_inventory`: Permite visualizar los productos disponibles en el inventario.
     - `add_inventory`: Permite al vendedor agregar nuevos productos al inventario.
     - `remove_inventory`: Permite al vendedor eliminar productos del inventario.
   - **Carrito de Compras:**
     - Funciones como `view_car`, `add_car`, `remove_car` y `pay` están definidas para manejar el carrito de compras del cliente, aunque aún requieren implementación completa.
   - **Simulación de Pago:** Calcula el total de los productos en el carrito y verifica si el cliente tiene suficiente saldo para completar la transacción.

5. **Interfaz de Usuario**

   - La interacción con el usuario se realiza mediante un menú en consola que permite navegar entre las opciones disponibles para clientes y vendedores.

6. **Flujo Principal**
   - La función `shopping_car` gestiona el flujo principal de la aplicación, permitiendo a los usuarios iniciar sesión, acceder a las funcionalidades según su perfil y cerrar sesión.

---

## Pautas del trabajo

Desarrolla una aplicación en Racket que simule un carrito de compras con dos tipos de perfiles de usuario:

- **Cliente:** Quién inicia sesión con un usuario y contraseña definidos directamente en el código y realiza compras de productos agregados por el vendedor. El cliente puede añadir varios productos al carrito y realizar la simulación de pagar dichos productos, verificando que tenga suficiente dinero en una cuenta simulada.
- **Vendedor:** Quién agrega productos con sus respectivos precios al sistema. (Solo debe ser uno).

---

### Requisitos:

- Implementar un sistema de inicio de sesión para el cliente y vendedor con credenciales quemadas en el código.
- Crear funcionalidades para que el vendedor agregue productos y elimine los productos con nombre y precio.
- Permitir al cliente agregar o eliminar productos al carrito.
- Ver el total de productos a pagar con su valor total a pagar.
- Implementar la simulación del proceso de pago, verificando si el cliente tiene suficiente dinero en su cuenta.
- Informar el éxito o el fallo de la transacción y actualizar el saldo de la cuenta del cliente en caso de éxito.

---

### Funcionalidades:

#### **Vendedor:**

- Iniciar sesión con usuario y contraseña.
- Añadir o eliminar productos al inventario, cada producto con un nombre único y precio.
- Visualizar los productos disponibles en el inventario.

#### **Cliente:**

- Iniciar sesión con usuario y contraseña.
- Visualizar los productos disponibles para la compra.
- Agregar o eliminar productos al carrito.

#### **Simular el proceso de pago:**

- Calcular el total de los productos en el carrito.
- Verificar que el saldo en la cuenta sea suficiente.
- Actualizar el saldo en caso de transacción exitosa.

---

### Sugerencias:

- Utiliza estructuras y listas para representar los perfiles, productos, carrito e inventario.
- Implementa funciones para manejar la lógica de inicio de sesión, agregar productos, calcular el total y simular el pago.
- Incluye mensajes descriptivos para informar al usuario sobre el estado de la transacción.

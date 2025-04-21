#lang racket

(struct client (id username password balance))
(struct seller (id username password))
(struct product (id name price stock seller-id))

(define users
  (list
   (client 1 "luis_goez" "1411" 1000000)
   (client 2 "felipe" "123" 500000)
   (client 3 "pablo" "1234" 100000)
   (seller 1 "juangui" "123")))

(define inventory
  (make-parameter
   (list
    (product 101 "Camiseta negra" 30000 10 1)
    (product 102 "Gorra azul" 15000 20 1)
    (product 103 "Zapatos deportivos" 120000 5 1))))


(define (login username password)
  (define (check-user u)
    (cond
      [(client? u)
       (if (and (string=? (client-username u) username)
                (string=? (client-password u) password))
           (list "client" u)
           #f)]
      [(seller? u)
       (if (and (string=? (seller-username u) username)
                (string=? (seller-password u) password))
           (list "seller" u)
           #f)]
      [else #f]))
  (let loop ((lst users))
    (cond
      [(empty? lst) #f]
      [(check-user (first lst)) => (lambda (res) res)]
      [else (loop (rest lst))])))

(define (view_inventory user-type)
  (define inv (inventory))
  (if (null? inv)
      (displayln "El inventario está vacío.")
      (for-each
       (lambda (p)
         (cond
           [(string=? user-type "seller")
            (printf "ID: ~a | Producto: ~a | Precio: ~a | Stock: ~a | Vendedor ID: ~a~n"
                    (product-id p)
                    (product-name p)
                    (product-price p)
                    (product-stock p)
                    (product-seller-id p))]
           [(string=? user-type "client")
            (printf "Producto: ~a | Precio: ~a~n"
                    (product-name p)
                    (product-price p))]))
       inv)))


(define (add_inventory)
  (display "ID del producto: ")
  (define id (read))
  (read-line)
  (display "Nombre del producto: ")
  (define name (read-line))
  (display "Precio del producto: ")
  (define price (read))
  (read-line)
  (display "Cantidad en stock: ")
  (define stock (read))
  (read-line)
  (display "ID del vendedor: ")
  (define seller-id (read))
  (read-line)
  (define new-product (product id name price stock seller-id))
  (inventory (cons new-product (inventory)))
  (displayln "Producto añadido exitosamente."))

(define (remove_inventory)
  (display "Ingrese el ID del producto a eliminar: ")
  (define id (read))
  (read-line)
  (define new-inv
    (filter (lambda (p) (not (= (product-id p) id))) (inventory)))
  (inventory new-inv)
  (displayln "Producto eliminado exitosamente."))

(define (view_car) (displayln "Visualizar carrito"))
(define (add_car) (displayln "Añadir al carrito"))
(define (remove_car) (displayln "Eliminar del carrito"))
(define (pay) (displayln "Pagar"))

(define (shopping_car)
  (let loop ()
    (displayln "\n--- Tienda Fe_Lu_Pa ---")
    (displayln "1. Iniciar sesión")
    (displayln "2. Salir")
    (display "Ingresa lo que deseas hacer: ")
    (define option (read))
    (read-line)
    (cond
      [(= option 1)
       (displayln "\nBienvenido a Tienda Fe_Lu_Pa")
       (display "Usuario: ")
       (define username (read-line))
       (display "Contraseña: ")
       (define password (read-line))
       (define result (login username password))
       (if result
           (let* ([type (first result)]
                  [data (second result)]
                  [msj (if (string=? type "client")
                           (string-append "Bienvenido " type ": " (client-username data))
                           (string-append "Bienvenido " type ": " (seller-username data)))])
             (displayln "\nInicio de sesión exitoso.")
             (displayln msj)
             (cond
               [(string=? type "seller")
                (let seller-loop ()
                  (displayln "\nMenú Vendedor:")
                  (displayln "1. Visualizar inventario")
                  (displayln "2. Añadir al inventario")
                  (displayln "3. Eliminar del inventario")
                  (displayln "4. Cerrar sesión")
                  (display "Ingrese la opción que deseas: ")
                  (define option2 (read))
                  (read-line)
                  (cond
                    [(= option2 1) (view_inventory "seller") (seller-loop)]
                    [(= option2 2) (add_inventory) (seller-loop)]
                    [(= option2 3) (remove_inventory) (seller-loop)]
                    [(= option2 4) (displayln "Sesión cerrada.")]
                    [else (displayln "Opción inválida.") (seller-loop)]))]
               [else
                (let client-loop ()
                  (displayln "\nMenú Cliente:")
                  (displayln "1. Visualizar productos")
                  (displayln "2. Visualizar carrito")
                  (displayln "3. Añadir al carrito")
                  (displayln "4. Eliminar del carrito")
                  (displayln "5. Pagar carrito")
                  (displayln "6. Cerrar sesión")
                  (display "Ingrese la opción que deseas: ")
                  (define option2 (read))
                  (read-line)
                  (cond
                    [(= option2 1) (view_inventory "client") (client-loop)]
                    [(= option2 2) (view_car) (client-loop)]
                    [(= option2 3) (add_car) (client-loop)]
                    [(= option2 4) (remove_car) (client-loop)]
                    [(= option2 5) (pay) (client-loop)]
                    [(= option2 6) (displayln "Sesión cerrada.")]
                    [else (displayln "Opción inválida.") (client-loop)]))]))
           (displayln "Credenciales inválidas"))
       (loop)]
      [(= option 2)
       (displayln "Chao")]
      [else
       (displayln "ERROR: Opción no válida")
       (loop)])))

(shopping_car)
